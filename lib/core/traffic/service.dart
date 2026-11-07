import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/core/traffic/report.dart';
import 'package:fl_clash/core/traffic/store.dart';
import 'package:flutter/foundation.dart' show ValueNotifier;

const _maxReportStreams = 64;
const _maxRetainedRecords = 512;

typedef _PreparedReport = ({
  TrafficReportBatch batch,
  String installationId,
  String scopeId,
  String scopeKey,
  int scopeRevision,
  String identityKey,
  DateTime now,
});

class TrafficAccountingService {
  TrafficAccountingService({
    required TrafficStatsStore store,
    required Future<TrafficSnapshot> Function() readSnapshot,
    DateTime Function()? clock,
    this.sampleInterval = trafficAccountingSampleInterval,
    this.flushInterval = trafficAccountingFlushInterval,
    this.retentionDays = trafficAccountingRetentionDays,
  }) : _store = store,
       _readSnapshot = readSnapshot,
       _clock = clock ?? DateTime.now;

  final TrafficStatsStore _store;
  final Future<TrafficSnapshot> Function() _readSnapshot;
  final DateTime Function() _clock;
  final Duration sampleInterval;
  final Duration flushInterval;
  final int retentionDays;

  final summary = ValueNotifier<TrafficSummary>(TrafficSummary.empty);

  TrafficAccountingState _state = TrafficAccountingState.empty('');
  Future<void>? _startFuture;
  String _desiredScopeId = '';
  bool _scopeRequested = false;
  int _scopeRevision = 0;
  int _baselineScopeRevision = 0;
  bool _stateLoaded = false;
  Timer? _sampleTimer;
  Timer? _flushTimer;
  Timer? _reportTimer;
  TrafficReportOptions? _reportOptions;
  TrafficReportTransport? _reportTransport;
  Future<void> _serial = Future<void>.value();
  bool _disposed = false;
  bool _dirty = false;
  bool _sampleQueued = false;
  bool _flushQueued = false;
  bool _uploading = false;
  int _reportFailures = 0;
  DateTime? _nextUploadAt;

  bool get isStarted => _startFuture != null;

  Future<void> start() {
    final existing = _startFuture;
    if (existing != null) return existing;
    if (_disposed) return Future<void>.value();
    final ready = _enqueue(_ensureLoaded);
    _startFuture = ready;
    unawaited(
      ready.then((_) {
        if (_disposed) return;
        _sampleTimer = Timer.periodic(
          sampleInterval,
          (_) => unawaited(sample()),
        );
        _flushTimer = Timer.periodic(flushInterval, (_) => unawaited(flush()));
      }),
    );
    return ready;
  }

  void configureReporting({
    required TrafficReportOptions options,
    required TrafficReportTransport transport,
  }) {
    if (_disposed ||
        !validTrafficReportEndpoint(options.endpoint) ||
        options.identityKey.isEmpty) {
      return;
    }
    if (_reportOptions?.identityKey != options.identityKey) {
      _reportFailures = 0;
      _nextUploadAt = null;
    }
    _reportOptions = options;
    _reportTransport = transport;
    _reportTimer?.cancel();
    _reportTimer = Timer.periodic(options.interval, (_) => unawaited(upload()));
  }

  void stopReporting() {
    if (_disposed) return;
    _reportTimer?.cancel();
    _reportTimer = null;
    _reportOptions = null;
    _reportTransport = null;
    _reportFailures = 0;
    _nextUploadAt = null;
  }

  /// The local profile id. It identifies a configuration scope on this
  /// device; it is not an authenticated server account.
  Future<void> setScope(String? scopeId) async {
    final desired = _normalizeScopeId(scopeId);
    if (_scopeRequested && desired != _desiredScopeId) _scopeRevision++;
    _desiredScopeId = desired;
    _scopeRequested = true;
    await start();
    if (_disposed) return;
    await _enqueue(() async {
      if (_disposed) return;
      if (!await _ensureLoaded()) return;
      if (_disposed) return;
      await _applyDesiredScope();
    });
  }

  Future<void> sample() async {
    if (_sampleQueued) return;
    _sampleQueued = true;
    try {
      await start();
      if (_disposed) return;
      await _enqueue(() async {
        try {
          await _sampleOnce();
        } finally {
          _sampleQueued = false;
        }
      });
    } finally {
      _sampleQueued = false;
    }
  }

  Future<void> flush() async {
    if (_flushQueued) return;
    _flushQueued = true;
    try {
      await start();
      if (_disposed) return;
      await _enqueue(() async {
        try {
          await _flushOnce();
        } finally {
          _flushQueued = false;
        }
      });
    } finally {
      _flushQueued = false;
    }
  }

  Future<void> upload() async {
    if (_disposed || _uploading) return;
    _uploading = true;
    TrafficReportOptions? options;
    _PreparedReport? prepared;
    try {
      await start();
      if (_disposed) return;
      options = _reportOptions;
      final transport = _reportTransport;
      if (options == null || transport == null) return;
      if (!validTrafficReportEndpoint(options.endpoint)) return;

      final identityKey = options.identityKey;
      prepared = await _enqueue(() => _prepareUpload(identityKey));
      if (_disposed || prepared == null) return;

      final authorization = await options.authenticator
          .authorizationFor(
            options.endpoint,
            installationId: prepared.installationId,
            scopeKey: prepared.scopeKey,
          )
          .timeout(options.timeout);
      if (_disposed) return;
      if (authorization == null || authorization.isEmpty) return;
      if (!_scopeStillMatches(prepared)) return;

      final ack = await transport
          .send(
            prepared.batch,
            endpoint: options.endpoint,
            authorization: authorization,
            timeout: options.timeout,
          )
          .timeout(options.timeout);
      if (_disposed) return;
      if (!ack.covers(prepared.batch)) {
        throw const TrafficReportException(
          'incomplete traffic report acknowledgement',
        );
      }

      final acknowledged = prepared;
      await _enqueue(() async {
        final days = Map.of(_state.days);
        var changed = false;
        for (final stream in acknowledged.batch.streams) {
          final key = '${stream.day}|${stream.scopeKey}';
          final record = days[key];
          if (record == null) continue;
          final next = record.acknowledge(stream.revision);
          if (!identical(next, record)) {
            days[key] = next;
            changed = true;
          }
        }
        if (changed) {
          _state = _state.copyWith(days: days);
          _dirty = true;
          await _flushOnce();
        }
        _reportFailures = 0;
        _nextUploadAt = null;
      });
    } on TrafficReportUnauthorizedException {
      final rejected = prepared;
      if (options != null && rejected != null) {
        options.authenticator.invalidate(
          endpoint: options.endpoint,
          installationId: rejected.installationId,
          scopeKey: rejected.scopeKey,
        );
      }
      _scheduleRetry();
    } catch (_) {
      _scheduleRetry();
    } finally {
      _uploading = false;
    }
  }

  void _scheduleRetry() {
    _reportFailures++;
    final interval = _reportOptions?.interval ?? trafficReportInterval;
    _nextUploadAt = _clock().add(_backoff(interval));
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _sampleTimer?.cancel();
    _flushTimer?.cancel();
    _reportTimer?.cancel();
    _sampleTimer = null;
    _flushTimer = null;
    _reportTimer = null;
    unawaited(_enqueue(_flushOnce));
    summary.dispose();
  }

  Future<_PreparedReport?> _prepareUpload(String identityKey) async {
    if (_disposed) return null;
    if (!await _ensureLoaded()) return null;
    if (!await _applyDesiredScope()) return null;
    if (_disposed) return null;
    final now = _clock();
    final nextUploadAt = _nextUploadAt;
    if (nextUploadAt != null && now.isBefore(nextUploadAt)) return null;
    if (!await _flushOnce()) return null;
    final pending = _pendingStreams();
    if (pending.isEmpty) return null;
    if (_reportOptions?.identityKey != identityKey) return null;
    return (
      batch: TrafficReportBatch(
        installationId: _state.installationId,
        sentAt: now.toUtc(),
        streams: pending,
      ),
      installationId: _state.installationId,
      scopeId: _normalizeScopeId(_state.scopeId),
      scopeKey: _state.scopeKey,
      scopeRevision: _scopeRevision,
      identityKey: identityKey,
      now: now,
    );
  }

  bool _scopeStillMatches(_PreparedReport prepared) {
    if (_disposed) return false;
    final options = _reportOptions;
    if (options == null || options.identityKey != prepared.identityKey) {
      return false;
    }
    if (_scopeRevision != prepared.scopeRevision) return false;
    if (_normalizeScopeId(_desiredScopeId) != prepared.scopeId) return false;
    if (_scopeRequested &&
        _normalizeScopeId(_state.scopeId) != prepared.scopeId) {
      return false;
    }
    return _state.scopeKey == prepared.scopeKey;
  }

  Future<bool> _ensureLoaded() async {
    if (_stateLoaded) return true;
    if (_disposed) return false;
    String? raw;
    try {
      raw = await _store.read();
    } catch (_) {
      return false;
    }
    if (_disposed) return false;
    final generatedId = _newInstallationId();
    if (raw == null || raw.isEmpty) {
      _state = _prune(TrafficAccountingState.empty(generatedId));
      _stateLoaded = true;
      _dirty = true;
      _recalculateSummary();
      await _flushOnce();
      return true;
    }
    TrafficAccountingState state;
    try {
      final decoded = json.decode(raw);
      if (decoded is! Map) throw const FormatException('not an object');
      final version = decoded['version'];
      if (version is! num || version.toInt() != 1) {
        throw const FormatException('unsupported state version');
      }
      state = TrafficAccountingState.fromJson(
        Map<String, Object?>.from(decoded),
        fallbackInstallationId: generatedId,
      );
      if (!state.isValid) {
        throw const FormatException('invalid accounting state');
      }
    } catch (_) {
      // Fail closed: a value this build cannot read may belong to a newer
      // schema. Keep it intact rather than replacing it with a new install id
      // and manufacturing duplicate fleet totals.
      return false;
    }
    _state = _prune(state);
    _stateLoaded = true;
    _dirty = true;
    _recalculateSummary();
    await _flushOnce();
    return true;
  }

  Future<bool> _applyDesiredScope() async {
    if (!_scopeRequested || _disposed) return true;
    for (var attempt = 0; attempt < 4 && !_disposed; attempt++) {
      final desired = _normalizeScopeId(_desiredScopeId);
      final revision = _scopeRevision;
      if (desired == _normalizeScopeId(_state.scopeId) &&
          revision == _baselineScopeRevision) {
        return true;
      }
      TrafficSnapshot snapshot;
      try {
        snapshot = await _readSnapshot();
      } catch (_) {
        return false;
      }
      if (_disposed) return false;
      if (!snapshot.isValid) return false;
      if (_scopeRevision != revision ||
          _normalizeScopeId(_desiredScopeId) != desired) {
        continue;
      }
      // The interval between the previous sample and this switch is
      // ambiguous, so it is discarded rather than credited to either scope.
      // The new scope starts from this fresh snapshot immediately.
      _state = _state.copyWith(
        scopeId: desired,
        scopeKey: _scopeKeyFor(desired),
        hasBaseline: true,
        baseline: snapshot.allocation,
        epoch: snapshot.epoch,
      );
      _dirty = true;
      _baselineScopeRevision = revision;
      _recalculateSummary();
      await _flushOnce();
      return true;
    }
    return false;
  }

  Future<void> _sampleOnce() async {
    if (_disposed) return;
    if (!await _ensureLoaded()) return;
    if (_disposed) return;
    if (!await _applyDesiredScope()) return;
    if (_disposed) return;
    final revision = _scopeRevision;
    TrafficSnapshot snapshot;
    try {
      snapshot = await _readSnapshot();
    } catch (_) {
      return;
    }
    if (_disposed || !snapshot.isValid) return;
    if (_scopeRevision != revision) return;
    if (_scopeRequested &&
        _normalizeScopeId(_desiredScopeId) !=
            _normalizeScopeId(_state.scopeId)) {
      // The scope changed while this read was in flight. The interval is
      // ambiguous, so drop it and let the queued switch establish a fresh
      // baseline for the new scope.
      return;
    }
    _applySnapshot(snapshot);
  }

  void _applySnapshot(TrafficSnapshot snapshot) {
    if (!_state.hasBaseline) {
      _applyDelta(snapshot.allocation);
      _state = _state.copyWith(
        hasBaseline: true,
        baseline: snapshot.allocation,
        epoch: snapshot.epoch,
      );
      _dirty = true;
      return;
    }
    if (snapshot.epoch != _state.epoch ||
        _allocationBelow(snapshot.allocation, _state.baseline)) {
      _applyDelta(snapshot.allocation);
      _state = _state.copyWith(
        baseline: snapshot.allocation,
        epoch: snapshot.epoch,
      );
      _dirty = true;
      return;
    }
    _applyDelta(_difference(snapshot.allocation, _state.baseline));
    _state = _state.copyWith(
      baseline: snapshot.allocation,
      epoch: snapshot.epoch,
    );
  }

  void _applyDelta(TrafficAllocation delta) {
    if (delta == TrafficAllocation.zero) {
      _recalculateSummary();
      return;
    }
    final day = utcDayKey(_clock());
    final key = '$day|${_state.scopeKey}';
    final record =
        _state.days[key] ??
        TrafficDayRecord(
          day: day,
          scopeKey: _state.scopeKey,
          allocation: TrafficAllocation.zero,
        );
    final days = Map.of(_state.days);
    days[key] = record.accumulate(delta);
    _state = _prune(_state.copyWith(days: days));
    _dirty = true;
    _recalculateSummary();
  }

  Future<bool> _flushOnce() async {
    if (!_dirty) return true;
    final value = json.encode(_state.toJson());
    try {
      await _store.write(value);
      _dirty = false;
      return true;
    } catch (_) {
      return false;
    }
  }

  List<TrafficReportStream> _pendingStreams() {
    final records =
        _state.days.values
            .where(
              (record) => record.scopeKey == _state.scopeKey && record.pending,
            )
            .toList()
          ..sort((a, b) => a.day.compareTo(b.day));
    return [
      for (final record in records.take(_maxReportStreams))
        TrafficReportStream(
          streamId: trafficStreamId(
            _state.installationId,
            record.day,
            record.scopeKey,
          ),
          day: record.day,
          scopeKey: record.scopeKey,
          revision: record.revision,
          allocation: record.allocation,
        ),
    ];
  }

  void _recalculateSummary() {
    if (_disposed) return;
    final now = _clock().toUtc();
    final today = utcDayKey(now);
    var todayTotals = TrafficAllocation.zero;
    var monthTotals = TrafficAllocation.zero;
    for (final record in _state.days.values) {
      if (record.day == today) {
        todayTotals += record.allocation;
      }
      final parsed = DateTime.tryParse('${record.day}T00:00:00Z');
      if (parsed != null &&
          parsed.year == now.year &&
          parsed.month == now.month) {
        monthTotals += record.allocation;
      }
    }
    summary.value = TrafficSummary(today: todayTotals, month: monthTotals);
  }

  TrafficAccountingState _prune(TrafficAccountingState state) {
    final today = DateTime.tryParse('${utcDayKey(_clock())}T00:00:00Z');
    if (today == null) return state;
    final oldest = today.subtract(Duration(days: retentionDays - 1));
    final kept = <String, TrafficDayRecord>{};
    for (final entry in state.days.entries) {
      final record = entry.value;
      if (!record.allocation.isValid) continue;
      final day = DateTime.tryParse('${record.day}T00:00:00Z');
      if (day == null) continue;
      if (day.isAfter(today)) continue;
      if (day.isBefore(oldest)) continue;
      kept[entry.key] = record;
    }
    if (kept.length > _maxRetainedRecords) {
      final sorted = kept.entries.toList()
        ..sort((a, b) => b.value.day.compareTo(a.value.day));
      return state.copyWith(
        days: {
          for (final entry in sorted.take(_maxRetainedRecords))
            entry.key: entry.value,
        },
      );
    }
    return state.copyWith(days: kept);
  }

  String _scopeKeyFor(String? scopeId) {
    final normalized = _normalizeScopeId(scopeId);
    if (normalized.isEmpty) return 'none';
    final digest = sha256.convert(
      utf8.encode('${_state.installationId}|scope|$normalized'),
    );
    return digest.toString().substring(0, 24);
  }

  Duration _backoff(Duration interval) {
    final exponent = _reportFailures.clamp(1, 4).toInt();
    final seconds = interval.inSeconds * (1 << exponent);
    return Duration(seconds: seconds.clamp(interval.inSeconds, 3600).toInt());
  }

  Future<T> _enqueue<T>(Future<T> Function() work) {
    final result = _serial.then((_) => work());
    _serial = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  static String _normalizeScopeId(String? scopeId) => scopeId ?? '';

  static String _newInstallationId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}

bool _allocationBelow(TrafficAllocation current, TrafficAllocation baseline) {
  return current.mainlandDirect.up < baseline.mainlandDirect.up ||
      current.mainlandDirect.down < baseline.mainlandDirect.down ||
      current.proxy.up < baseline.proxy.up ||
      current.proxy.down < baseline.proxy.down ||
      current.otherDirect.up < baseline.otherDirect.up ||
      current.otherDirect.down < baseline.otherDirect.down;
}

TrafficAllocation _difference(
  TrafficAllocation current,
  TrafficAllocation baseline,
) {
  TrafficBytes difference(TrafficBytes a, TrafficBytes b) =>
      TrafficBytes(up: max(0, a.up - b.up), down: max(0, a.down - b.down));
  return TrafficAllocation(
    mainlandDirect: difference(current.mainlandDirect, baseline.mainlandDirect),
    proxy: difference(current.proxy, baseline.proxy),
    otherDirect: difference(current.otherDirect, baseline.otherDirect),
  );
}
