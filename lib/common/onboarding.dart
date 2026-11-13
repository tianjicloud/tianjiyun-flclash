import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/exception.dart';
import 'package:fl_clash/models/profile.dart';

const userPanelUrl = 'https://panel.tianjiyun.org';
const statusPageUrl = 'https://status.tianjiyun.org';
const supportEmail = 'business@tianjiyun.org';

enum ImportFailure { expired, unreachable, empty, notSubscription, unknown }

ImportFailure classifyImportError(Object error) {
  if (error is DioException) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401 || statusCode == 403 || statusCode == 404) {
      return ImportFailure.expired;
    }
    if (statusCode != null && statusCode >= 500) {
      return ImportFailure.unreachable;
    }
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout ||
      DioExceptionType.connectionError => ImportFailure.unreachable,
      DioExceptionType.unknown =>
        error.error is SocketException || error.error is TimeoutException
            ? ImportFailure.unreachable
            : ImportFailure.unknown,
      _ => ImportFailure.unknown,
    };
  }
  if (error is TimeoutException || error is SocketException) {
    return ImportFailure.unreachable;
  }
  if (error is MessageException) {
    return ImportFailure.notSubscription;
  }
  return ImportFailure.unknown;
}

class SubscriptionSummary {
  const SubscriptionSummary({this.remaining, this.expire});

  final int? remaining;
  final DateTime? expire;

  bool get isEmpty => remaining == null && expire == null;
}

SubscriptionSummary subscriptionSummaryOf(SubscriptionInfo? info) {
  if (info == null) return const SubscriptionSummary();
  final remaining = info.total > 0
      ? (info.total - info.upload - info.download).clamp(0, info.total).toInt()
      : null;
  final expire = info.expire > 0
      ? DateTime.fromMillisecondsSinceEpoch(info.expire * 1000)
      : null;
  return SubscriptionSummary(remaining: remaining, expire: expire);
}
