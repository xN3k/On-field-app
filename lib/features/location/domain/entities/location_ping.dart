class LocationPing {
  const LocationPing({
    required this.latitude,
    required this.longitude,
    this.userId,
    this.accuracy,
    this.timestamp,
    this.email,
    this.name,
  });

  final String? userId;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime? timestamp;

  // Populated for team/nearby views.
  final String? email;
  final String? name;
}
