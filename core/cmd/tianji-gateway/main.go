package main

import (
	"bytes"
	"context"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/signal"
	"syscall"

	"core/tianji"
	"github.com/metacubex/mihomo/adapter"
	C "github.com/metacubex/mihomo/constant"
	"github.com/metacubex/mihomo/tunnel"
	"go.yaml.in/yaml/v3"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func run() error {
	flags := flag.NewFlagSet("tianji-gateway", flag.ContinueOnError)
	configPath := flags.String("config", "", "restricted gateway JSON configuration")
	mihomoPath := flags.String("mihomo-config", "", "existing mihomo config containing authorized proxy outbounds")
	listenAddress := flags.String("listen", "", "TCP and UDP bind address")
	certFile := flags.String("cert", "", "TLS certificate PEM; atomically replace to refresh")
	keyFile := flags.String("key", "", "TLS private key PEM; atomically replace to refresh")
	if err := flags.Parse(os.Args[1:]); err != nil {
		return err
	}
	if flags.NArg() != 0 || *configPath == "" || *mihomoPath == "" || *listenAddress == "" || *certFile == "" || *keyFile == "" {
		return errors.New("usage: tianji-gateway -config gateway.json -mihomo-config mihomo.yaml -listen :8443 -cert cert.pem -key key.pem")
	}
	gatewayData, err := readRestricted(*configPath, 1<<20)
	if err != nil {
		return fmt.Errorf("tianji-gateway: read gateway config: %w", err)
	}
	mihomoData, err := readRestricted(*mihomoPath, 2<<20)
	if err != nil {
		return fmt.Errorf("tianji-gateway: read mihomo config: %w", err)
	}
	proxies, err := parseOutbounds(mihomoData)
	if err != nil {
		return err
	}
	egresses := make(map[string]tianji.Egress, len(proxies))
	for name, proxy := range proxies {
		egress, egressErr := tianji.NewProxyEgress(proxy)
		if egressErr != nil {
			closeProxies(proxies)
			return fmt.Errorf("tianji-gateway: outbound %q is not eligible", name)
		}
		egresses[name] = egress
	}
	gateway, err := tianji.LoadGateway(gatewayData, egresses, tianji.GatewayOptions{})
	if err != nil {
		closeProxies(proxies)
		return err
	}
	defer closeProxies(proxies)
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	if err := tianji.Serve(ctx, gateway, tianji.ListenerOptions{Address: *listenAddress, CertFile: *certFile, KeyFile: *keyFile}); err != nil {
		return err
	}
	return nil
}

func readRestricted(path string, maxSize int64) ([]byte, error) {
	info, err := os.Lstat(path)
	if err != nil {
		return nil, err
	}
	if !info.Mode().IsRegular() || info.Mode().Perm()&0o077 != 0 {
		return nil, errors.New("sensitive config must be a regular file with mode 0600 or stricter")
	}
	if info.Size() < 1 || info.Size() > maxSize {
		return nil, errors.New("sensitive config exceeds the allowed size")
	}
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()
	opened, err := file.Stat()
	if err != nil || !opened.Mode().IsRegular() || opened.Mode().Perm()&0o077 != 0 || !os.SameFile(info, opened) || opened.Size() < 1 || opened.Size() > maxSize {
		return nil, errors.New("sensitive config changed while it was being opened")
	}
	data, err := io.ReadAll(io.LimitReader(file, maxSize+1))
	if err != nil || int64(len(data)) > maxSize {
		return nil, errors.New("sensitive config could not be read within the size limit")
	}
	return data, nil
}

type outboundFile struct {
	Proxies []map[string]any `yaml:"proxies"`
}

func parseOutbounds(data []byte) (map[string]C.Proxy, error) {
	decoder := yaml.NewDecoder(bytes.NewReader(data))
	decoder.KnownFields(true)
	var file outboundFile
	if err := decoder.Decode(&file); err != nil {
		return nil, errors.New("tianji-gateway: invalid outbound YAML")
	}
	var trailing any
	if err := decoder.Decode(&trailing); err != io.EOF {
		return nil, errors.New("tianji-gateway: outbound YAML must have one document")
	}
	if len(file.Proxies) == 0 || len(file.Proxies) > 256 {
		return nil, errors.New("tianji-gateway: outbound YAML must contain 1..256 proxies")
	}
	proxies := make(map[string]C.Proxy, len(file.Proxies))
	for _, mapping := range file.Proxies {
		name, ok := mapping["name"].(string)
		if !ok || name == "" || !eligibleFields(mapping) {
			closeProxies(proxies)
			return nil, errors.New("tianji-gateway: outbound uses unsupported fields or insecure TLS")
		}
		if _, duplicate := proxies[name]; duplicate {
			closeProxies(proxies)
			return nil, errors.New("tianji-gateway: duplicate outbound name")
		}
		proxy, err := adapter.ParseProxy(mapping, adapter.WithTunnelForAPI(tunnel.Tunnel))
		if err != nil || proxy == nil {
			closeProxies(proxies)
			return nil, errors.New("tianji-gateway: invalid or unsupported outbound")
		}
		proxies[name] = proxy
	}
	return proxies, nil
}

func eligibleFields(mapping map[string]any) bool {
	typeName, ok := mapping["type"].(string)
	if !ok {
		return false
	}
	allowed := map[string]map[string]bool{
		"vless":     set("name", "type", "server", "port", "uuid", "flow", "tls", "alpn", "udp", "network", "skip-cert-verify", "servername", "client-fingerprint", "ws-opts", "grpc-opts"),
		"trojan":    set("name", "type", "server", "port", "password", "alpn", "sni", "skip-cert-verify", "client-fingerprint", "udp"),
		"hysteria2": set("name", "type", "server", "port", "ports", "password", "obfs", "obfs-password", "up", "down", "sni", "skip-cert-verify", "alpn", "udp-mtu", "cwnd"),
		"anytls":    set("name", "type", "server", "port", "password", "alpn", "sni", "skip-cert-verify", "client-fingerprint", "udp"),
	}
	keys, ok := allowed[typeName]
	if !ok {
		return false
	}
	for key := range mapping {
		if !keys[key] {
			return false
		}
	}
	if insecure, ok := mapping["skip-cert-verify"]; ok {
		if flag, ok := insecure.(bool); !ok || flag {
			return false
		}
	}
	if typeName == "vless" {
		tlsEnabled, _ := mapping["tls"].(bool)
		if !tlsEnabled {
			return false
		}
	}
	if typeName != "hysteria2" {
		udpEnabled, _ := mapping["udp"].(bool)
		if !udpEnabled {
			return false
		}
	}
	return true
}

func set(fields ...string) map[string]bool {
	values := make(map[string]bool, len(fields))
	for _, field := range fields {
		values[field] = true
	}
	return values
}

func closeProxies(proxies map[string]C.Proxy) {
	for _, proxy := range proxies {
		_ = proxy.Close()
	}
}
