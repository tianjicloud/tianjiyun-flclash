import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:fl_clash/core/traffic/report.dart';

const _tianjiTrafficHosts = {
  'bslvn.divinations.top',
  'vn3kq.divinations.top',
  'sub1.tianjiyun.org',
  'sub.nianyi.de5.net',
  'sub.242.cc.cd',
  'sub.262.cc.cd',
};

const _sessionPath = '/s/tianji-traffic/session';
const _reportPath = '/s/tianji-traffic/report';
const _maxSessionResponseBytes = 16 * 1024;

final _subscriptionTokenPattern = RegExp(r'^[A-Za-z0-9_-]{8,128}$');

/// A subscription URL this client is allowed to exchange for a short-lived
/// traffic-report credential. The raw URL and token stay in memory and never
/// enter the accounting store or the report payload.
class TianjiTrafficProfile {
  const TianjiTrafficProfile._({
    required this.profileId,
    required this.origin,
    required this.subscriptionToken,
    required this.fingerprint,
  });

  final String profileId;
  final Uri origin;
  final String subscriptionToken;
  final String fingerprint;

  String get identityKey => '$profileId|$fingerprint';

  Uri get sessionEndpoint => origin.replace(path: _sessionPath);

  Uri get reportEndpoint => origin.replace(path: _reportPath);

  static TianjiTrafficProfile? resolve({
    required String profileId,
    required String url,
  }) {
    final normalizedId = profileId.trim();
    if (normalizedId.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri == null || !_validSubscriptionOrigin(uri)) return null;
    final token = _subscriptionToken(uri);
    if (token == null) return null;
    final origin = Uri(
      scheme: 'https',
      host: uri.host.toLowerCase(),
      port: uri.hasPort ? uri.port : null,
    );
    final fingerprint = sha256
        .convert(utf8.encode('${origin.toString()}|$token'))
        .toString();
    return TianjiTrafficProfile._(
      profileId: normalizedId,
      origin: origin,
      subscriptionToken: token,
      fingerprint: fingerprint,
    );
  }

  @override
  String toString() =>
      'TianjiTrafficProfile(profileId: $profileId, origin: $origin)';
}

bool _validSubscriptionOrigin(Uri uri) {
  if (!uri.isScheme('https')) return false;
  if (uri.host.isEmpty) return false;
  if (uri.userInfo.isNotEmpty) return false;
  if (uri.fragment.isNotEmpty) return false;
  if (uri.hasPort && uri.port != 443) return false;
  return _tianjiTrafficHosts.contains(uri.host.toLowerCase());
}

String? _subscriptionToken(Uri uri) {
  final segments = uri.pathSegments;
  if (segments.length == 2 && segments.first == 's') {
    if (uri.queryParametersAll.containsKey('token')) return null;
    return _validToken(segments.last);
  }
  if (uri.path != '/api/v1/client/subscribe') return null;
  final values = uri.queryParametersAll['token'];
  if (values == null || values.length != 1) return null;
  return _validToken(values.single);
}

String? _validToken(String value) {
  return _subscriptionTokenPattern.hasMatch(value) &&
          !RegExp(r'^\d+$').hasMatch(value)
      ? value
      : null;
}

class TrafficSession {
  const TrafficSession({required this.token, required this.expiresAt});

  final String token;
  final DateTime expiresAt;
}

class TrafficAuthException implements Exception {
  const TrafficAuthException(this.message, {this.statusCode});

  const TrafficAuthException.unauthorized()
    : this('subscription was rejected', statusCode: 401);

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}

TrafficSession parseTrafficSessionResponse(
  String body, {
  required DateTime now,
}) {
  final Object? decoded;
  try {
    decoded = json.decode(body);
  } on FormatException {
    throw const TrafficAuthException('session response is not JSON');
  }
  if (decoded is! Map) {
    throw const TrafficAuthException('session response is not an object');
  }
  final version = decoded['version'];
  if (version is! int || version != 1) {
    throw const TrafficAuthException('unsupported session response version');
  }
  final token = decoded['token'];
  if (token is! String || token.isEmpty || token.length > 8192) {
    throw const TrafficAuthException('session response has no token');
  }
  final expiresAt = decoded['expires-at'];
  if (expiresAt is! int || expiresAt <= 0 || expiresAt > 8640000000000) {
    throw const TrafficAuthException('session response has no expiry');
  }
  final expiry = DateTime.fromMillisecondsSinceEpoch(
    expiresAt.toInt() * 1000,
    isUtc: true,
  );
  if (!expiry.isAfter(now.toUtc())) {
    throw const TrafficAuthException('session response has already expired');
  }
  return TrafficSession(token: token, expiresAt: expiry);
}

abstract interface class TrafficSessionTransport {
  Future<TrafficSession> exchange({
    required Uri endpoint,
    required String subscriptionToken,
    required String installationId,
    required String scopeKey,
    required Duration timeout,
  });
}

class HttpTrafficSessionTransport implements TrafficSessionTransport {
  const HttpTrafficSessionTransport();

  @override
  Future<TrafficSession> exchange({
    required Uri endpoint,
    required String subscriptionToken,
    required String installationId,
    required String scopeKey,
    required Duration timeout,
  }) async {
    if (!validTrafficReportEndpoint(endpoint)) {
      throw const TrafficAuthException('refusing a non-HTTPS session origin');
    }
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final request = await client.postUrl(endpoint).timeout(timeout);
      request.followRedirects = false;
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.acceptHeader, ContentType.json.mimeType);
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Subscription $subscriptionToken',
      );
      request.headers.set(HttpHeaders.cacheControlHeader, 'no-store');
      final body = utf8.encode(
        json.encode({
          'version': 1,
          'installation-id': installationId,
          'scope-key': scopeKey,
        }),
      );
      request.contentLength = body.length;
      request.add(body);
      final response = await request.close().timeout(timeout);
      final responseBody = await response
          .fold<List<int>>(<int>[], (bytes, chunk) {
            bytes.addAll(chunk);
            if (bytes.length > _maxSessionResponseBytes) {
              throw const TrafficAuthException('session response is too large');
            }
            return bytes;
          })
          .timeout(timeout);
      if (response.statusCode == HttpStatus.unauthorized) {
        throw const TrafficAuthException.unauthorized();
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw TrafficAuthException(
          'session exchange rejected with status ${response.statusCode}',
        );
      }
      return parseTrafficSessionResponse(
        utf8.decode(responseBody),
        now: DateTime.now().toUtc(),
      );
    } finally {
      client.close(force: true);
    }
  }
}

class TrafficSessionCache {
  final _sessions = <String, TrafficSession>{};

  TrafficSession? read(String key) => _sessions[key];

  void write(String key, TrafficSession session) => _sessions[key] = session;

  void remove(String key) => _sessions.remove(key);
}

class TianjiTrafficAuthenticator implements TrafficReportAuthenticator {
  TianjiTrafficAuthenticator({
    required this.profile,
    required this.transport,
    required this.cache,
    DateTime Function()? clock,
    this.timeout = const Duration(seconds: 15),
    this.refreshMargin = const Duration(seconds: 60),
  }) : _clock = clock ?? DateTime.now;

  final TianjiTrafficProfile profile;
  final TrafficSessionTransport transport;
  final TrafficSessionCache cache;
  final Duration timeout;
  final Duration refreshMargin;
  final DateTime Function() _clock;
  final _inflight = <String, Future<TrafficSession>>{};

  @override
  Future<String?> authorizationFor(
    Uri endpoint, {
    required String installationId,
    required String scopeKey,
  }) async {
    if (endpoint != profile.reportEndpoint) return null;
    if (installationId.isEmpty || scopeKey.isEmpty) return null;
    final key = _cacheKey(installationId, scopeKey);
    final cached = _validSession(key);
    if (cached != null) return 'Bearer ${cached.token}';
    final pending = _inflight.putIfAbsent(
      key,
      () => _exchange(key, installationId: installationId, scopeKey: scopeKey),
    );
    try {
      final session = await pending;
      return 'Bearer ${session.token}';
    } finally {
      _inflight.removeWhere(
        (entryKey, value) => entryKey == key && identical(value, pending),
      );
    }
  }

  @override
  void invalidate({
    required Uri endpoint,
    required String installationId,
    required String scopeKey,
  }) {
    if (endpoint != profile.reportEndpoint) return;
    cache.remove(_cacheKey(installationId, scopeKey));
  }

  Future<TrafficSession> _exchange(
    String key, {
    required String installationId,
    required String scopeKey,
  }) async {
    final session = await transport.exchange(
      endpoint: profile.sessionEndpoint,
      subscriptionToken: profile.subscriptionToken,
      installationId: installationId,
      scopeKey: scopeKey,
      timeout: timeout,
    );
    if (!_clock().toUtc().isBefore(session.expiresAt)) {
      throw const TrafficAuthException(
        'session exchange returned an expired token',
      );
    }
    cache.write(key, session);
    return session;
  }

  TrafficSession? _validSession(String key) {
    final session = cache.read(key);
    if (session == null) return null;
    final now = _clock().toUtc();
    if (now.isBefore(session.expiresAt.subtract(refreshMargin))) {
      return session;
    }
    cache.remove(key);
    return null;
  }

  String _cacheKey(String installationId, String scopeKey) {
    return '${profile.origin}|$installationId|$scopeKey|${profile.fingerprint}';
  }
}
