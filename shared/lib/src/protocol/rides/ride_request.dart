import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import '../drivers/vehicle.dart';
import '../payments/payment_method.dart';
import 'location_point.dart';
import 'ride.dart';

part 'ride_request.g.dart';

@JsonSerializable()
class RideRequest extends SerializableEntity {
  @override
  int? id;

  LocationPoint pickupLocation;
  LocationPoint dropoffLocation;
  List<LocationPoint>? waypoints;
  RideType rideType;
  DateTime? scheduledAt;
  double? proposedFare;
  RidePreferences? preferences;
  String? specialRequests;
  String? notes;
  bool isEmergency;
  int? passengersCount;
  PaymentMethodType preferredPaymentMethod;

  RideRequest({
    this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.waypoints,
    required this.rideType,
    this.scheduledAt,
    this.proposedFare,
    this.preferences,
    this.specialRequests,
    this.notes,
    this.isEmergency = false,
    this.passengersCount = 1,
    this.preferredPaymentMethod = PaymentMethodType.card,
  });

  bool get isScheduled =>
      scheduledAt != null && scheduledAt!.isAfter(DateTime.now());
  bool get isImmediate =>
      scheduledAt == null ||
      scheduledAt!.isBefore(DateTime.now().add(Duration(minutes: 5)));

  factory RideRequest.fromJson(Map<String, dynamic> json) =>
      _$RideRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RideRequestToJson(this);
}

@JsonSerializable()
class RideResponse extends SerializableEntity {
  @override
  int? id;

  bool success;
  String message;
  Ride? ride;
  double? estimatedFare;
  int? estimatedDuration;
  double? estimatedDistance;
  List<DriverOffer>? nearbyDrivers;
  String? errorCode;

  RideResponse({
    this.id,
    required this.success,
    required this.message,
    this.ride,
    this.estimatedFare,
    this.estimatedDuration,
    this.estimatedDistance,
    this.nearbyDrivers,
    this.errorCode,
  });

  factory RideResponse.fromJson(Map<String, dynamic> json) =>
      _$RideResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RideResponseToJson(this);
}

@JsonSerializable()
class DriverOffer extends SerializableEntity {
  @override
  int? id;

  int driverId;
  String driverName;
  String? driverPhoto;
  double rating;
  int totalRides;
  VehicleInfo vehicle;
  double proposedFare;
  int estimatedArrivalTime; // minutes
  double distanceFromPickup; // km
  bool isOnline;
  bool isAvailable;

  DriverOffer({
    this.id,
    required this.driverId,
    required this.driverName,
    this.driverPhoto,
    required this.rating,
    required this.totalRides,
    required this.vehicle,
    required this.proposedFare,
    required this.estimatedArrivalTime,
    required this.distanceFromPickup,
    required this.isOnline,
    required this.isAvailable,
  });

  factory DriverOffer.fromJson(Map<String, dynamic> json) =>
      _$DriverOfferFromJson(json);
  Map<String, dynamic> toJson() => _$DriverOfferToJson(this);
}

@JsonSerializable()
class VehicleInfo extends SerializableEntity {
  @override
  int? id;

  String make;
  String model;
  int year;
  String color;
  String licensePlate;
  VehicleType vehicleType;
  List<String> features;

  VehicleInfo({
    this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    required this.vehicleType,
    this.features = const [],
  });

  String get displayName => '$year $make $model';

  factory VehicleInfo.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleInfoToJson(this);
}
