// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Create / edit / delete controller for manager task writes (online-only).

@ProviderFor(TaskForm)
final taskFormProvider = TaskFormProvider._();

/// Create / edit / delete controller for manager task writes (online-only).
final class TaskFormProvider
    extends $NotifierProvider<TaskForm, AsyncValue<Task?>> {
  /// Create / edit / delete controller for manager task writes (online-only).
  TaskFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFormHash();

  @$internal
  @override
  TaskForm create() => TaskForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Task?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Task?>>(value),
    );
  }
}

String _$taskFormHash() => r'1b92fed12540ed553a22d87ad791434a0d63fa7f';

/// Create / edit / delete controller for manager task writes (online-only).

abstract class _$TaskForm extends $Notifier<AsyncValue<Task?>> {
  AsyncValue<Task?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Task?>, AsyncValue<Task?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Task?>, AsyncValue<Task?>>,
              AsyncValue<Task?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Reassignment controller.

@ProviderFor(TaskAssign)
final taskAssignProvider = TaskAssignProvider._();

/// Reassignment controller.
final class TaskAssignProvider
    extends $NotifierProvider<TaskAssign, AsyncValue<void>> {
  /// Reassignment controller.
  TaskAssignProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskAssignProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskAssignHash();

  @$internal
  @override
  TaskAssign create() => TaskAssign();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$taskAssignHash() => r'4c6d303b86f5a9eed78766420c28bc1c9048e63a';

/// Reassignment controller.

abstract class _$TaskAssign extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
