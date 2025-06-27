import 'package:ride_hailing_shared/src/protocol/rides/ride_type.dart';
import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'location_point.dart';
import 'ride.dart';
import 'ride_request.dart';

part 'ride_response.g.dart';

@JsonSerializable()
class RideResponse extends SerializableEntity {
  @override
  int? id;

  bool success;
  String message;
  Ride? ride;

  // Ride estimation data
  double? estimatedFare;
  int? estimatedDuration; // in seconds
  double? estimatedDistance; // in meters
  DateTime? estimatedPickupTime;
  DateTime? estimatedArrivalTime;

  // Available drivers and offers
  List<DriverOffer>? availableDrivers;
  List<FareOption>? fareOptions;
  int? nearbyDriverCount;

  // Route information
  RoutePreview? routePreview;

  // Error information
  String? errorCode;
  RideErrorType? errorType;
  List<String>? errorDetails;
  Map<String, dynamic>? errorMetadata;

  // Alternative suggestions
  List<AlternativeOption>? alternatives;
  SurgeInfo? surgeInfo;

  // Request metadata
  String? requestId;
  DateTime timestamp;
  Map<String, dynamic>? metadata;

  RideResponse({
    this.id,
    required this.success,
    required this.message,
    this.ride,
    this.estimatedFare,
    this.estimatedDuration,
    this.estimatedDistance,
    this.estimatedPickupTime,
    this.estimatedArrivalTime,
    this.availableDrivers,
    this.fareOptions,
    this.nearbyDriverCount,
    this.routePreview,
    this.errorCode,
    this.errorType,
    this.errorDetails,
    this.errorMetadata,
    this.alternatives,
    this.surgeInfo,
    this.requestId,
    required this.timestamp,
    this.metadata,
  });

  // Factory constructors for different response types
  factory RideResponse.success({
    required String message,
    Ride? ride,
    double? estimatedFare,
    int? estimatedDuration,
    double? estimatedDistance,
    List<DriverOffer>? availableDrivers,
    RoutePreview? routePreview,
    String? requestId,
    Map<String, dynamic>? metadata,
  }) {
    return RideResponse(
      success: true,
      message: message,
      ride: ride,
      estimatedFare: estimatedFare,
      estimatedDuration: estimatedDuration,
      estimatedDistance: estimatedDistance,
      availableDrivers: availableDrivers,
      routePreview: routePreview,
      requestId: requestId,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  factory RideResponse.error({
    required String message,
    String? errorCode,
    RideErrorType? errorType,
    List<String>? errorDetails,
    List<AlternativeOption>? alternatives,
    Map<String, dynamic>? errorMetadata,
    String? requestId,
  }) {
    return RideResponse(
      success: false,
      message: message,
      errorCode: errorCode,
      errorType: errorType,
      errorDetails: errorDetails,
      alternatives: alternatives,
      errorMetadata: errorMetadata,
      requestId: requestId,
      timestamp: DateTime.now(),
    );
  }

  factory RideResponse.noDrivers({
    required int nearbyDriverCount,
    List<AlternativeOption>? alternatives,
    SurgeInfo? surgeInfo,
    String? requestId,
  }) {
    return RideResponse(
      success: false,
      message: 'No drivers available in your area',
      errorCode: 'NO_DRIVERS_AVAILABLE',
      errorType: RideErrorType.noDriversAvailable,
      nearbyDriverCount: nearbyDriverCount,
      alternatives: alternatives,
      surgeInfo: surgeInfo,
      requestId: requestId,
      timestamp: DateTime.now(),
    );
  }

  // Helper getters
  bool get hasDrivers =>
      availableDrivers != null && availableDrivers!.isNotEmpty;
  bool get hasAlternatives => alternatives != null && alternatives!.isNotEmpty;
  bool get isSurgeActive => surgeInfo != null && surgeInfo!.isActive;

  String get formattedEstimatedFare {
    if (estimatedFare == null) return 'N/A';
    return '\$${(estimatedFare! / 100).toStringAsFixed(2)}';
  }

  String get formattedEstimatedDuration {
    if (estimatedDuration == null) return 'N/A';
    final minutes = (estimatedDuration! / 60).round();
    return '${minutes} min${minutes != 1 ? 's' : ''}';
  }

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
  double driverRating;
  int totalRides;
  VehicleInfo vehicle;

  // Offer details
  double proposedFare; // in cents
  int estimatedArrivalTime; // in seconds
  double distanceFromPickup; // in meters

  // Driver status
  bool isOnline;
  bool isAvailable;
  DateTime? lastLocationUpdate;

  // Additional info
  List<String>? languages;
  List<String>? specialties; // 'pet_friendly', 'wheelchair_accessible', etc.
  String? driverMessage;
  Map<String, dynamic>? metadata;

  DriverOffer({
    this.id,
    required this.driverId,
    required this.driverName,
    this.driverPhoto,
    required this.driverRating,
    required this.totalRides,
    required this.vehicle,
    required this.proposedFare,
    required this.estimatedArrivalTime,
    required this.distanceFromPickup,
    required this.isOnline,
    required this.isAvailable,
    this.lastLocationUpdate,
    this.languages,
    this.specialties,
    this.driverMessage,
    this.metadata,
  });

  String get formattedProposedFare =>
      '\$${(proposedFare / 100).toStringAsFixed(2)}';
  String get formattedArrivalTime {
    final minutes = (estimatedArrivalTime / 60).round();
    return '${minutes} min${minutes != 1 ? 's' : ''}';
  }

  String get formattedDistance =>
      '${(distanceFromPickup / 1000).toStringAsFixed(1)} km';

  factory DriverOffer.fromJson(Map<String, dynamic> json) =>
      _$DriverOfferFromJson(json);
  Map<String, dynamic> toJson() => _$DriverOfferToJson(this);
}

@JsonSerializable()
class FareOption extends SerializableEntity {
  @override
  int? id;

  RideType rideType;
  String displayName;
  String description;
  double baseFare; // in cents
  double estimatedFare; // in cents
  int estimatedDuration; // in seconds
  bool isAvailable;
  int? availableVehicles;

  FareOption({
    this.id,
    required this.rideType,
    required this.displayName,
    required this.description,
    required this.baseFare,
    required this.estimatedFare,
    required this.estimatedDuration,
    this.isAvailable = true,
    this.availableVehicles,
  });

  String get formattedEstimatedFare =>
      '\$${(estimatedFare / 100).toStringAsFixed(2)}';

  factory FareOption.fromJson(Map<String, dynamic> json) =>
      _$FareOptionFromJson(json);
  Map<String, dynamic> toJson() => _$FareOptionToJson(this);
}

@JsonSerializable()
class RoutePreview extends SerializableEntity {
  @override
  int? id;

  List<LocationPoint> waypoints;
  double totalDistance; // in meters
  int estimatedDuration; // in seconds
  String? encodedPolyline;
  List<String>? instructions;

  RoutePreview({
    this.id,
    this.waypoints = const [],
    required this.totalDistance,
    required this.estimatedDuration,
    this.encodedPolyline,
    this.instructions,
  });

  factory RoutePreview.fromJson(Map<String, dynamic> json) =>
      _$RoutePreviewFromJson(json);
  Map<String, dynamic> toJson() => _$RoutePreviewToJson(this);
}

@JsonSerializable()
class AlternativeOption extends SerializableEntity {
  @override
  int? id;

  AlternativeType type;
  String title;
  String description;
  Map<String, dynamic>? actionData;

  AlternativeOption({
    this.id,
    required this.type,
    required this.title,
    required this.description,
    this.actionData,
  });

  factory AlternativeOption.fromJson(Map<String, dynamic> json) =>
      _$AlternativeOptionFromJson(json);
  Map<String, dynamic> toJson() => _$AlternativeOptionToJson(this);
}

@JsonSerializable()
class SurgeInfo extends SerializableEntity {
  @override
  int? id;

  bool isActive;
  double multiplier;
  String reason;
  DateTime? endsAt;
  List<String>? affectedAreas;

  SurgeInfo({
    this.id,
    required this.isActive,
    required this.multiplier,
    required this.reason,
    this.endsAt,
    this.affectedAreas,
  });

  String get formattedMultiplier => '${multiplier.toStringAsFixed(1)}x';

  factory SurgeInfo.fromJson(Map<String, dynamic> json) =>
      _$SurgeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SurgeInfoToJson(this);
}

enum RideErrorType {
  noDriversAvailable,
  invalidLocation,
  serviceUnavailable,
  paymentRequired,
  accountIssue,
  distanceTooLong,
  distanceTooShort,
  outsideServiceArea,
  surgeActive,
  other,
}

enum AlternativeType {
  scheduleRide,
  increaseRadius,
  changeRideType,
  waitForDrivers,
  addFare,
  publicTransport,
  walking,
  other,
}
