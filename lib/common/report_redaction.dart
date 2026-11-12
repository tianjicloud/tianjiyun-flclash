final _secretField = RegExp(
  r'''^([ \t]*(?:[-]?\s*)?["']?(?:password|passwd|token|uuid|private[-_]?key|secret|authorization|cookie|auth|credential)s?["']?\s*:\s*).+$''',
  caseSensitive: false,
  multiLine: true,
);
final _header = RegExp(
  r'^([ \t]*(?:authorization|cookie|set-cookie)\s*:\s*).+$',
  caseSensitive: false,
  multiLine: true,
);
final _inlineHeader = RegExp(
  r'''(["']?(?:authorization|cookie|set-cookie)["']?\s*:\s*)(?:"[^"]*"|'[^']*'|[^,\r\n}\]]+)''',
  caseSensitive: false,
);
final _inlineSecret = RegExp(
  r'''(\b(?:password|passwd|token|uuid|private[-_]?key|secret|auth(?:entication|[-_]?token)?|credential)s?\s*[:=]\s*)(?!\s*\*{3})(?:"[^"]*"|'[^']*'|[^,\r\n}\]]+)''',
  caseSensitive: false,
);
final _url = RegExp(r'''https?://[^\s"'<>]+''', caseSensitive: false);
// A share link carries its credentials in the user info or a base64 body.
final _shareLink = RegExp(
  r'''\b(ssr?|vmess|vless|trojan|hysteria2?|hy2|tuic|anytls|socks5?|wireguard|snell)://[^\s"'<>]+''',
  caseSensitive: false,
);
final _uuid = RegExp(
  r'\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b',
  caseSensitive: false,
);
final _privateKey = RegExp(
  r'-----BEGIN [A-Z ]*PRIVATE KEY-----[\s\S]*?-----END [A-Z ]*PRIVATE KEY-----',
);

String redactReport(String input) => input
    .replaceAll(_privateKey, '***')
    .replaceAllMapped(_shareLink, (match) => '${match[1]}://***')
    .replaceAllMapped(_url, (match) => _redactUrl(match[0]!))
    .replaceAllMapped(_header, (match) => '${match[1]}***')
    .replaceAllMapped(_inlineHeader, (match) => '${match[1]}***')
    .replaceAllMapped(_secretField, (match) => '${match[1]}***')
    .replaceAllMapped(_inlineSecret, (match) => '${match[1]}***')
    .replaceAll(_uuid, '***');

String _redactUrl(String value) {
  final uri = Uri.tryParse(value);
  if (uri == null) return value;
  final userInfo = uri.userInfo.isEmpty ? '' : '***@';
  final authority =
      '${uri.scheme}://$userInfo${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
  final segments = uri.pathSegments;
  final path = [
    for (var index = 0; index < segments.length; index++)
      _isPathToken(segments, index) ? '***' : segments[index],
  ].join('/');
  final query = uri.queryParametersAll.keys.isEmpty
      ? ''
      : '?${uri.queryParametersAll.keys.map((key) => '$key=***').join('&')}';
  return '$authority${path.isEmpty ? '' : '/$path'}$query';
}

bool _isPathToken(List<String> segments, int index) {
  final segment = segments[index];
  final marker =
      index > 0 &&
      const {
        's',
        'sub',
        'subscription',
        'subscriptions',
      }.contains(segments[index - 1].toLowerCase());
  final looksLikeToken =
      segment.length >= 16 ||
      (segment.length >= 8 &&
          RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(segment) &&
          RegExp(r'\d').hasMatch(segment));
  return marker || looksLikeToken;
}
