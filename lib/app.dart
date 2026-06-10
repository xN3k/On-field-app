import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/sync/sync_coordinator.dart';
import 'core/theme/app_theme.dart';

class OnFieldApp extends ConsumerWidget {
  const OnFieldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Start the offline-sync coordinator for the app's lifetime.
    ref.watch(syncCoordinatorProvider);

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'OnField',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
