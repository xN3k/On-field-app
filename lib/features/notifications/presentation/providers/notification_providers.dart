import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/core_providers.dart';
import '../../../tasks/presentation/providers/task_list_provider.dart';
import '../../data/datasources/notification_local_datasource.dart';
import '../../data/models/app_notification_model.dart';
import '../../domain/entities/app_notification.dart';

part 'notification_providers.g.dart';

@Riverpod(keepAlive: true)
NotificationLocalDataSource notificationLocalDataSource(Ref ref) =>
    NotificationLocalDataSource(ref.watch(notificationsBoxProvider));

/// Hive-backed preference: whether to record incoming notifications.
@Riverpod(keepAlive: true)
class NotificationsEnabled extends _$NotificationsEnabled {
  static const _key = 'notifications_enabled';

  @override
  bool build() => ref.watch(syncMetaBoxProvider).get(_key) != 'false';

  void toggle(bool enabled) {
    ref.read(syncMetaBoxProvider).put(_key, '$enabled');
    state = enabled;
  }
}

/// Single owner of the `task:status` and `geofence:event` socket handlers.
/// SocketService keeps ONE handler per event name, so no other provider may
/// register these events. Started at bootstrap (read once in OnFieldApp).
@Riverpod(keepAlive: true)
class NotificationCenter extends _$NotificationCenter {
  static const _uuid = Uuid();

  @override
  void build() {
    final socket = ref.watch(socketServiceProvider);
    final local = ref.watch(notificationLocalDataSourceProvider);

    socket.on('task:status', (data) {
      final map = Map<String, dynamic>.from(data as Map);
      _record(
        local,
        type: NotificationType.taskStatus,
        title: 'Task status updated',
        body: 'A task moved to ${map['status'] ?? 'a new status'}.',
        payload: map,
      );
      // Keep the cached task list in step with the server.
      ref.invalidate(taskListProvider);
    });

    socket.on('geofence:event', (data) {
      final map = Map<String, dynamic>.from(data as Map);
      final entered = (map['type'] as String?)?.toUpperCase() == 'ENTER';
      _record(
        local,
        type: entered
            ? NotificationType.geofenceEnter
            : NotificationType.geofenceExit,
        title: entered ? 'Geofence entered' : 'Geofence exited',
        body: entered
            ? 'A worker entered a task geofence.'
            : 'A worker exited a task geofence.',
        payload: map,
      );
    });

    ref.onDispose(() {
      socket.off('task:status');
      socket.off('geofence:event');
    });
  }

  void _record(
    NotificationLocalDataSource local, {
    required NotificationType type,
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) {
    // Read lazily so auth/pref changes don't tear down the socket handlers.
    if (!ref.read(notificationsEnabledProvider)) return;
    local.add(
      AppNotificationModel(
        id: _uuid.v4(),
        type: type,
        title: title,
        body: body,
        payload: payload,
        createdAt: DateTime.now(),
      ),
    );
  }
}

@riverpod
Stream<List<AppNotification>> notifications(Ref ref) => ref
    .watch(notificationLocalDataSourceProvider)
    .watch()
    .map((list) => list.cast<AppNotification>());

@riverpod
int unreadNotificationCount(Ref ref) {
  final items = ref.watch(notificationsProvider).value ?? const [];
  return items.where((n) => !n.read).length;
}
