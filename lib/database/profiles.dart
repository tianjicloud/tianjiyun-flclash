part of 'database.dart';

@DataClassName('RawProfile')
class Profiles extends Table {
  @override
  String get tableName => 'profiles';

  IntColumn get id => integer()();

  TextColumn get type => textEnum<ProfileType>()();

  TextColumn get label => text()();

  TextColumn get currentGroupName => text().nullable()();

  TextColumn get url => text()();

  TextColumn get ageSecretKey => text().nullable()();

  DateTimeColumn get lastUpdateDate => dateTime().nullable()();

  TextColumn get extendType => textEnum<ExtendType>()();

  IntColumn get scriptId => integer().nullable()();

  TextColumn get matchTarget => text().nullable()();

  IntColumn get autoUpdateDurationMillis => integer()();

  TextColumn get subscriptionInfo =>
      text().map(const SubscriptionInfoConverter()).nullable()();

  BoolColumn get autoUpdate => boolean()();

  TextColumn get selectedMap => text().map(const StringMapConverter())();

  TextColumn get unfoldSet => text().map(const StringSetConverter())();

  IntColumn get order => integer().nullable()();

  TextColumn get overrides =>
      text().map(const ProfileOverridesConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProfileOverridesConverter
    extends TypeConverter<ProfileOverrides?, String?> {
  const ProfileOverridesConverter();

  @override
  ProfileOverrides? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    return decodeOrRestoreDefault(
      'profile overrides',
      () => ProfileOverrides.safeFromJson(json.decode(fromDb)),
      () => null,
    );
  }

  @override
  String? toSql(ProfileOverrides? value) {
    if (value == null || value == const ProfileOverrides()) return null;
    return json.encode(value.toJson());
  }
}

class SubscriptionInfoConverter
    extends TypeConverter<SubscriptionInfo?, String?> {
  const SubscriptionInfoConverter();

  @override
  SubscriptionInfo? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    return decodeOrRestoreDefault(
      'subscription info',
      () => SubscriptionInfo.fromJson(json.decode(fromDb)),
      () => null,
    );
  }

  @override
  String? toSql(SubscriptionInfo? value) {
    if (value == null) return null;
    return json.encode(value.toJson());
  }
}

@DriftAccessor(tables: [Profiles])
class ProfilesDao extends DatabaseAccessor<Database> with _$ProfilesDaoMixin {
  ProfilesDao(super.attachedDatabase);

  final _unreadableRows = StreamController<int>.broadcast(sync: true);
  var _unreadableRowCount = 0;

  Stream<int> watchUnreadableRows() async* {
    yield _unreadableRowCount;
    yield* _unreadableRows.stream;
  }

  void _setUnreadableRowCount(int count) {
    if (count == _unreadableRowCount) return;
    _unreadableRowCount = count;
    _unreadableRows.add(count);
  }

  Selectable<Profile> query() {
    return profiles.readableRaw(
      _readProfile,
      orderBy: [
        (t) => OrderingTerm(expression: t.order, nulls: NullsOrder.last),
        (t) => OrderingTerm.asc(t.id),
      ],
      onSkippedRows: _setUnreadableRowCount,
    );
  }

  Profile? _readProfile(Map<String, Object?> row) {
    Object? raw(String column) {
      final prefixed = '${profiles.aliasedName}.$column';
      return row.containsKey(prefixed) ? row[prefixed] : row[column];
    }

    T? field<T extends Object>(
      String name,
      T? Function(Object? value) decode, {
      T? fallback,
    }) {
      try {
        return decode(raw(name)) ?? fallback;
      } catch (error) {
        commonPrint.log(
          'Unreadable profiles.$name; using its fallback: '
          '${compactError(error)}',
          logLevel: LogLevel.warning,
        );
        return fallback;
      }
    }

    final id = field<int>(
      'id',
      (value) => attachedDatabase.typeMapping.read(DriftSqlType.int, value),
    );
    final type = field<ProfileType>('type', (value) {
      final name = attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        value,
      );
      return name == null ? null : ProfileType.values.byName(name);
    });
    final label = field<String>(
      'label',
      (value) => attachedDatabase.typeMapping.read(DriftSqlType.string, value),
    );
    final url = field<String>(
      'url',
      (value) => attachedDatabase.typeMapping.read(DriftSqlType.string, value),
    );
    if (id == null || type == null || label == null || url == null) {
      commonPrint.log(
        'Skipped unreadable profiles row: required identity field missing',
        logLevel: LogLevel.warning,
      );
      return null;
    }

    final extendType = field<ExtendType>('extend_type', (value) {
      final name = attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        value,
      );
      return name == null ? null : ExtendType.values.byName(name);
    }, fallback: ExtendType.standard);
    final autoUpdateDurationMillis = field<int>(
      'auto_update_duration_millis',
      (value) => attachedDatabase.typeMapping.read(DriftSqlType.int, value),
      fallback: defaultUpdateDuration.inMilliseconds,
    );
    final autoUpdate = field<bool>(
      'auto_update',
      (value) => attachedDatabase.typeMapping.read(DriftSqlType.bool, value),
      fallback: true,
    );
    final selectedMap = field<Map<String, String>>(
      'selected_map',
      (value) => const StringMapConverter().fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, value)!,
      ),
      fallback: const {},
    );
    final unfoldSet = field<Set<String>>(
      'unfold_set',
      (value) => const StringSetConverter().fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, value)!,
      ),
      fallback: const {},
    );
    final currentGroupName = field<String>(
      'current_group_name',
      (value) => attachedDatabase.typeMapping.read(DriftSqlType.string, value),
    );
    final ageSecretKey = field<String>(
      'age_secret_key',
      (value) => attachedDatabase.typeMapping.read(DriftSqlType.string, value),
    );
    final lastUpdateDate = field<DateTime>(
      'last_update_date',
      (value) =>
          attachedDatabase.typeMapping.read(DriftSqlType.dateTime, value),
    );
    final scriptId = field<int>(
      'script_id',
      (value) => attachedDatabase.typeMapping.read(DriftSqlType.int, value),
    );
    final matchTarget = field<String>(
      'match_target',
      (value) => attachedDatabase.typeMapping.read(DriftSqlType.string, value),
    );
    final order = field<int>(
      'order',
      (value) => attachedDatabase.typeMapping.read(DriftSqlType.int, value),
    );
    final subscriptionInfo = field<SubscriptionInfo>(
      'subscription_info',
      (value) => const SubscriptionInfoConverter().fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, value),
      ),
    );
    final overrides = field<ProfileOverrides>(
      'overrides',
      (value) => const ProfileOverridesConverter().fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, value),
      ),
      fallback: const ProfileOverrides(),
    );

    return Profile(
      id: id,
      type: type,
      label: label,
      currentGroupName: currentGroupName,
      url: url,
      ageSecretKey: ageSecretKey ?? '',
      lastUpdateDate: lastUpdateDate,
      autoUpdateDuration: Duration(milliseconds: autoUpdateDurationMillis!),
      subscriptionInfo: subscriptionInfo,
      autoUpdate: autoUpdate!,
      selectedMap: selectedMap!,
      unfoldSet: unfoldSet!,
      extendType: extendType!,
      scriptId: scriptId,
      matchTarget: matchTarget,
      order: order,
      overrides: overrides ?? const ProfileOverrides(),
    );
  }

  /// The order [query] reads profiles back in.
  static int compare(Profile a, Profile b) => switch ((a.order, b.order)) {
    (final x?, final y?) when x != y => x.compareTo(y),
    (null, _?) => 1,
    (_?, null) => -1,
    _ => a.id.compareTo(b.id),
  };

  Future<void> setAll(Iterable<Profile> profiles) async {
    await batch((b) async {
      setAllWithBatch(b, profiles);
    });
  }

  Future<void> putAll<T extends Table, D extends DataClass>(
    Iterable<Insertable<D>> items,
  ) async {
    await batch((b) async {
      putAllWithBatch(b, items);
    });
  }

  void putAllWithBatch<T extends Table, D extends DataClass>(
    Batch batch,
    Iterable<Insertable<D>> items,
  ) {
    batch.insertAllOnConflictUpdate(profiles, items);
  }

  Selectable<int> ids() {
    final query = profiles.selectOnly()..addColumns([profiles.id]);
    return query.map((row) => row.read(profiles.id)!);
  }

  Selectable<int> customIds() {
    final query = profiles.selectOnly()
      ..addColumns([profiles.id])
      ..where(profiles.type.equalsValue(ProfileType.custom));
    return query.map((row) => row.read(profiles.id)!);
  }

  Future<Profile?> get(int id) => profiles
      .readableRaw(_readProfile, where: (t) => t.id.equals(id))
      .getSingleOrNull();

  Selectable<String> fileNames() => ids().map((id) => '$id.yaml');

  void setAllWithBatch(Batch batch, Iterable<Profile> profiles) {
    final List<ProfilesCompanion> items = [];
    final List<int> ids = [];
    profiles.forEachIndexed((index, profile) {
      ids.add(profile.id);
      items.add(profile.toCompanion(index));
    });

    this.profiles.setAll(batch, items, deleteFilter: (t) => t.id.isNotIn(ids));
  }
}

extension RawProfilExt on RawProfile {
  Profile toProfile() {
    return Profile(
      id: id,
      type: type,
      label: label,
      currentGroupName: currentGroupName,
      url: url,
      ageSecretKey: ageSecretKey ?? '',
      lastUpdateDate: lastUpdateDate,
      autoUpdateDuration: Duration(milliseconds: autoUpdateDurationMillis),
      subscriptionInfo: subscriptionInfo,
      autoUpdate: autoUpdate,
      selectedMap: selectedMap,
      unfoldSet: unfoldSet,
      extendType: extendType,
      scriptId: scriptId,
      matchTarget: matchTarget,
      order: order,
      overrides: overrides ?? const ProfileOverrides(),
    );
  }
}

extension ProfilesCompanionExt on Profile {
  ProfilesCompanion toCompanion([int? order]) {
    return ProfilesCompanion.insert(
      id: Value(id),
      type: type,
      label: label,
      currentGroupName: Value(currentGroupName),
      url: url,
      ageSecretKey: Value(ageSecretKey.isEmpty ? null : ageSecretKey),
      lastUpdateDate: Value(lastUpdateDate),
      autoUpdateDurationMillis: autoUpdateDuration.inMilliseconds,
      subscriptionInfo: Value(subscriptionInfo),
      autoUpdate: autoUpdate,
      selectedMap: selectedMap,
      unfoldSet: unfoldSet,
      extendType: extendType,
      scriptId: Value(scriptId),
      matchTarget: Value(matchTarget),
      order: Value(order ?? this.order),
      overrides: Value(overrides),
    );
  }
}
