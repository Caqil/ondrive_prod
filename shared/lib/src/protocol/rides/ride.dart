import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'location_point.dart';

part 'ride.g.dart';

@JsonSerializable()
class Ride extends SerializableEntity {
  @override
  int? id;

  String rideId;
  int passengerId;
  int? driverId;
  RideType rideType;
  RideStatus status;
  LocationPoint pickupLocation;
  LocationPoint dropoffLocation;
  List<LocationPoint>? waypoints;
  DateTime requestedAt;
  DateTime? scheduledAt;
  DateTime? startedAt;
  DateTime? completedAt;
  double? distance;
  int? estimatedDuration; // in seconds
  double? estimatedFare;
  double? finalFare;
  double? suggestedFare;
  RidePreferences? preferences;
  String? specialRequests;
  String? notes;
  bool isEmergency;
  int? poolingGroupId;

  Ride({
    this.id,
    required this.rideId,
    required this.passengerId,
    this.driverId,
    required this.rideType,
    required this.status,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.waypoints,
    required this.requestedAt,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
    this.distance,
    this.estimatedDuration,
    this.estimatedFare,
    this.finalFare,
    this.suggestedFare,
    this.preferences,
    this.specialRequests,
    this.notes,
    this.isEmergency = false,
    this.poolingGroupId,
  });

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);
  Map<String, dynamic> toJson() => _$RideToJson(this);
}

@JsonSerializable()
class RidePreferences extends SerializableEntity {
  @override
  int? id;

  bool allowPets;
  bool requireChildSeat;
  bool allowLuggage;
  bool wheelchairAccessible;
  String? musicPreference;
  String? temperaturePreference;
  bool quietRide;

  RidePreferences({
    this.id,
    this.allowPets = false,
    this.requireChildSeat = false,
    this.allowLuggage = true,
    this.wheelchairAccessible = false,
    this.musicPreference,
    this.temperaturePreference,
    this.quietRide = false,
  });

  factory RidePreferences.fromJson(Map<String, dynamic> json) =>
      _$RidePreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$RidePreferencesToJson(this);
}

enum RideType {
  city,
  intercity,
  courier,
  pool,
  luxury,
  eco,
}

enum RideStatus {
  requested,
  negotiating,
  driverAssigned,
  driverEnRoute,
  arrived,
  inProgress,
  completed,
  cancelled,
  noDriversAvailable,
}
