import 'package:flutter_test/flutter_test.dart';
import 'package:onfield/features/notifications/data/models/app_notification_model.dart';
import 'package:onfield/features/notifications/domain/entities/app_notification.dart';

void main() {
  test('AppNotificationModel JSON round-trip preserves all fields', () {
    final original = AppNotificationModel(
      id: 'n1',
      type: NotificationType.geofenceExit,
      title: 'Geofence exited',
      body: 'A worker exited a task geofence.',
      payload: const {'taskId': 't1', 'userId': 'u1', 'type': 'EXIT'},
      createdAt: DateTime.parse('2026-06-10T12:30:00.000'),
      read: true,
    );

    final restored = AppNotificationModel.fromJson(original.toJson());

    expect(restored.id, 'n1');
    expect(restored.type, NotificationType.geofenceExit);
    expect(restored.title, original.title);
    expect(restored.body, original.body);
    expect(restored.payload['taskId'], 't1');
    expect(restored.taskId, 't1');
    expect(restored.userId, 'u1');
    expect(restored.createdAt, original.createdAt);
    expect(restored.read, true);
  });

  test('NotificationType wire mapping is UPPER_SNAKE both ways', () {
    for (final type in NotificationType.values) {
      expect(NotificationType.fromString(type.wire), type);
    }
    expect(NotificationType.fromString('unknown'),
        NotificationType.taskStatus);
  });

  test('copyWith(read:) only changes the read flag', () {
    final n = AppNotificationModel(
      id: 'n2',
      type: NotificationType.taskStatus,
      title: 't',
      body: 'b',
      createdAt: DateTime.parse('2026-06-10T08:00:00.000'),
    );
    final read = n.copyWith(read: true);
    expect(read.read, true);
    expect(read.id, n.id);
    expect(read.createdAt, n.createdAt);
  });
}
