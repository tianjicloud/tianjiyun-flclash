import 'dart:convert';

import 'package:crypto/crypto.dart';

class TrafficBytes {
  const TrafficBytes({this.up = 0, this.down = 0});

  final int up;
  final int down;

  static const zero = TrafficBytes();

  int get total => up + down;

  bool get isZero => up == 0 && down == 0;

  bool get isValid => up >= 0 && down >= 0;

  TrafficBytes operator +(TrafficBytes other) =>
      TrafficBytes(up: up + other.up, down: down + other.down);

  Map<String, Object?> toJson() => {'up': up, 'down': down};

  factory TrafficBytes.fromJson(Object? json) {
    if (json is! Map) return zero;
    return TrafficBytes(up: _int(json['up']), down: _int(json['down']));
  }

  @override
  bool operator ==(Object other) =>
      other is TrafficBytes && other.up == up && other.down == down;

  @override
  int get hashCode => Object.hash(up, down);

  @override
  String toString() => 'TrafficBytes(up: $up, down: $down)';
}

class TrafficAllocation {
  const TrafficAllocation({
    this.mainlandDirect = TrafficBytes.zero,
    this.proxy = TrafficBytes.zero,
    this.otherDirect = TrafficBytes.zero,
  });

  final TrafficBytes mainlandDirect;
  final TrafficBytes proxy;
  final TrafficBytes otherDirect;

  static const zero = TrafficAllocation();

  bool get isValid =>
      mainlandDirect.isValid && proxy.isValid && otherDirect.isValid;

  TrafficAllocation operator +(TrafficAllocation other) => TrafficAllocation(
    mainlandDirect: mainlandDirect + other.mainlandDirect,
    proxy: proxy + other.proxy,
    otherDirect: otherDirect + other.otherDirect,
  );

  Map<String, Object?> toJson() => {
    'mainland-direct': mainlandDirect.toJson(),
    'proxy': proxy.toJson(),
    'other-direct': otherDirect.toJson(),
  };

  factory TrafficAllocation.fromJson(Object? json) {
    if (json is! Map) return zero;
    return TrafficAllocation(
      mainlandDirect: TrafficBytes.fromJson(json['mainland-direct']),
      proxy: TrafficBytes.fromJson(json['proxy']),
      otherDirect: TrafficBytes.fromJson(json['other-direct']),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TrafficAllocation &&
      other.mainlandDirect == mainlandDirect &&
      other.proxy == proxy &&
      other.otherDirect == otherDirect;

  @override
  int get hashCode => Object.hash(mainlandDirect, proxy, otherDirect);
}

class TrafficSnapshot {
  const TrafficSnapshot({
    required this.version,
    required this.epoch,
    required this.mainlandDirect,
    required this.proxy,
    required this.otherDirect,
  });

  final int version;
  final int epoch;
  final TrafficBytes mainlandDirect;
  final TrafficBytes proxy;
  final TrafficBytes otherDirect;

  factory TrafficSnapshot.fromJson(Map<String, Object?> json) {
    return TrafficSnapshot(
      version: _int(json['version']),
      epoch: _int(json['epoch']),
      mainlandDirect: TrafficBytes.fromJson(json['mainland-direct']),
      proxy: TrafficBytes.fromJson(json['proxy']),
      otherDirect: TrafficBytes.fromJson(json['other-direct']),
    );
  }

  TrafficAllocation get allocation => TrafficAllocation(
    mainlandDirect: mainlandDirect,
    proxy: proxy,
    otherDirect: otherDirect,
  );

  bool get isValid =>
      version == 1 &&
      epoch >= 0 &&
      mainlandDirect.isValid &&
      proxy.isValid &&
      otherDirect.isValid;

  bool countersBelow(TrafficSnapshot other) =>
      mainlandDirect.up < other.mainlandDirect.up ||
      mainlandDirect.down < other.mainlandDirect.down ||
      proxy.up < other.proxy.up ||
      proxy.down < other.proxy.down ||
      otherDirect.up < other.otherDirect.up ||
      otherDirect.down < other.otherDirect.down;
}

class TrafficDayRecord {
  const TrafficDayRecord({
    required this.day,
    required this.scopeKey,
    required this.allocation,
    this.revision = 0,
    this.acknowledgedRevision = 0,
  });

  final String day;
  final String scopeKey;
  final TrafficAllocation allocation;
  final int revision;
  final int acknowledgedRevision;

  String get key => '$day|$scopeKey';

  bool get pending => revision > acknowledgedRevision;

  TrafficDayRecord accumulate(TrafficAllocation delta) {
    if (delta.mainlandDirect.isZero &&
        delta.proxy.isZero &&
        delta.otherDirect.isZero) {
      return this;
    }
    return TrafficDayRecord(
      day: day,
      scopeKey: scopeKey,
      allocation: allocation + delta,
      revision: revision + 1,
      acknowledgedRevision: acknowledgedRevision,
    );
  }

  TrafficDayRecord acknowledge(int sentRevision) {
    if (sentRevision <= acknowledgedRevision) {
      return this;
    }
    return TrafficDayRecord(
      day: day,
      scopeKey: scopeKey,
      allocation: allocation,
      revision: revision,
      acknowledgedRevision: sentRevision,
    );
  }

  Map<String, Object?> toJson() => {
    'day': day,
    'scope-key': scopeKey,
    'allocation': allocation.toJson(),
    'revision': revision,
    'acknowledged-revision': acknowledgedRevision,
  };

  factory TrafficDayRecord.fromJson(Object? json) {
    final map = json is Map ? json : const <String, Object?>{};
    return TrafficDayRecord(
      day: map['day'] as String? ?? '',
      scopeKey: map['scope-key'] as String? ?? '',
      allocation: TrafficAllocation.fromJson(map['allocation']),
      revision: _int(map['revision']),
      acknowledgedRevision: _int(map['acknowledged-revision']),
    );
  }
}

class TrafficAccountingState {
  const TrafficAccountingState({
    required this.installationId,
    required this.scopeId,
    required this.scopeKey,
    required this.hasBaseline,
    required this.baseline,
    required this.epoch,
    required this.days,
  });

  final String installationId;
  final String scopeId;
  final String scopeKey;
  final bool hasBaseline;
  final TrafficAllocation baseline;
  final int epoch;
  final Map<String, TrafficDayRecord> days;

  bool get isValid => epoch >= 0 && baseline.isValid;

  factory TrafficAccountingState.empty(String installationId) {
    return TrafficAccountingState(
      installationId: installationId,
      scopeId: '',
      scopeKey: 'none',
      hasBaseline: false,
      baseline: TrafficAllocation.zero,
      epoch: 0,
      days: const {},
    );
  }

  TrafficAccountingState copyWith({
    String? scopeId,
    String? scopeKey,
    bool? hasBaseline,
    TrafficAllocation? baseline,
    int? epoch,
    Map<String, TrafficDayRecord>? days,
  }) {
    return TrafficAccountingState(
      installationId: installationId,
      scopeId: scopeId ?? this.scopeId,
      scopeKey: scopeKey ?? this.scopeKey,
      hasBaseline: hasBaseline ?? this.hasBaseline,
      baseline: baseline ?? this.baseline,
      epoch: epoch ?? this.epoch,
      days: days ?? this.days,
    );
  }

  Map<String, Object?> toJson() => {
    'version': 1,
    'installation-id': installationId,
    'scope-id': scopeId,
    'scope-key': scopeKey,
    'has-baseline': hasBaseline,
    'baseline': baseline.toJson(),
    'epoch': epoch,
    'days': [for (final record in days.values) record.toJson()],
  };

  factory TrafficAccountingState.fromJson(
    Map<String, Object?> json, {
    required String fallbackInstallationId,
  }) {
    final records = <String, TrafficDayRecord>{};
    final rawDays = json['days'];
    if (rawDays is List) {
      for (final item in rawDays) {
        final record = TrafficDayRecord.fromJson(item);
        if (record.day.isNotEmpty) {
          records[record.key] = record;
        }
      }
    }
    final installationId = json['installation-id'] as String?;
    return TrafficAccountingState(
      installationId: installationId?.isNotEmpty == true
          ? installationId!
          : fallbackInstallationId,
      scopeId: json['scope-id'] as String? ?? '',
      scopeKey: json['scope-key'] as String? ?? 'none',
      hasBaseline: json['has-baseline'] as bool? ?? false,
      baseline: TrafficAllocation.fromJson(json['baseline']),
      epoch: _int(json['epoch']),
      days: records,
    );
  }
}

class TrafficSummary {
  const TrafficSummary({
    this.today = TrafficAllocation.zero,
    this.month = TrafficAllocation.zero,
  });

  final TrafficAllocation today;
  final TrafficAllocation month;

  static const empty = TrafficSummary();

  int get todayMainlandDirect => today.mainlandDirect.total;
  int get todayProxy => today.proxy.total;
  int get monthMainlandDirect => month.mainlandDirect.total;
  int get monthProxy => month.proxy.total;
  int get monthSavings => month.mainlandDirect.total;
}

class TrafficReportStream {
  const TrafficReportStream({
    required this.streamId,
    required this.day,
    required this.scopeKey,
    required this.revision,
    required this.allocation,
  });

  final String streamId;
  final String day;
  final String scopeKey;
  final int revision;
  final TrafficAllocation allocation;

  Map<String, Object?> toJson() => {
    'stream-id': streamId,
    'day': day,
    'scope-key': scopeKey,
    'revision': revision,
    ...allocation.toJson(),
  };
}

class TrafficReportBatch {
  const TrafficReportBatch({
    required this.installationId,
    required this.sentAt,
    required this.streams,
  });

  static const version = 1;

  final String installationId;
  final DateTime sentAt;
  final List<TrafficReportStream> streams;

  Map<String, Object?> toJson() => {
    'version': version,
    'installation-id': installationId,
    'sent-at': sentAt.toUtc().toIso8601String(),
    'streams': [for (final stream in streams) stream.toJson()],
  };
}

String trafficStreamId(String installationId, String day, String scopeKey) {
  final digest = sha256.convert(utf8.encode('$installationId|$day|$scopeKey'));
  return digest.toString();
}

String utcDayKey(DateTime time) {
  final utc = time.toUtc();
  final month = utc.month.toString().padLeft(2, '0');
  final day = utc.day.toString().padLeft(2, '0');
  return '${utc.year}-$month-$day';
}

int _int(Object? value) => value is num ? value.toInt() : 0;
