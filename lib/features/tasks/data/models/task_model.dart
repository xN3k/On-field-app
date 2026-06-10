import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.status,
    required super.assignedToId,
    super.description,
    super.geofenceLat,
    super.geofenceLng,
    super.geofenceRadius,
    super.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        status: TaskStatus.fromString(json['status'] as String? ?? 'PENDING'),
        assignedToId: json['assignedToId'] as String,
        geofenceLat: (json['geofenceLat'] as num?)?.toDouble(),
        geofenceLng: (json['geofenceLng'] as num?)?.toDouble(),
        geofenceRadius: (json['geofenceRadius'] as num?)?.toInt(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status.wire,
        'assignedToId': assignedToId,
        'geofenceLat': geofenceLat,
        'geofenceLng': geofenceLng,
        'geofenceRadius': geofenceRadius,
        'createdAt': createdAt?.toIso8601String(),
      };
}
