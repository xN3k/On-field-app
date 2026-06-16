import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../di/core_providers.dart';

part 'theme_mode_provider.g.dart';

/// Persisted app theme preference (System / Light / Dark), stored as a string
/// in the `sync_meta_box`. Mirrors the `NotificationsEnabled` pattern.
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    final stored = ref.watch(syncMetaBoxProvider).get(_key);
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  void set(ThemeMode mode) {
    ref.read(syncMetaBoxProvider).put(_key, mode.name);
    state = mode;
  }
}
