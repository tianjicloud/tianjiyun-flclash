import 'dart:math' as math;

import 'package:fl_clash/models/profile.dart';

DateTime? profileExpiryOf(Profile? profile) {
  final expire = profile?.subscriptionInfo?.expire ?? 0;
  return expire > 0 ? DateTime.fromMillisecondsSinceEpoch(expire * 1000) : null;
}

int profileDaysLeft(DateTime expiry) =>
    math.max(0, expiry.difference(DateTime.now()).inDays);
