import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/core/traffic/model.dart';

const maxTrafficReportStreams = 64;
const maxTrafficReportBodyBytes = 64 * 1024;
const _maxTrafficReportResponseBytes = 16 * 1024;

class TrafficReportOptions {
  const TrafficReportOptions({
    required this.endpoint,
    required this.authenticator,
    required this.identityKey,
    this.timeout = const Duration(seconds: 15),
    this.interval = const Duration(minutes: 5),
  });

  final Uri endpoint;
  final TrafficReportAuthenticator authenticator;

  final String identityKey;
  final Duration timeout;
  final Duration interval;
}

bool validTrafficReportEndpoint(Uri endpoint) {
  return endpoint.isScheme('https') &&
      endpoint.host.isNotEmpty &&
      endpoint.userInfo.isEmpty &&
      endpoint.query.isEmpty &&
      endpoint.fragment.isEmpty;
}

abstract interface class TrafficReportAuthenticator {
  /// [scopeKey] is the opaque local profile scope the pending records belong
  /// to, so a real integration can bind a credential to that scope instead of
  /// sharing one token across profiles.
  Future<String?> authorizationFor(
    Uri endpoint, {
    required String installationId,
    required String scopeKey,
  });

  /// Drops the cached credential for this installation and scope after the
  /// server rejects it.
  void invalidate({
    required Uri endpoint,
    required String installationId,
    required String scopeKey,
  });
}

class TrafficReportAccepted {
  const TrafficReportAccepted({required this.streamId, required this.revision});

  final String streamId;
  final int revision;
}

class TrafficReportAck {
  const TrafficReportAck({
    required this.version,
    required this.accepted,
    required this.receivedAt,
  });

  static const protocolVersion = 1;

  final int version;
  final List<TrafficReportAccepted> accepted;
  final DateTime receivedAt;

  /// True only when the server acknowledged every stream in [batch], exactly
  /// once, at the revision that was sent or a newer stored one.
  bool covers(TrafficReportBatch batch) {
    if (version != 1) return false;
    if (accepted.length != batch.streams.length) return false;
    final byStreamId = <String, int>{};
    for (final item in accepted) {
      if (item.streamId.isEmpty) return false;
      if (byStreamId.containsKey(item.streamId)) return false;
      byStreamId[item.streamId] = item.revision;
    }
    for (final stream in batch.streams) {
      final acknowledged = byStreamId[stream.streamId];
      if (acknowledged == null || acknowledged < stream.revision) return false;
    }
    return true;
  }
}

TrafficReportAck parseTrafficReportAck(String body) {
  final Object? decoded;
  try {
    decoded = json.decode(body);
  } on FormatException {
    throw const TrafficReportException(
      'traffic report acknowledgement is not JSON',
    );
  }
  if (decoded is! Map) {
    throw const TrafficReportException(
      'traffic report acknowledgement is not an object',
    );
  }
  final version = decoded['version'];
  if (version is! int || version != TrafficReportAck.protocolVersion) {
    throw const TrafficReportException(
      'unsupported traffic report acknowledgement version',
    );
  }
  final rawAccepted = decoded['accepted'];
  if (rawAccepted is! List) {
    throw const TrafficReportException(
      'traffic report acknowledgement has no accepted list',
    );
  }
  final accepted = <TrafficReportAccepted>[];
  for (final item in rawAccepted) {
    if (item is! Map) {
      throw const TrafficReportException(
        'malformed traffic report acknowledgement entry',
      );
    }
    final streamId = item['stream-id'];
    final revision = item['revision'];
    if (streamId is! String || streamId.isEmpty) {
      throw const TrafficReportException(
        'traffic report acknowledgement entry has no stream id',
      );
    }
    if (revision is! int || revision < 1 || revision > 9007199254740991) {
      throw const TrafficReportException(
        'traffic report acknowledgement entry has no revision',
      );
    }
    accepted.add(
      TrafficReportAccepted(streamId: streamId, revision: revision.toInt()),
    );
  }
  final receivedAt = decoded['received-at'];
  if (receivedAt is! String || DateTime.tryParse(receivedAt) == null) {
    throw const TrafficReportException(
      'traffic report acknowledgement has no received time',
    );
  }
  return TrafficReportAck(
    version: version.toInt(),
    accepted: accepted,
    receivedAt: DateTime.parse(receivedAt).toUtc(),
  );
}

abstract interface class TrafficReportTransport {
  Future<TrafficReportAck> send(
    TrafficReportBatch batch, {
    required Uri endpoint,
    required String authorization,
    required Duration timeout,
  });
}

class HttpTrafficReportTransport implements TrafficReportTransport {
  const HttpTrafficReportTransport();

  @override
  Future<TrafficReportAck> send(
    TrafficReportBatch batch, {
    required Uri endpoint,
    required String authorization,
    required Duration timeout,
  }) async {
    if (!validTrafficReportEndpoint(endpoint)) {
      throw const TrafficReportException('refusing a non-HTTPS report origin');
    }
    if (batch.streams.isEmpty ||
        batch.streams.length > maxTrafficReportStreams) {
      throw const TrafficReportException('refusing an invalid stream count');
    }
    final body = utf8.encode(json.encode(batch.toJson()));
    if (body.length > maxTrafficReportBodyBytes) {
      throw const TrafficReportException('refusing an oversized report body');
    }
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final request = await client.postUrl(endpoint).timeout(timeout);
      request.followRedirects = false;
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.acceptHeader, ContentType.json.mimeType);
      request.headers.set(HttpHeaders.authorizationHeader, authorization);
      request.headers.set(HttpHeaders.cacheControlHeader, 'no-store');
      request.contentLength = body.length;
      request.add(body);
      final response = await request.close().timeout(timeout);
      final responseBody = await response
          .fold<List<int>>(<int>[], (bytes, chunk) {
            bytes.addAll(chunk);
            if (bytes.length > _maxTrafficReportResponseBytes) {
              throw const TrafficReportException(
                'traffic report acknowledgement is too large',
              );
            }
            return bytes;
          })
          .timeout(timeout);
      if (response.statusCode == HttpStatus.unauthorized) {
        throw const TrafficReportUnauthorizedException();
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw TrafficReportException(
          'traffic report rejected with status ${response.statusCode}',
        );
      }
      return parseTrafficReportAck(utf8.decode(responseBody));
    } finally {
      client.close(force: true);
    }
  }
}

class TrafficReportException implements Exception {
  const TrafficReportException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class TrafficReportUnauthorizedException extends TrafficReportException {
  const TrafficReportUnauthorizedException()
    : super('traffic report authorization expired', statusCode: 401);
}
