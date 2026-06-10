import '../../domain/entities/location_ping.dart';

class LocationPingModel extends LocationPing {
  const LocationPingModel({
    required super.latitude,
    required super.longitude,
    super.userId,
    super.accuracy,
    super.timestamp,
    super.email,
    super.name,
  });

  factory LocationPingModel.fromJson(Map<String, dynamic> json) =>
      LocationPingModel(
        userId: json['userId'] as String?,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        accuracy: (json['accuracy'] as num?)?.toDouble(),
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'].toString())
            : null,
        email: json['email'] as String?,
        name: json['name'] as String?,
      );

  /// Body shape for POST /location and the sync batch.
  Map<String, dynamic> toRequestJson() => {
        'latitude': latitude,
        'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
        if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      };

  Map<String, dynamic> toJson() => {
        'userId': userId,
        ...toRequestJson(),
        'email': email,
        'name': name,
      };
}
