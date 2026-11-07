import 'dart:async';

import 'package:fl_clash/core/traffic/auth.dart';
import 'package:flutter_test/flutter_test.dart';

class _Clock {
  _Clock(this.now);

  DateTime now;

  DateTime call() => now;

  void advance(Duration duration) {
    now = now.add(duration);
  }
}

typedef _Call = ({
  Uri endpoint,
  String subscriptionToken,
  String installationId,
  String scopeKey,
});

class _SessionTransport implements TrafficSessionTransport {
  _SessionTransport(this.session);

  TrafficSession Function(int call)? session;
  Exception? error;
  Completer<void>? gate;
  final calls = <_Call>[];

  @override
  Future<TrafficSession> exchange({
    required Uri endpoint,
    required String subscriptionToken,
    required String installationId,
    required String scopeKey,
    required Duration timeout,
  }) async {
    calls.add((
      endpoint: endpoint,
      subscriptionToken: subscriptionToken,
      installationId: installationId,
      scopeKey: scopeKey,
    ));
    final gate = this.gate;
    if (gate != null) await gate.future;
    final error = this.error;
    if (error != null) throw error;
    return (session ?? (call) => _session(call))(calls.length);
  }
}

TrafficSession _session(
  int call, {
  Duration ttl = const Duration(minutes: 15),
  DateTime? now,
}) {
  final base = now ?? DateTime.utc(2026, 11, 7, 12);
  return TrafficSession(token: 'session-$call', expiresAt: base.add(ttl));
}

const _url = 'https://sub1.tianjiyun.org/s/abcdefgh12345678';
const _installation = '0123456789abcdef0123456789abcdef';
const _scope = '0123456789abcdef01234567';

TianjiTrafficProfile _profile([String url = _url, String profileId = '42']) {
  final profile = TianjiTrafficProfile.resolve(profileId: profileId, url: url);
  expect(profile, isNotNull);
  return profile!;
}

void main() {
  group('TianjiTrafficProfile', () {
    test('recognizes every supported subscription origin', () {
      for (final host in const [
        'bslvn.divinations.top',
        'vn3kq.divinations.top',
        'sub1.tianjiyun.org',
        'sub.nianyi.de5.net',
        'sub.242.cc.cd',
        'sub.262.cc.cd',
      ]) {
        final profile = TianjiTrafficProfile.resolve(
          profileId: '42',
          url: 'https://$host/s/abcdefgh12345678',
        );
        expect(profile, isNotNull, reason: host);
        expect(
          profile!.sessionEndpoint.toString(),
          'https://$host/s/tianji-traffic/session',
        );
        expect(
          profile.reportEndpoint.toString(),
          'https://$host/s/tianji-traffic/report',
        );
      }
    });

    test('recognizes the official subscribe path with one token', () {
      final profile = TianjiTrafficProfile.resolve(
        profileId: '42',
        url:
            'https://sub1.tianjiyun.org/api/v1/client/subscribe?token=abcdefgh12345678',
      );
      expect(profile, isNotNull);
      expect(profile!.subscriptionToken, 'abcdefgh12345678');
    });

    test('rejects a numeric user id used as a subscription', () {
      expect(
        TianjiTrafficProfile.resolve(
          profileId: '42',
          url: 'https://sub1.tianjiyun.org/s/1234567890123456',
        ),
        isNull,
      );
    });

    test('rejects hostile, insecure, credential-bearing and ambiguous URLs', () {
      for (final url in const [
        'https://evil.example/s/abcdefgh12345678',
        'http://sub1.tianjiyun.org/s/abcdefgh12345678',
        'https://user@sub1.tianjiyun.org/s/abcdefgh12345678',
        'https://sub1.tianjiyun.org:8443/s/abcdefgh12345678',
        'https://sub1.tianjiyun.org/s/abcdefgh12345678?token=other1234',
        'https://sub1.tianjiyun.org/s/abcdefgh12345678#fragment',
        'https://sub1.tianjiyun.org/other/abcdefgh12345678',
        'https://sub1.tianjiyun.org/s/short',
        'https://sub1.tianjiyun.org/api/v1/client/subscribe?token=one12345&token=two12345',
        'https://sub1.tianjiyun.org/api/v1/client/subscribe',
      ]) {
        expect(
          TianjiTrafficProfile.resolve(profileId: '42', url: url),
          isNull,
          reason: url,
        );
      }
    });

    test('format query parameters do not alter the subscription identity', () {
      final profile = _profile('$_url?flag=clash');
      expect(profile.identityKey, _profile().identityKey);
      expect(profile.sessionEndpoint.query, isEmpty);
      expect(profile.reportEndpoint.query, isEmpty);
    });

    test('the identity and accounting scope are stable for one profile', () {
      final first = _profile();
      final second = _profile();
      expect(first.identityKey, second.identityKey);
      expect(first.profileId, '42');
      expect(first.toString(), isNot(contains('abcdefgh12345678')));
    });

    test('rotating the token changes the identity for the same profile id', () {
      final first = _profile();
      final rotated = _profile('https://sub1.tianjiyun.org/s/rotated12345678');
      expect(rotated.profileId, first.profileId);
      expect(rotated.identityKey, isNot(first.identityKey));
    });
  });

  group('session response', () {
    test('parses a complete response', () {
      final now = DateTime.utc(2026, 11, 7, 12);
      final session = parseTrafficSessionResponse(
        '{"version":1,"token":"a.b.c","expires-at":${now.add(const Duration(minutes: 15)).millisecondsSinceEpoch ~/ 1000}}',
        now: now,
      );
      expect(session.token, 'a.b.c');
      expect(session.expiresAt, now.add(const Duration(minutes: 15)));
    });

    test('rejects an invalid or expired response', () {
      final now = DateTime.utc(2026, 11, 7, 12);
      for (final body in [
        'not json',
        '{"version":2,"token":"abc","expires-at":${now.millisecondsSinceEpoch ~/ 1000 + 900}}',
        '{"version":1,"token":"","expires-at":${now.millisecondsSinceEpoch ~/ 1000 + 900}}',
        '{"version":1,"expires-at":${now.millisecondsSinceEpoch ~/ 1000 + 900}}',
        '{"version":1,"token":"abc"}',
        '{"version":1,"token":"abc","expires-at":${now.millisecondsSinceEpoch ~/ 1000 - 1}}',
      ]) {
        expect(
          () => parseTrafficSessionResponse(body, now: now),
          throwsA(isA<TrafficAuthException>()),
          reason: body,
        );
      }
    });
  });

  group('TianjiTrafficAuthenticator', () {
    test(
      'exchanges for the profile scope and caches the bearer token',
      () async {
        final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
        final transport = _SessionTransport(
          (call) => _session(call, now: clock.now),
        );
        final authenticator = TianjiTrafficAuthenticator(
          profile: _profile(),
          transport: transport,
          cache: TrafficSessionCache(),
          clock: clock.call,
        );

        expect(
          await authenticator.authorizationFor(
            _profile().reportEndpoint,
            installationId: _installation,
            scopeKey: _scope,
          ),
          'Bearer session-1',
        );
        expect(transport.calls, hasLength(1));
        expect(transport.calls.single.endpoint, _profile().sessionEndpoint);
        expect(transport.calls.single.subscriptionToken, 'abcdefgh12345678');
        expect(transport.calls.single.installationId, _installation);
        expect(transport.calls.single.scopeKey, _scope);

        expect(
          await authenticator.authorizationFor(
            _profile().reportEndpoint,
            installationId: _installation,
            scopeKey: _scope,
          ),
          'Bearer session-1',
        );
        expect(transport.calls, hasLength(1), reason: 'cached');
      },
    );

    test('refreshes before the 900 second expiry', () async {
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final transport = _SessionTransport(
        (call) => _session(call, now: clock.now),
      );
      final authenticator = TianjiTrafficAuthenticator(
        profile: _profile(),
        transport: transport,
        cache: TrafficSessionCache(),
        clock: clock.call,
      );

      await authenticator.authorizationFor(
        _profile().reportEndpoint,
        installationId: _installation,
        scopeKey: _scope,
      );
      clock.advance(const Duration(seconds: 800));
      await authenticator.authorizationFor(
        _profile().reportEndpoint,
        installationId: _installation,
        scopeKey: _scope,
      );
      expect(transport.calls, hasLength(1));

      clock.advance(const Duration(seconds: 50));
      expect(
        await authenticator.authorizationFor(
          _profile().reportEndpoint,
          installationId: _installation,
          scopeKey: _scope,
        ),
        'Bearer session-2',
      );
      expect(transport.calls, hasLength(2));
    });

    test('invalidation forces the next exchange', () async {
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final transport = _SessionTransport(
        (call) => _session(call, now: clock.now),
      );
      final profile = _profile();
      final authenticator = TianjiTrafficAuthenticator(
        profile: profile,
        transport: transport,
        cache: TrafficSessionCache(),
        clock: clock.call,
      );

      await authenticator.authorizationFor(
        profile.reportEndpoint,
        installationId: _installation,
        scopeKey: _scope,
      );
      authenticator.invalidate(
        endpoint: profile.reportEndpoint,
        installationId: _installation,
        scopeKey: _scope,
      );
      expect(
        await authenticator.authorizationFor(
          profile.reportEndpoint,
          installationId: _installation,
          scopeKey: _scope,
        ),
        'Bearer session-2',
      );
      expect(transport.calls, hasLength(2));
    });

    test('a rotated subscription token never reuses the old session', () async {
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final transport = _SessionTransport(
        (call) => _session(call, now: clock.now),
      );
      final cache = TrafficSessionCache();
      final first = TianjiTrafficAuthenticator(
        profile: _profile(),
        transport: transport,
        cache: cache,
        clock: clock.call,
      );
      await first.authorizationFor(
        _profile().reportEndpoint,
        installationId: _installation,
        scopeKey: _scope,
      );
      expect(transport.calls, hasLength(1));

      final rotatedProfile = _profile(
        'https://sub1.tianjiyun.org/s/rotated12345678',
      );
      final rotated = TianjiTrafficAuthenticator(
        profile: rotatedProfile,
        transport: transport,
        cache: cache,
        clock: clock.call,
      );
      expect(
        await rotated.authorizationFor(
          rotatedProfile.reportEndpoint,
          installationId: _installation,
          scopeKey: _scope,
        ),
        'Bearer session-2',
      );
      expect(transport.calls, hasLength(2));
      expect(transport.calls.last.subscriptionToken, 'rotated12345678');
    });

    test('ignores a report origin that is not its own', () async {
      final transport = _SessionTransport((call) => _session(call));
      final authenticator = TianjiTrafficAuthenticator(
        profile: _profile(),
        transport: transport,
        cache: TrafficSessionCache(),
        clock: _Clock(DateTime.utc(2026, 11, 7, 12)).call,
      );
      expect(
        await authenticator.authorizationFor(
          Uri.parse('https://evil.example/s/tianji-traffic/report'),
          installationId: _installation,
          scopeKey: _scope,
        ),
        isNull,
      );
      expect(transport.calls, isEmpty);
    });

    test('coalesces concurrent exchanges for one key', () async {
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final transport = _SessionTransport(
        (call) => _session(call, now: clock.now),
      )..gate = Completer<void>();
      final profile = _profile();
      final authenticator = TianjiTrafficAuthenticator(
        profile: profile,
        transport: transport,
        cache: TrafficSessionCache(),
        clock: clock.call,
      );

      final first = authenticator.authorizationFor(
        profile.reportEndpoint,
        installationId: _installation,
        scopeKey: _scope,
      );
      final second = authenticator.authorizationFor(
        profile.reportEndpoint,
        installationId: _installation,
        scopeKey: _scope,
      );
      await Future<void>.delayed(Duration.zero);
      expect(transport.calls, hasLength(1));
      transport.gate!.complete();
      expect(await first, 'Bearer session-1');
      expect(await second, 'Bearer session-1');
      expect(transport.calls, hasLength(1));
    });

    test('an expired exchanged session is not cached', () async {
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final transport = _SessionTransport(
        (call) => _session(
          call,
          now: clock.now.subtract(const Duration(minutes: 16)),
        ),
      );
      final profile = _profile();
      final authenticator = TianjiTrafficAuthenticator(
        profile: profile,
        transport: transport,
        cache: TrafficSessionCache(),
        clock: clock.call,
      );

      await expectLater(
        authenticator.authorizationFor(
          profile.reportEndpoint,
          installationId: _installation,
          scopeKey: _scope,
        ),
        throwsA(isA<TrafficAuthException>()),
      );
      expect(transport.calls, hasLength(1));
      await expectLater(
        authenticator.authorizationFor(
          profile.reportEndpoint,
          installationId: _installation,
          scopeKey: _scope,
        ),
        throwsA(isA<TrafficAuthException>()),
      );
      expect(transport.calls, hasLength(2), reason: 'nothing was cached');
    });
  });
}
