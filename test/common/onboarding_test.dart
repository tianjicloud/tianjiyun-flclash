import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/exception.dart';
import 'package:fl_clash/common/link.dart';
import 'package:fl_clash/common/onboarding.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _dio({
  int? statusCode,
  DioExceptionType type = DioExceptionType.badResponse,
  Object? error,
}) {
  final request = RequestOptions(path: 'https://example.com/s/example');
  return DioException(
    requestOptions: request,
    type: type,
    error: error,
    response: statusCode == null
        ? null
        : Response(requestOptions: request, statusCode: statusCode),
  );
}

void main() {
  group('classifyImportError', () {
    test('maps missing or forbidden subscriptions to expired', () {
      for (final statusCode in [401, 403, 404]) {
        expect(
          classifyImportError(_dio(statusCode: statusCode)),
          ImportFailure.expired,
        );
      }
    });

    test('maps server failures to unreachable', () {
      expect(
        classifyImportError(_dio(statusCode: 500)),
        ImportFailure.unreachable,
      );
      expect(
        classifyImportError(_dio(statusCode: 503)),
        ImportFailure.unreachable,
      );
    });

    test('maps connection and timeout failures to unreachable', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.transformTimeout,
        DioExceptionType.connectionError,
      ]) {
        expect(
          classifyImportError(_dio(type: type)),
          ImportFailure.unreachable,
        );
      }
      expect(
        classifyImportError(
          _dio(
            type: DioExceptionType.unknown,
            error: const SocketException('offline'),
          ),
        ),
        ImportFailure.unreachable,
      );
      expect(
        classifyImportError(TimeoutException('slow')),
        ImportFailure.unreachable,
      );
    });

    test('maps validation failures to notSubscription', () {
      expect(
        classifyImportError(const MessageException('invalid config')),
        ImportFailure.notSubscription,
      );
    });

    test('maps anything else to unknown', () {
      expect(classifyImportError(_dio(statusCode: 400)), ImportFailure.unknown);
      expect(
        classifyImportError(StateError('unexpected')),
        ImportFailure.unknown,
      );
    });
  });

  group('subscriptionSummaryOf', () {
    test('hides traffic and expiry when both are zero', () {
      final summary = subscriptionSummaryOf(
        const SubscriptionInfo(total: 0, expire: 0),
      );
      expect(summary.isEmpty, isTrue);
      expect(summary.remaining, isNull);
      expect(summary.expire, isNull);
    });

    test('hides expiry when it is zero', () {
      final summary = subscriptionSummaryOf(
        const SubscriptionInfo(
          upload: 100,
          download: 200,
          total: 1000,
          expire: 0,
        ),
      );
      expect(summary.remaining, 700);
      expect(summary.expire, isNull);
    });

    test('hides traffic when the total is zero', () {
      final summary = subscriptionSummaryOf(
        const SubscriptionInfo(total: 0, expire: 1700000000),
      );
      expect(summary.remaining, isNull);
      expect(summary.expire, isNotNull);
    });
  });

  group('subscriptionUrlFromText', () {
    test('accepts an http or https url with surrounding whitespace', () {
      expect(
        subscriptionUrlFromText(' https://example.com/s/example\n'),
        'https://example.com/s/example',
      );
    });

    test('unwraps an install-config url for each scheme', () {
      for (final scheme in ['clash', 'clashmeta', 'tianji']) {
        expect(
          subscriptionUrlFromText(
            '$scheme://install-config?url=https%3A%2F%2Fexample.com%2Fs%2Fexample',
          ),
          'https://example.com/s/example',
        );
      }
    });

    test('rejects share links, other schemes and plain text', () {
      expect(
        subscriptionUrlFromText('vmess://eyJhZGQiOiIxLjIuMy40In0='),
        isNull,
      );
      expect(subscriptionUrlFromText('ftp://example.com/a'), isNull);
      expect(subscriptionUrlFromText('plain text'), isNull);
      expect(subscriptionUrlFromText(''), isNull);
    });
  });
}
