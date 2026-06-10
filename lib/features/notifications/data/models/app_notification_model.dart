import '../../domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.body,
    required super.createdAt,
    super.payload,
    super.read,
  });

  factory AppNotificationModel.fromEntity(AppNotification n) =>
      AppNotificationModel(
        id: n.id,
        type: n.type,
        title: n.title,
        body: n.body,
        payload: n.payload,
        createdAt: n.createdAt,
        read: n.read,
      );

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) =>
      AppNotificationModel(
        id: json['id'] as String,
        type: NotificationType.fromString(json['type'] as String? ?? ''),
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        payload: json['payload'] != null
            ? Map<String, dynamic>.from(json['payload'] as Map)
            : const {},
        createdAt: DateTime.tryParse(json['createdAt'].toString()) ??
            DateTime.fromMillisecondsSinceEpoch(0),
        read: json['read'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.wire,
        'title': title,
        'body': body,
        'payload': payload,
        'createdAt': createdAt.toIso8601String(),
        'read': read,
      };
}
