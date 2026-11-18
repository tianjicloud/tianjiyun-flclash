package tianji

import (
	"bytes"
	"errors"
	"fmt"
	"net"
	"strconv"
	"strings"

	"go.yaml.in/yaml/v3"
)

type SubscriptionRequest struct {
	OfficialApp    bool                        `json:"official_app"`
	SupportsTianji bool                        `json:"supports_tianji"`
	OptIn          bool                        `json:"opt_in"`
	Transport      string                      `json:"transport"`
	Nodes          map[string]SubscriptionNode `json:"nodes"`
}

type SubscriptionNode struct {
	Server       string `json:"server"`
	Port         int    `json:"port"`
	ServerName   string `json:"server_name"`
	Path         string `json:"path"`
	Token        string `json:"token"`
	TLSValidated bool   `json:"tls_validated"`
}

func ConvertSubscriptionCandidate(source []byte, request SubscriptionRequest) ([]byte, bool, error) {
	if !request.OfficialApp || !request.SupportsTianji || !request.OptIn {
		return append([]byte(nil), source...), false, nil
	}
	if request.Transport == "" {
		request.Transport = "auto"
	}
	if request.Transport != "auto" && request.Transport != "h2" && request.Transport != "h3" {
		return nil, false, errors.New("tianji: invalid transport")
	}
	var document yaml.Node
	if err := yaml.Unmarshal(source, &document); err != nil {
		return nil, false, fmt.Errorf("tianji: invalid source subscription: %w", err)
	}
	if len(document.Content) != 1 || document.Content[0].Kind != yaml.MappingNode {
		return nil, false, errors.New("tianji: source subscription must be a mapping")
	}
	root := document.Content[0]
	proxies := mappingValue(root, "proxies")
	if proxies == nil || proxies.Kind != yaml.SequenceNode || len(proxies.Content) == 0 {
		return nil, false, errors.New("tianji: proxies must be materialized before conversion")
	}
	if providers := mappingValue(root, "proxy-providers"); providers != nil && providers.Kind == yaml.MappingNode && len(providers.Content) > 0 {
		return nil, false, errors.New("tianji: subscription contains unmaterialized proxy providers")
	}
	seen := make(map[string]struct{}, len(proxies.Content))
	proxyNames := make(map[string]struct{}, len(proxies.Content))
	seenTokens := make(map[string]struct{}, len(proxies.Content))
	names := make([]string, 0, len(proxies.Content))
	if err := validateNodeTree(root); err != nil {
		return nil, false, err
	}
	for _, proxy := range proxies.Content {
		if proxy.Kind != yaml.MappingNode {
			return nil, false, errors.New("tianji: invalid proxy entry")
		}
		nameNode := mappingValue(proxy, "name")
		if nameNode == nil || nameNode.Kind != yaml.ScalarNode || nameNode.Value == "" {
			return nil, false, errors.New("tianji: proxy entry without a name")
		}
		if _, ok := seen[nameNode.Value]; ok {
			return nil, false, fmt.Errorf("tianji: duplicate proxy name %q", nameNode.Value)
		}
		if _, reserved := reservedNames[strings.ToUpper(nameNode.Value)]; reserved {
			return nil, false, fmt.Errorf("tianji: reserved proxy name %q", nameNode.Value)
		}
		typeNode := mappingValue(proxy, "type")
		if typeNode == nil || !candidateConvertibleTypes[typeNode.Value] {
			return nil, false, fmt.Errorf("tianji: proxy %q is not a convertible outbound", nameNode.Value)
		}
		seen[nameNode.Value] = struct{}{}
		proxyNames[nameNode.Value] = struct{}{}
		names = append(names, nameNode.Value)
	}
	groups := mappingValue(root, "proxy-groups")
	if groups != nil {
		if groups.Kind != yaml.SequenceNode {
			return nil, false, errors.New("tianji: proxy-groups must be a sequence")
		}
		for _, group := range groups.Content {
			if group.Kind != yaml.MappingNode {
				return nil, false, errors.New("tianji: invalid proxy group")
			}
			name := mappingValue(group, "name")
			if name == nil || name.Kind != yaml.ScalarNode || name.Value == "" {
				return nil, false, errors.New("tianji: proxy group without a name")
			}
			if _, exists := seen[name.Value]; exists {
				return nil, false, fmt.Errorf("tianji: duplicate proxy or group name %q", name.Value)
			}
			if _, reserved := reservedNames[strings.ToUpper(name.Value)]; reserved {
				return nil, false, fmt.Errorf("tianji: reserved proxy group name %q", name.Value)
			}
			seen[name.Value] = struct{}{}
		}
	}
	providers := mappingValue(root, "proxy-providers")
	if providers != nil && providers.Kind != yaml.MappingNode {
		return nil, false, errors.New("tianji: proxy-providers must be a mapping")
	}
	if providers != nil && len(providers.Content) > 0 {
		return nil, false, errors.New("tianji: subscription contains unmaterialized proxy providers")
	}
	if len(request.Nodes) != len(names) {
		return nil, false, errors.New("tianji: endpoint mapping does not cover exactly the materialized proxies")
	}
	for name := range request.Nodes {
		if _, ok := proxyNames[name]; !ok {
			return nil, false, fmt.Errorf("tianji: unexpected endpoint mapping %q", name)
		}
	}
	for index, proxy := range proxies.Content {
		name := names[index]
		endpoint := request.Nodes[name]
		if err := validateSubscriptionNode(endpoint); err != nil {
			return nil, false, fmt.Errorf("tianji: invalid endpoint for %q: %w", name, err)
		}
		if _, exists := seenTokens[endpoint.Token]; exists {
			return nil, false, fmt.Errorf("tianji: endpoint token reuse for %q", name)
		}
		seenTokens[endpoint.Token] = struct{}{}
		original := append([]*yaml.Node(nil), proxy.Content...)
		commentHead, commentLine, commentFoot := proxy.HeadComment, proxy.LineComment, proxy.FootComment
		proxy.Content = []*yaml.Node{
			{Kind: yaml.ScalarNode, Tag: "!!str", Value: "name"}, {Kind: yaml.ScalarNode, Tag: "!!str", Value: name},
			{Kind: yaml.ScalarNode, Tag: "!!str", Value: "type"}, {Kind: yaml.ScalarNode, Tag: "!!str", Value: "tianji"},
			{Kind: yaml.ScalarNode, Tag: "!!str", Value: "server"}, {Kind: yaml.ScalarNode, Tag: "!!str", Value: endpoint.Server},
			{Kind: yaml.ScalarNode, Tag: "!!str", Value: "port"}, {Kind: yaml.ScalarNode, Tag: "!!int", Value: strconv.Itoa(endpoint.Port)},
			{Kind: yaml.ScalarNode, Tag: "!!str", Value: "servername"}, {Kind: yaml.ScalarNode, Tag: "!!str", Value: endpoint.ServerName},
			{Kind: yaml.ScalarNode, Tag: "!!str", Value: "path"}, {Kind: yaml.ScalarNode, Tag: "!!str", Value: endpoint.Path},
			{Kind: yaml.ScalarNode, Tag: "!!str", Value: "token"}, {Kind: yaml.ScalarNode, Tag: "!!str", Value: endpoint.Token},
			{Kind: yaml.ScalarNode, Tag: "!!str", Value: "transport"}, {Kind: yaml.ScalarNode, Tag: "!!str", Value: request.Transport},
		}
		for i := 0; i+1 < len(original); i += 2 {
			key := original[i].Value
			if key == "interface-name" || key == "routing-mark" || key == "ip-version" || key == "tfo" || key == "mptcp" || key == "dialer-proxy" {
				proxy.Content = append(proxy.Content, original[i], original[i+1])
			}
		}
		proxy.HeadComment, proxy.LineComment, proxy.FootComment = commentHead, commentLine, commentFoot
	}
	var output bytes.Buffer
	encoder := yaml.NewEncoder(&output)
	encoder.SetIndent(2)
	if err := encoder.Encode(&document); err != nil {
		return nil, false, fmt.Errorf("tianji: encode candidate: %w", err)
	}
	if err := encoder.Close(); err != nil {
		return nil, false, fmt.Errorf("tianji: finalize candidate: %w", err)
	}
	return output.Bytes(), true, nil
}

func validateSubscriptionNode(node SubscriptionNode) error {
	if node.Server == "" || node.Port < 1 || node.Port > 65535 || node.ServerName == "" || node.Path == "" || node.Path[0] != '/' || !node.TLSValidated || len(node.Token) < 32 || strings.ContainsAny(node.Token, " \t\r\n") {
		return errors.New("server, port, server name, path, high-entropy token and validated TLS identity are required")
	}
	if strings.ContainsAny(node.Server+node.ServerName+node.Path, "\r\n") {
		return errors.New("invalid endpoint text")
	}
	if strings.Contains(node.Server, "/") || strings.Contains(node.Server, "@") {
		return errors.New("server must be a hostname or IP")
	}
	if ip := net.ParseIP(node.Server); ip == nil {
		if len(node.Server) > 253 {
			return errors.New("server name is too long")
		}
		for _, label := range strings.Split(node.Server, ".") {
			if label == "" || len(label) > 63 {
				return errors.New("invalid server hostname")
			}
		}
	}
	return nil
}

var candidateConvertibleTypes = map[string]bool{"ss": true, "ssr": true, "snell": true, "socks5": true, "http": true, "vmess": true, "vless": true, "trojan": true, "hysteria": true, "hysteria2": true, "wireguard": true, "tuic": true, "ssh": true, "mieru": true, "anytls": true, "sudoku": true, "masque": true, "trusttunnel": true, "shadowquic": true, "openvpn": true, "tailscale": true, "zerotier": true, "easytier": true}

var reservedNames = map[string]struct{}{"DIRECT": {}, "REJECT": {}, "REJECT-DROP": {}, "COMPATIBLE": {}, "PASS": {}, "PASS-RULE": {}, "GLOBAL": {}, "DNS": {}}

func validateNodeTree(node *yaml.Node) error {
	if node.Kind == yaml.AliasNode || node.Tag == "!!merge" || (node.Kind == yaml.ScalarNode && node.Value == "<<") {
		return errors.New("tianji: YAML aliases and merge keys are ambiguous for conversion")
	}
	if node.Kind == yaml.MappingNode {
		keys := make(map[string]struct{}, len(node.Content)/2)
		for i := 0; i+1 < len(node.Content); i += 2 {
			key := node.Content[i]
			if key.Kind != yaml.ScalarNode {
				return errors.New("tianji: non-scalar mapping key is ambiguous")
			}
			if _, ok := keys[key.Value]; ok {
				return fmt.Errorf("tianji: duplicate YAML key %q", key.Value)
			}
			keys[key.Value] = struct{}{}
		}
	}
	for _, child := range node.Content {
		if err := validateNodeTree(child); err != nil {
			return err
		}
	}
	return nil
}

func mappingValue(node *yaml.Node, key string) *yaml.Node {
	if node == nil || node.Kind != yaml.MappingNode {
		return nil
	}
	for i := 0; i+1 < len(node.Content); i += 2 {
		if node.Content[i].Value == key {
			return node.Content[i+1]
		}
	}
	return nil
}
