enum TaskStatus {
  pending,
  inProgress,
  completed;

  static TaskStatus fromString(String value) => switch (value.toUpperCase()) {
        'IN_PROGRESS' => TaskStatus.inProgress,
        'COMPLETED' => TaskStatus.completed,
        _ => TaskStatus.pending,
      };

  String get wire => switch (this) {
        TaskStatus.pending => 'PENDING',
        TaskStatus.inProgress => 'IN_PROGRESS',
        TaskStatus.completed => 'COMPLETED',
      };

  String get label => switch (this) {
        TaskStatus.pending => 'Pending',
        TaskStatus.inProgress => 'In Progress',
        TaskStatus.completed => 'Completed',
      };
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.status,
    required this.assignedToId,
    this.description,
    this.geofenceLat,
    this.geofenceLng,
    this.geofenceRadius,
    this.createdAt,
  });

  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final String assignedToId;
  final double? geofenceLat;
  final double? geofenceLng;
  final int? geofenceRadius;
  final DateTime? createdAt;

  bool get hasGeofence => geofenceLat != null && geofenceLng != null;

  Task copyWith({TaskStatus? status}) => Task(
        id: id,
        title: title,
        description: description,
        status: status ?? this.status,
        assignedToId: assignedToId,
        geofenceLat: geofenceLat,
        geofenceLng: geofenceLng,
        geofenceRadius: geofenceRadius,
        createdAt: createdAt,
      );
}
