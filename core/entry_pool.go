package core

import (
	"bytes"
	"fmt"
	"net/netip"
	"net/url"
	"regexp"
	"strconv"

	"github.com/metacubex/mihomo/component/age"
	"go.yaml.in/yaml/v3"
)

const (
	entryPoolKey           = "x-tianji-entry-pool"
	ageEncryptedHeader     = "-----BEGIN AGE ENCRYPTED FILE-----"
	maxEntryPoolCandidates = 64
)

var entryPoolIDPattern = regexp.MustCompile(`^[A-Za-z0-9_-]{1,32}$`)

type entryPoolOptions struct {
	url       string
	interval  int
	timeout   int
	tolerance int
	entries   []entryPoolEntry
}

type entryPoolEntry struct {
	id     string
	server string
	port   int
}

// expandTianjiEntryPools turns explicitly opted-in endpoint pools into native
// URL-test groups. The extension field is removed, making the result safe for
// mihomo's ordinary parser and for config.yaml reloads.
func expandTianjiEntryPools(buf []byte) ([]byte, bool, error) {
	plain, err := decryptEntryPoolInput(buf)
	if err != nil {
		return nil, false, err
	}
	if !bytes.Contains(plain, []byte(entryPoolKey)) {
		return plain, false, nil
	}
	var document yaml.Node
	if err := yaml.Unmarshal(plain, &document); err != nil {
		return nil, false, err
	}
	if !containsEntryPoolKey(&document) {
		return plain, false, nil
	}
	if err := validateEntryPoolDocument(&document); err != nil {
		return nil, false, err
	}
	root, err := documentMapping(&document)
	if err != nil {
		return nil, false, err
	}
	if !hasProxyEntryPool(root) {
		return nil, false, errorsEntryPool("must be declared on a proxy")
	}
	if entryPoolKeyOutsideProxy(root) {
		return nil, false, errorsEntryPool("pool configuration is unsupported outside proxies")
	}
	changed, err := expandEntryPoolDocument(root)
	if err != nil || !changed {
		return nil, false, err
	}
	var output bytes.Buffer
	encoder := yaml.NewEncoder(&output)
	encoder.SetIndent(2)
	if err := encoder.Encode(&document); err != nil {
		return nil, false, err
	}
	if err := encoder.Close(); err != nil {
		return nil, false, err
	}
	return output.Bytes(), true, nil
}

func expandEntryPoolDocument(root *yaml.Node) (bool, error) {
	proxies := mappingValue(root, "proxies")
	if proxies == nil || proxies.Kind != yaml.SequenceNode {
		return false, errorsEntryPool("proxies must be a list")
	}
	groups := mappingValue(root, "proxy-groups")
	if groups != nil && groups.Kind != yaml.SequenceNode {
		return false, errorsEntryPool("proxy-groups must be a list")
	}

	usedNames := make(map[string]struct{}, len(proxies.Content)+nodeSequenceLength(groups))
	for _, proxy := range proxies.Content {
		if proxy.Kind != yaml.MappingNode {
			return false, errorsEntryPool("a proxy must be a mapping")
		}
		name := nodeString(mappingValue(proxy, "name"))
		if name == "" {
			return false, errorsEntryPool("a proxy has no name")
		}
		if _, exists := usedNames[name]; exists {
			return false, errorsEntryPool("proxy or group names are duplicated")
		}
		usedNames[name] = struct{}{}
	}
	if groups != nil {
		for _, group := range groups.Content {
			if group.Kind != yaml.MappingNode {
				return false, errorsEntryPool("a proxy group must be a mapping")
			}
			name := nodeString(mappingValue(group, "name"))
			if name == "" {
				return false, errorsEntryPool("a proxy group has no name")
			}
			if _, exists := usedNames[name]; exists {
				return false, errorsEntryPool("proxy or group names are duplicated")
			}
			usedNames[name] = struct{}{}
			for _, key := range []string{"include-all", "include-all-proxies"} {
				value := mappingValue(group, key)
				if value != nil && (value.Tag != "!!bool" || value.Value != "false") {
					return false, errorsEntryPool("include-all proxy groups cannot contain entry pools")
				}
			}
		}
	}
	if providers := mappingValue(root, "proxy-providers"); providers != nil && providers.Kind == yaml.MappingNode && len(providers.Content) > 0 {
		return false, errorsEntryPool("proxy providers cannot be combined with entry pools")
	}

	type transform struct {
		proxy    *yaml.Node
		name     string
		options  entryPoolOptions
		variants []string
	}
	transforms := make([]transform, 0)
	totalCandidates := 0
	for _, proxy := range proxies.Content {
		poolNode := mappingValue(proxy, entryPoolKey)
		if poolNode == nil {
			continue
		}
		name := nodeString(mappingValue(proxy, "name"))
		options, err := parseEntryPool(poolNode)
		if err != nil {
			return false, fmt.Errorf("entry pool on proxy %q: %w", name, err)
		}
		port, err := parsePoolInteger(mappingValue(proxy, "port"))
		if err != nil || port < 1 || port > 65535 {
			return false, errorsEntryPool("proxy port must be between 1 and 65535")
		}
		addresses := make(map[string]struct{}, len(options.entries))
		for i := range options.entries {
			if options.entries[i].port == 0 {
				options.entries[i].port = port
			}
			address := netip.AddrPortFrom(netip.MustParseAddr(options.entries[i].server), uint16(options.entries[i].port)).String()
			if _, exists := addresses[address]; exists {
				return false, errorsEntryPool("entry addresses must be unique")
			}
			addresses[address] = struct{}{}
		}
		if err := validateEntryPoolProxy(proxy); err != nil {
			return false, fmt.Errorf("entry pool on proxy %q: %w", name, err)
		}
		totalCandidates += len(options.entries)
		if totalCandidates > maxEntryPoolCandidates {
			return false, errorsEntryPool("total candidate limit exceeded")
		}
		variants := make([]string, 0, len(options.entries))
		for _, entry := range options.entries {
			variant := entryPoolVariantName(name, entry.id)
			if _, exists := usedNames[variant]; exists {
				return false, errorsEntryPool("generated proxy name collides with an existing name")
			}
			usedNames[variant] = struct{}{}
			variants = append(variants, variant)
		}
		transforms = append(transforms, transform{proxy: proxy, name: name, options: options, variants: variants})
	}
	if len(transforms) == 0 {
		return false, nil
	}
	for _, item := range transforms {
		first := item.proxy
		base := cloneYAMLNode(first)
		originalServer := nodeString(mappingValue(first, "server"))
		typeName := nodeString(mappingValue(first, "type"))
		for i, entry := range item.options.entries {
			variant := cloneYAMLNode(base)
			setMappingScalar(variant, "name", item.variants[i])
			setMappingScalar(variant, "server", entry.server)
			removeMappingValue(variant, entryPoolKey)
			setTLSIdentity(variant, typeName, originalServer)
			setPort(variant, entry.port)
			if i == 0 {
				*first = *variant
			} else {
				proxies.Content = append(proxies.Content, variant)
			}
		}
		if groups == nil {
			groups = &yaml.Node{Kind: yaml.SequenceNode, Tag: "!!seq"}
			setMappingValue(root, "proxy-groups", groups)
		}
		groups.Content = append(groups.Content, entryPoolGroup(item.name, item.variants, item.options))
	}
	return true, nil
}

func decryptEntryPoolInput(buf []byte) ([]byte, error) {
	if !bytes.HasPrefix(buf, []byte(ageEncryptedHeader)) {
		return buf, nil
	}
	return age.DecryptBytes(buf)
}

func containsEntryPoolKey(node *yaml.Node) bool {
	if node == nil {
		return false
	}
	if node.Kind == yaml.MappingNode {
		for i := 0; i+1 < len(node.Content); i += 2 {
			if node.Content[i].Kind == yaml.ScalarNode && node.Content[i].Value == entryPoolKey {
				return true
			}
		}
	}
	for _, child := range node.Content {
		if containsEntryPoolKey(child) {
			return true
		}
	}
	return false
}

func hasProxyEntryPool(root *yaml.Node) bool {
	proxies := mappingValue(root, "proxies")
	if proxies == nil || proxies.Kind != yaml.SequenceNode {
		return false
	}
	for _, proxy := range proxies.Content {
		if mappingValue(proxy, entryPoolKey) != nil {
			return true
		}
	}
	return false
}

func entryPoolKeyOutsideProxy(root *yaml.Node) bool {
	proxies := mappingValue(root, "proxies")
	var visit func(*yaml.Node, bool) bool
	visit = func(node *yaml.Node, proxyMapping bool) bool {
		if node == nil {
			return false
		}
		if node.Kind == yaml.MappingNode {
			for i := 0; i+1 < len(node.Content); i += 2 {
				key, value := node.Content[i], node.Content[i+1]
				if key.Kind == yaml.ScalarNode && key.Value == entryPoolKey && !proxyMapping {
					return true
				}
				if proxies != nil && node == root && key.Value == "proxies" {
					for _, proxy := range value.Content {
						if visit(proxy, true) {
							return true
						}
					}
					continue
				}
				if visit(value, false) {
					return true
				}
			}
		} else {
			for _, child := range node.Content {
				if visit(child, false) {
					return true
				}
			}
		}
		return false
	}
	return visit(root, false)
}

func validateEntryPoolDocument(document *yaml.Node) error {
	var visit func(*yaml.Node) error
	visit = func(node *yaml.Node) error {
		if node.Kind == yaml.AliasNode || node.Anchor != "" {
			return errorsEntryPool("YAML aliases and anchors are unsupported when a pool is configured")
		}
		if node.Kind == yaml.MappingNode {
			seen := make(map[string]struct{}, len(node.Content)/2)
			for i := 0; i+1 < len(node.Content); i += 2 {
				key := node.Content[i]
				if key.Kind != yaml.ScalarNode {
					return errorsEntryPool("mapping keys must be scalars")
				}
				if key.ShortTag() == "!!merge" || key.Value == "<<" {
					return errorsEntryPool("YAML merge keys are unsupported when a pool is configured")
				}
				if _, exists := seen[key.Value]; exists {
					return errorsEntryPool("duplicate YAML mapping key")
				}
				seen[key.Value] = struct{}{}
			}
		}
		for _, child := range node.Content {
			if err := visit(child); err != nil {
				return err
			}
		}
		return nil
	}
	return visit(document)
}

func parseEntryPool(node *yaml.Node) (entryPoolOptions, error) {
	var options entryPoolOptions
	if node.Kind != yaml.MappingNode {
		return options, errorsEntryPool("configuration must be a mapping")
	}
	allowed := map[string]bool{"entries": true, "url": true, "interval": true, "timeout": true, "tolerance": true}
	seenKeys := make(map[string]struct{}, len(node.Content)/2)
	for i := 0; i+1 < len(node.Content); i += 2 {
		key := node.Content[i].Value
		if _, exists := seenKeys[key]; exists {
			return options, errorsEntryPool("duplicate configuration key")
		}
		seenKeys[key] = struct{}{}
		if !allowed[key] {
			return options, fmt.Errorf("unsupported parameter %q", key)
		}
	}
	urlNode := mappingValue(node, "url")
	if urlNode == nil || urlNode.Kind != yaml.ScalarNode || urlNode.Tag != "!!str" {
		return options, errorsEntryPool("url must be an HTTPS URL")
	}
	parsedURL, err := url.Parse(urlNode.Value)
	if err != nil || parsedURL.Scheme != "https" || parsedURL.Hostname() == "" || parsedURL.User != nil || parsedURL.Fragment != "" {
		return options, errorsEntryPool("url must be an HTTPS URL without credentials or fragment")
	}
	options.url = parsedURL.String()
	options.interval, err = boundedPoolInteger(node, "interval", 300, 60, 3600)
	if err != nil {
		return options, err
	}
	options.timeout, err = boundedPoolInteger(node, "timeout", 5000, 1000, 15000)
	if err != nil {
		return options, err
	}
	options.tolerance, err = boundedPoolInteger(node, "tolerance", 50, 10, 1000)
	if err != nil {
		return options, err
	}
	entries := mappingValue(node, "entries")
	if entries == nil || entries.Kind != yaml.SequenceNode || len(entries.Content) < 2 || len(entries.Content) > 8 {
		return options, errorsEntryPool("entries must contain between 2 and 8 items")
	}
	options.entries = make([]entryPoolEntry, 0, len(entries.Content))
	seenIDs := make(map[string]struct{}, len(entries.Content))
	seenAddresses := make(map[string]struct{}, len(entries.Content))
	for _, entryNode := range entries.Content {
		if entryNode.Kind != yaml.MappingNode {
			return options, errorsEntryPool("each entry must be a mapping")
		}
		for i := 0; i+1 < len(entryNode.Content); i += 2 {
			key := entryNode.Content[i].Value
			if key != "id" && key != "server" && key != "port" {
				return options, fmt.Errorf("unsupported entry parameter %q", key)
			}
		}
		idNode := mappingValue(entryNode, "id")
		id := nodeString(idNode)
		if idNode == nil || idNode.Tag != "!!str" {
			return options, errorsEntryPool("entry id must be a string")
		}
		if !entryPoolIDPattern.MatchString(id) {
			return options, errorsEntryPool("entry id must use 1-32 ASCII letters, digits, underscore or hyphen")
		}
		if _, exists := seenIDs[id]; exists {
			return options, errorsEntryPool("entry ids must be unique")
		}
		seenIDs[id] = struct{}{}
		serverNode := mappingValue(entryNode, "server")
		serverText := nodeString(serverNode)
		if serverNode == nil || serverNode.Tag != "!!str" {
			return options, errorsEntryPool("entry server must be a numeric IP address")
		}
		address, err := netip.ParseAddr(serverText)
		if err != nil || address.Zone() != "" {
			return options, errorsEntryPool("entry server must be a numeric IP address")
		}
		address = address.Unmap()
		server := address.String()
		port := 0
		if portNode := mappingValue(entryNode, "port"); portNode != nil {
			port, err = parsePoolInteger(portNode)
			if err != nil || port < 1 || port > 65535 {
				return options, errorsEntryPool("entry port must be between 1 and 65535")
			}
		}
		key := netip.AddrPortFrom(address, uint16(port)).String()
		if _, exists := seenAddresses[key]; exists {
			return options, errorsEntryPool("entry addresses must be unique")
		}
		seenAddresses[key] = struct{}{}
		options.entries = append(options.entries, entryPoolEntry{id: id, server: server, port: port})
	}
	return options, nil
}

func boundedPoolInteger(node *yaml.Node, key string, fallback, minimum, maximum int) (int, error) {
	value := mappingValue(node, key)
	if value == nil {
		return fallback, nil
	}
	parsed, err := parsePoolInteger(value)
	if err != nil || parsed < minimum || parsed > maximum {
		return 0, fmt.Errorf("%s must be between %d and %d", key, minimum, maximum)
	}
	return parsed, nil
}

func parsePoolInteger(node *yaml.Node) (int, error) {
	if node == nil || node.Kind != yaml.ScalarNode || node.Tag != "!!int" {
		return 0, errorsEntryPool("expected an integer")
	}
	var value int
	if err := node.Decode(&value); err != nil {
		return 0, err
	}
	return value, nil
}

func validateEntryPoolProxy(proxy *yaml.Node) error {
	typeNode := mappingValue(proxy, "type")
	serverNode := mappingValue(proxy, "server")
	typeName := nodeString(typeNode)
	server := nodeString(serverNode)
	if typeNode == nil || typeNode.Tag != "!!str" || serverNode == nil || serverNode.Tag != "!!str" || server == "" || mappingValue(proxy, "port") == nil {
		return errorsEntryPool("proxy server and port are required")
	}
	if mappingValue(proxy, "dialer-proxy") != nil {
		return errorsEntryPool("dialer-proxy is unsupported on pooled proxies")
	}
	common := map[string]bool{"name": true, "type": true, "server": true, "port": true,
		"x-tianji-entry-pool": true, "interface-name": true, "routing-mark": true,
		"ip-version": true, "tfo": true, "mptcp": true}
	protocolFields := map[string]map[string]bool{
		"vless": {"uuid": true, "flow": true, "encryption": true, "tls": true,
			"network": true, "servername": true, "alpn": true, "skip-cert-verify": true,
			"client-fingerprint": true, "udp": true, "packet-addr": true, "xudp": true,
			"packet-encoding": true, "reality-opts": true},
		"trojan": {"password": true, "sni": true, "alpn": true, "network": true,
			"skip-cert-verify": true, "client-fingerprint": true, "udp": true},
		"hysteria2": {"password": true, "obfs": true, "obfs-password": true,
			"obfs-min-packet-size": true, "obfs-max-packet-size": true, "sni": true,
			"skip-cert-verify": true, "alpn": true, "up": true, "down": true,
			"udp-mtu": true, "cwnd": true, "bbr-profile": true, "handshake-timeout": true,
			"initial-stream-receive-window": true, "max-stream-receive-window": true,
			"initial-connection-receive-window": true, "max-connection-receive-window": true},
		"anytls": {"password": true, "sni": true, "alpn": true, "client-fingerprint": true,
			"skip-cert-verify": true, "udp": true, "idle-session-check-interval": true,
			"idle-session-timeout": true, "min-idle-session": true, "disable-reuse": true},
	}
	allowed := protocolFields[typeName]
	if allowed == nil {
		return errorsEntryPool("protocol must be vless, trojan, hysteria2 or anytls")
	}
	for i := 0; i+1 < len(proxy.Content); i += 2 {
		key := proxy.Content[i].Value
		if isEntryPoolTLSBypassKey(key) {
			return errorsEntryPool("certificate pinning and custom certificate material are unsupported")
		}
		if !common[key] && !allowed[key] {
			return fmt.Errorf("unsupported proxy parameter %q", key)
		}
	}
	if skipVerify := mappingValue(proxy, "skip-cert-verify"); skipVerify != nil && (skipVerify.Tag != "!!bool" || skipVerify.Value != "false") {
		return errorsEntryPool("skip-cert-verify must be false")
	}
	if nodeString(mappingValue(proxy, "client-fingerprint")) != "" && typeName != "vless" && typeName != "trojan" && typeName != "anytls" {
		return errorsEntryPool("client-fingerprint is unsupported for this protocol")
	}
	identity := ""
	identityKey := "sni"
	var err error
	switch typeName {
	case "vless":
		if !yamlBool(mappingValue(proxy, "tls")) || !poolTCPNetwork(proxy) {
			return errorsEntryPool("vless requires TLS and TCP or the default network")
		}
		if nodeString(mappingValue(proxy, "uuid")) == "" {
			return errorsEntryPool("vless requires a UUID")
		}
		identityKey = "servername"
		identity, err = tlsIdentityValue(proxy, identityKey)
		if err != nil {
			return err
		}
		if reality := mappingValue(proxy, "reality-opts"); reality != nil && reality.Kind != yaml.MappingNode {
			return errorsEntryPool("reality-opts must be a mapping")
		}
	case "trojan":
		if !poolTCPNetwork(proxy) {
			return errorsEntryPool("trojan requires TCP or the default network")
		}
		if nodeString(mappingValue(proxy, "password")) == "" {
			return errorsEntryPool("trojan requires a password")
		}
		identity, err = tlsIdentityValue(proxy, identityKey)
		if err != nil {
			return err
		}
	case "hysteria2":
		identity, err = tlsIdentityValue(proxy, identityKey)
		if err != nil {
			return err
		}
	case "anytls":
		if nodeString(mappingValue(proxy, "password")) == "" {
			return errorsEntryPool("anytls requires a password")
		}
		identity, err = tlsIdentityValue(proxy, identityKey)
		if err != nil {
			return err
		}
	default:
		return errorsEntryPool("protocol must be vless, trojan, hysteria2 or anytls")
	}
	if identity == "" {
		if _, err := netip.ParseAddr(server); err == nil {
			return errorsEntryPool("an IP server requires an explicit TLS identity")
		}
		identity = server
	}
	return nil
}

func tlsIdentityValue(proxy *yaml.Node, key string) (string, error) {
	identity := mappingValue(proxy, key)
	if identity == nil {
		return "", nil
	}
	if identity.Kind != yaml.ScalarNode || identity.Tag != "!!str" || identity.Value == "" {
		return "", errorsEntryPool("TLS identity must be a non-empty string")
	}
	return identity.Value, nil
}

func poolTCPNetwork(proxy *yaml.Node) bool {
	network := nodeString(mappingValue(proxy, "network"))
	return network == "" || network == "tcp"
}

func isEntryPoolTLSBypassKey(key string) bool {
	switch key {
	case "fingerprint", "certificate", "private-key", "name-cert-verify", "ech-opts", "shadow-tls-opts", "restls-opts", "jls-opts", "xhttp-opts", "ws-opts", "ws-headers", "h2-opts", "grpc-opts", "ports", "hop-interval", "realm-opts":
		return true
	default:
		return false
	}
}

func setTLSIdentity(proxy *yaml.Node, typeName, originalServer string) {
	key := "sni"
	if typeName == "vless" {
		key = "servername"
	}
	if nodeString(mappingValue(proxy, key)) != "" {
		return
	}
	if _, err := netip.ParseAddr(originalServer); err == nil {
		return
	}
	setMappingScalar(proxy, key, originalServer)
}

func entryPoolVariantName(name, id string) string {
	return name + " / " + id
}

func entryPoolGroup(name string, variants []string, options entryPoolOptions) *yaml.Node {
	group := mappingNode(
		"name", stringNode(name),
		"type", stringNode("url-test"),
		"proxies", stringSequence(variants),
		"url", stringNode(options.url),
		"interval", integerNode(options.interval),
		"timeout", integerNode(options.timeout),
		"tolerance", integerNode(options.tolerance),
		"expected-status", stringNode("204"),
		"lazy", boolNode(true),
		"max-failed-times", integerNode(2),
		"empty-fallback", stringNode("REJECT"),
	)
	return group
}

func cloneYAMLNode(node *yaml.Node) *yaml.Node {
	copyNode := *node
	copyNode.Content = make([]*yaml.Node, len(node.Content))
	for i, child := range node.Content {
		copyNode.Content[i] = cloneYAMLNode(child)
	}
	return &copyNode
}

func mappingNode(values ...any) *yaml.Node {
	node := &yaml.Node{Kind: yaml.MappingNode, Tag: "!!map"}
	for i := 0; i+1 < len(values); i += 2 {
		node.Content = append(node.Content, stringNode(values[i].(string)), values[i+1].(*yaml.Node))
	}
	return node
}

func stringNode(value string) *yaml.Node {
	return &yaml.Node{Kind: yaml.ScalarNode, Tag: "!!str", Value: value}
}
func integerNode(value int) *yaml.Node {
	return &yaml.Node{Kind: yaml.ScalarNode, Tag: "!!int", Value: strconv.Itoa(value)}
}
func boolNode(value bool) *yaml.Node {
	return &yaml.Node{Kind: yaml.ScalarNode, Tag: "!!bool", Value: strconv.FormatBool(value)}
}

func stringSequence(values []string) *yaml.Node {
	node := &yaml.Node{Kind: yaml.SequenceNode, Tag: "!!seq"}
	for _, value := range values {
		node.Content = append(node.Content, stringNode(value))
	}
	return node
}

func setMappingScalar(mapping *yaml.Node, key, value string) {
	setMappingValue(mapping, key, stringNode(value))
}

func setPort(mapping *yaml.Node, port int) {
	if port != 0 {
		setMappingValue(mapping, "port", integerNode(port))
	}
}

func removeMappingValue(mapping *yaml.Node, key string) {
	for i := 0; i+1 < len(mapping.Content); i += 2 {
		if mapping.Content[i].Value != key {
			continue
		}
		mapping.Content = append(mapping.Content[:i], mapping.Content[i+2:]...)
		return
	}
}

func nodeString(node *yaml.Node) string {
	if node == nil || node.Kind != yaml.ScalarNode {
		return ""
	}
	return node.Value
}

func nodeSequenceLength(node *yaml.Node) int {
	if node == nil || node.Kind != yaml.SequenceNode {
		return 0
	}
	return len(node.Content)
}

func yamlBool(node *yaml.Node) bool {
	return node != nil && node.Kind == yaml.ScalarNode && node.Tag == "!!bool" && node.Value == "true"
}

func errorsEntryPool(message string) error { return fmt.Errorf("entry pool: %s", message) }
