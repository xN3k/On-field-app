import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/sync/sync_coordinator.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/presentation/providers/notification_providers.dart';

class OnFieldApp extends ConsumerWidget {
  const OnFieldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Start the offline-sync coordinator and the socket-event notification
    // recorder for the app's lifetime.
    ref.watch(syncCoordinatorProvider);
    ref.watch(notificationCenterProvider);

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
