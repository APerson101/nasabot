// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nasa_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getHistoryHash() => r'7217d4bf6ff280d57a26c2da924ca184d092d730';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getHistory].
@ProviderFor(getHistory)
const getHistoryProvider = GetHistoryFamily();

/// See also [getHistory].
class GetHistoryFamily extends Family<AsyncValue<dynamic>> {
  /// See also [getHistory].
  const GetHistoryFamily();

  /// See also [getHistory].
  GetHistoryProvider call(
    String id,
  ) {
    return GetHistoryProvider(
      id,
    );
  }

  @override
  GetHistoryProvider getProviderOverride(
    covariant GetHistoryProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getHistoryProvider';
}

/// See also [getHistory].
class GetHistoryProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [getHistory].
  GetHistoryProvider(
    String id,
  ) : this._internal(
          (ref) => getHistory(
            ref as GetHistoryRef,
            id,
          ),
          from: getHistoryProvider,
          name: r'getHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getHistoryHash,
          dependencies: GetHistoryFamily._dependencies,
          allTransitiveDependencies:
              GetHistoryFamily._allTransitiveDependencies,
          id: id,
        );

  GetHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<dynamic> Function(GetHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetHistoryProvider._internal(
        (ref) => create(ref as GetHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<dynamic> createElement() {
    return _GetHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetHistoryProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetHistoryRef on AutoDisposeFutureProviderRef<dynamic> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GetHistoryProviderElement
    extends AutoDisposeFutureProviderElement<dynamic> with GetHistoryRef {
  _GetHistoryProviderElement(super.provider);

  @override
  String get id => (origin as GetHistoryProvider).id;
}

String _$askQuestionHash() => r'13e4ef1af09b1ddcb9a5733cc2daf938559ca564';

/// See also [askQuestion].
@ProviderFor(askQuestion)
const askQuestionProvider = AskQuestionFamily();

/// See also [askQuestion].
class AskQuestionFamily extends Family<AsyncValue<dynamic>> {
  /// See also [askQuestion].
  const AskQuestionFamily();

  /// See also [askQuestion].
  AskQuestionProvider call(
    String id,
    String question,
  ) {
    return AskQuestionProvider(
      id,
      question,
    );
  }

  @override
  AskQuestionProvider getProviderOverride(
    covariant AskQuestionProvider provider,
  ) {
    return call(
      provider.id,
      provider.question,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'askQuestionProvider';
}

/// See also [askQuestion].
class AskQuestionProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [askQuestion].
  AskQuestionProvider(
    String id,
    String question,
  ) : this._internal(
          (ref) => askQuestion(
            ref as AskQuestionRef,
            id,
            question,
          ),
          from: askQuestionProvider,
          name: r'askQuestionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$askQuestionHash,
          dependencies: AskQuestionFamily._dependencies,
          allTransitiveDependencies:
              AskQuestionFamily._allTransitiveDependencies,
          id: id,
          question: question,
        );

  AskQuestionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.question,
  }) : super.internal();

  final String id;
  final String question;

  @override
  Override overrideWith(
    FutureOr<dynamic> Function(AskQuestionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AskQuestionProvider._internal(
        (ref) => create(ref as AskQuestionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        question: question,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<dynamic> createElement() {
    return _AskQuestionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AskQuestionProvider &&
        other.id == id &&
        other.question == question;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, question.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AskQuestionRef on AutoDisposeFutureProviderRef<dynamic> {
  /// The parameter `id` of this provider.
  String get id;

  /// The parameter `question` of this provider.
  String get question;
}

class _AskQuestionProviderElement
    extends AutoDisposeFutureProviderElement<dynamic> with AskQuestionRef {
  _AskQuestionProviderElement(super.provider);

  @override
  String get id => (origin as AskQuestionProvider).id;
  @override
  String get question => (origin as AskQuestionProvider).question;
}

String _$questionHistoryHash() => r'ac44cd12849766dc2fd93dc47513ff26b2a44a61';

/// See also [QuestionHistory].
@ProviderFor(QuestionHistory)
final questionHistoryProvider =
    AutoDisposeAsyncNotifierProvider<QuestionHistory, List<dynamic>>.internal(
  QuestionHistory.new,
  name: r'questionHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$questionHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuestionHistory = AutoDisposeAsyncNotifier<List<dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
