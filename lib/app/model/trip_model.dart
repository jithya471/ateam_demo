import 'package:hive/hive.dart';

part 'trip_model.g.dart'; 

@HiveType(typeId: 0)
class TripModel extends HiveObject {
  @HiveField(0)
  final String startLocationName;

  @HiveField(1)
  final double startLatitude;

  @HiveField(2)
  final double startLongitude;

  @HiveField(3)
  final String endLocationName;

  @HiveField(4)
  final double endLatitude;

  @HiveField(5)
  final double endLongitude;

  @HiveField(6)
  final double distance;

  @HiveField(7)
  final DateTime savedAt;

  TripModel({
    required this.startLocationName,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLocationName,
    required this.endLatitude,
    required this.endLongitude,
    required this.distance,
    required this.savedAt,
  });
}
