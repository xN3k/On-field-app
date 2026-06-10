enum NotificationType {
  geofenceEnter,
  geofenceExit,
  taskStatus;

  static NotificationType fromString(String value) =>
      switch (value.toUpperCase()) {
        'GEOFENCE_ENTER' => NotificationType.geofenceEnter,
        'GEOFENCE_EXIT' => NotificationType.geofenceExit,
        _ => NotificationType.taskStatus,
      };

  String get wire => switch (this) {
        NotificationType.geofenceEnter => 'GEOFENCE_ENTER',
        NotificationType.geofenceExit => 'GEOFENCE_EXIT',
        NotificationType.taskStatus => 'TASK_STATUS',
      };
}

/// Locally persisted notification built from realtime socket events.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.payload = const {},
    this.read = false,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final bool read;

  String? get taskId => payload['taskId'] as String?;
  String? get userId => payload['userId'] as String?;

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        type: type,
        title: title,
        body: body,
        payload: payload,
        createdAt: createdAt,
        read: read ?? this.read,
      );
}
