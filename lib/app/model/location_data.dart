class LocationData {
  final String name;
  final double latitude;
  final double longitude;

  LocationData({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() =>
      'LocationData(name: $name, lat: $latitude, lng: $longitude)';
}
