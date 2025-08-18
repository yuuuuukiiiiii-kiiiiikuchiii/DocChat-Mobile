// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_screen_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatScreenHash() => r'4c0ac2db637c39fb9c290f5fea31d71a7cba2eb8';

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

abstract class _$ChatScreen
    extends BuildlessAutoDisposeAsyncNotifier<List<Message>> {
  late final int sessionId;

  FutureOr<List<Message>> build(int sessionId);
}

/// See also [ChatScreen].
@ProviderFor(ChatScreen)
const chatScreenProvider = ChatScreenFamily();

/// See also [ChatScreen].
class ChatScreenFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [ChatScreen].
  const ChatScreenFamily();

  /// See also [ChatScreen].
  ChatScreenProvider call(int sessionId) {
    return ChatScreenProvider(sessionId);
  }

  @override
  ChatScreenProvider getProviderOverride(
    covariant ChatScreenProvider provider,
  ) {
    return call(provider.sessionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatScreenProvider';
}

/// See also [ChatScreen].
class ChatScreenProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ChatScreen, List<Message>> {
  /// See also [ChatScreen].
  ChatScreenProvider(int sessionId)
    : this._internal(
        () => ChatScreen()..sessionId = sessionId,
        from: chatScreenProvider,
        name: r'chatScreenProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$chatScreenHash,
        dependencies: ChatScreenFamily._dependencies,
        allTransitiveDependencies: ChatScreenFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  ChatScreenProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final int sessionId;

  @override
  FutureOr<List<Message>> runNotifierBuild(covariant ChatScreen notifier) {
    return notifier.build(sessionId);
  }

  @override
  Override overrideWith(ChatScreen Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatScreenProvider._internal(
        () => create()..sessionId = sessionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChatScreen, List<Message>>
  createElement() {
    return _ChatScreenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatScreenProvider && other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatScreenRef on AutoDisposeAsyncNotifierProviderRef<List<Message>> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _ChatScreenProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatScreen, List<Message>>
    with ChatScreenRef {
  _ChatScreenProviderElement(super.provider);

  @override
  int get sessionId => (origin as ChatScreenProvider).sessionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
