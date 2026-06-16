// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the session and drives router redirects. Kept alive for the app's
/// lifetime so the socket connection and session survive navigation.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Holds the session and drives router redirects. Kept alive for the app's
/// lifetime so the socket connection and session survive navigation.
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, AuthState> {
  /// Holds the session and drives router redirects. Kept alive for the app's
  /// lifetime so the socket connection and session survive navigation.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'4cf9c307c317c60b4e364f124b0b58a0ed133cb8';

/// Holds the session and drives router redirects. Kept alive for the app's
/// lifetime so the socket connection and session survive navigation.

abstract class _$AuthController extends $AsyncNotifier<AuthState> {
  FutureOr<AuthState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthState>, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthState>, AuthState>,
              AsyncValue<AuthState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
