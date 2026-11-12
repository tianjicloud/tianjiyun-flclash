// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../tianji_nodes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tianjiApiEnabled)
final tianjiApiEnabledProvider = TianjiApiEnabledProvider._();

final class TianjiApiEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  TianjiApiEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tianjiApiEnabledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tianjiApiEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return tianjiApiEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$tianjiApiEnabledHash() => r'4a6190ef25543b796f2947599b796ed697c8d7d0';

@ProviderFor(TianjiNodeCatalog)
final tianjiNodeCatalogProvider = TianjiNodeCatalogProvider._();

final class TianjiNodeCatalogProvider
    extends $AsyncNotifierProvider<TianjiNodeCatalog, TianjiNodes?> {
  TianjiNodeCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tianjiNodeCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tianjiNodeCatalogHash();

  @$internal
  @override
  TianjiNodeCatalog create() => TianjiNodeCatalog();
}

String _$tianjiNodeCatalogHash() => r'1e2658e97e611047d97e30c62579c8cdb0539a32';

abstract class _$TianjiNodeCatalog extends $AsyncNotifier<TianjiNodes?> {
  FutureOr<TianjiNodes?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TianjiNodes?>, TianjiNodes?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TianjiNodes?>, TianjiNodes?>,
              AsyncValue<TianjiNodes?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(tianjiNode)
final tianjiNodeProvider = TianjiNodeFamily._();

final class TianjiNodeProvider
    extends $FunctionalProvider<TianjiNode?, TianjiNode?, TianjiNode?>
    with $Provider<TianjiNode?> {
  TianjiNodeProvider._({
    required TianjiNodeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tianjiNodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tianjiNodeHash();

  @override
  String toString() {
    return r'tianjiNodeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<TianjiNode?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TianjiNode? create(Ref ref) {
    final argument = this.argument as String;
    return tianjiNode(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TianjiNode? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TianjiNode?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TianjiNodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tianjiNodeHash() => r'4c7793891f135fd84725aa3bc8a5be5b81c10f0b';

final class TianjiNodeFamily extends $Family
    with $FunctionalFamilyOverride<TianjiNode?, String> {
  TianjiNodeFamily._()
    : super(
        retry: null,
        name: r'tianjiNodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TianjiNodeProvider call(String name) =>
      TianjiNodeProvider._(argument: name, from: this);

  @override
  String toString() => r'tianjiNodeProvider';
}

@ProviderFor(tianjiCategories)
final tianjiCategoriesProvider = TianjiCategoriesProvider._();

final class TianjiCategoriesProvider
    extends
        $FunctionalProvider<
          Map<String, String>,
          Map<String, String>,
          Map<String, String>
        >
    with $Provider<Map<String, String>> {
  TianjiCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tianjiCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tianjiCategoriesHash();

  @$internal
  @override
  $ProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, String> create(Ref ref) {
    return tianjiCategories(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$tianjiCategoriesHash() => r'f38ba2453235b84c589c82676fc1b8a960aa4a3a';
