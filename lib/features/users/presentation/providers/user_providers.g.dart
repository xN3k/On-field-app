// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userRemoteDataSource)
final userRemoteDataSourceProvider = UserRemoteDataSourceProvider._();

final class UserRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          UserRemoteDataSource,
          UserRemoteDataSource,
          UserRemoteDataSource
        >
    with $Provider<UserRemoteDataSource> {
  UserRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<UserRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserRemoteDataSource create(Ref ref) {
    return userRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRemoteDataSource>(value),
    );
  }
}

String _$userRemoteDataSourceHash() =>
    r'8e4e702304743f04f92bf7060fc04eea9b78b8ff';

/// Full user directory (manager/admin only on the backend).

@ProviderFor(UserList)
final userListProvider = UserListProvider._();

/// Full user directory (manager/admin only on the backend).
final class UserListProvider
    extends $AsyncNotifierProvider<UserList, List<User>> {
  /// Full user directory (manager/admin only on the backend).
  UserListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userListHash();

  @$internal
  @override
  UserList create() => UserList();
}

String _$userListHash() => r'fd4c854a5d89ad62f04a1caf4cead90e1adf2131';

/// Full user directory (manager/admin only on the backend).

abstract class _$UserList extends $AsyncNotifier<List<User>> {
  FutureOr<List<User>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<User>>, List<User>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<User>>, List<User>>,
              AsyncValue<List<User>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(userDetail)
final userDetailProvider = UserDetailFamily._();

final class UserDetailProvider
    extends $FunctionalProvider<AsyncValue<User>, User, FutureOr<User>>
    with $FutureModifier<User>, $FutureProvider<User> {
  UserDetailProvider._({
    required UserDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userDetailHash();

  @override
  String toString() {
    return r'userDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<User> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<User> create(Ref ref) {
    final argument = this.argument as String;
    return userDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userDetailHash() => r'e52e5a8b7b615974a6ca81c02461ef6b4abe07f9';

final class UserDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<User>, String> {
  UserDetailFamily._()
    : super(
        retry: null,
        name: r'userDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserDetailProvider call(String userId) =>
      UserDetailProvider._(argument: userId, from: this);

  @override
  String toString() => r'userDetailProvider';
}

/// Workers available for assignment pickers.

@ProviderFor(workerOptions)
final workerOptionsProvider = WorkerOptionsProvider._();

/// Workers available for assignment pickers.

final class WorkerOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<User>>,
          List<User>,
          FutureOr<List<User>>
        >
    with $FutureModifier<List<User>>, $FutureProvider<List<User>> {
  /// Workers available for assignment pickers.
  WorkerOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workerOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workerOptionsHash();

  @$internal
  @override
  $FutureProviderElement<List<User>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<User>> create(Ref ref) {
    return workerOptions(ref);
  }
}

String _$workerOptionsHash() => r'786b01207e05a65e0901f2b18c06352620948c25';

/// Quick userId → display name lookup for cards and map pins.

@ProviderFor(userDirectory)
final userDirectoryProvider = UserDirectoryProvider._();

/// Quick userId → display name lookup for cards and map pins.

final class UserDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, User>>,
          Map<String, User>,
          FutureOr<Map<String, User>>
        >
    with
        $FutureModifier<Map<String, User>>,
        $FutureProvider<Map<String, User>> {
  /// Quick userId → display name lookup for cards and map pins.
  UserDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, User>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, User>> create(Ref ref) {
    return userDirectory(ref);
  }
}

String _$userDirectoryHash() => r'05280785fc26624ca6b549d6e9b90e2d0b8c101d';
