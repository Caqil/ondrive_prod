import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride_type.g.dart';

@JsonSerializable()
class RideTypeDefinition extends SerializableEntity {
  @override
  int? id;

  RideType rideType;
  String displayName;
  String description;
  String? iconName;
  bool isActive;
  int sortOrder;

  // Pricing configuration
  double baseFareMultiplier;
  double distanceMultiplier;
  double timeMultiplier;
  double minimumFare; // in cents
  double maximumFare; // in cents

  // Service configuration
  int maxPassengers;
  int maxLuggage;
  bool allowsPets;
  bool allowsFood;
  bool requiresChildSeat;
  bool isAccessible;
  bool isShared;
  bool isLuxury;
  bool isEco;

  // Vehicle requirements
  List<VehicleType> allowedVehicleTypes;
  int? minVehicleYear;
  List<String>? requiredFeatures;

  // Availability
  List<String> availableRegions;
  Map<String, bool>? timeAvailability; // Day/hour availability
  bool isAlwaysAvailable;

  // Business rules
  int maxDistance; // in km
  int maxDuration; // in minutes
  bool requiresPreBooking;
  int? advanceBookingHours;
  bool allowsCancellation;
  int? cancellationGracePeriod; // in minutes

  RideTypeDefinition({
    this.id,
    required this.rideType,
    required this.displayName,
    required this.description,
    this.iconName,
    this.isActive = true,
    this.sortOrder = 0,
    this.baseFareMultiplier = 1.0,
    this.distanceMultiplier = 1.0,
    this.timeMultiplier = 1.0,
    this.minimumFare = 500, // $5.00
    this.maximumFare = 50000, // $500.00
    this.maxPassengers = 4,
    this.maxLuggage = 2,
    this.allowsPets = false,
    this.allowsFood = false,
    this.requiresChildSeat = false,
    this.isAccessible = false,
    this.isShared = false,
    this.isLuxury = false,
    this.isEco = false,
    this.allowedVehicleTypes = const [],
    this.minVehicleYear,
    this.requiredFeatures,
    this.availableRegions = const [],
    this.timeAvailability,
    this.isAlwaysAvailable = true,
    this.maxDistance = 100, // 100km
    this.maxDuration = 300, // 5 hours
    this.requiresPreBooking = false,
    this.advanceBookingHours,
    this.allowsCancellation = true,
    this.cancellationGracePeriod = 5,
  });

  // Check if ride type is available in region
  bool isAvailableInRegion(String region) {
    return availableRegions.isEmpty || availableRegions.contains(region);
  }

  // Check if ride type is available at current time
  bool isAvailableNow() {
    if (isAlwaysAvailable) return true;
    if (timeAvailability == null) return true;

    final now = DateTime.now();
    final dayKey = _getDayKey(now.weekday);
    final hourKey = 'hour_${now.hour}';

    return timeAvailability![dayKey] == true &&
        timeAvailability![hourKey] == true;
  }

  // Check if distance/duration is within limits
  bool isWithinLimits(double distanceKm, int durationMinutes) {
    return distanceKm <= maxDistance && durationMinutes <= maxDuration;
  }

  // Get fare multiplier for this ride type
  double getTotalMultiplier() {
    return baseFareMultiplier * distanceMultiplier * timeMultiplier;
  }

  String _getDayKey(int weekday) {
    const days = [
      '',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    return days[weekday];
  }

  factory RideTypeDefinition.fromJson(Map<String, dynamic> json) =>
      _$RideTypeDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$RideTypeDefinitionToJson(this);
}

enum RideType {
  economy,
  standard,
  premium,
  luxury,
  suv,
  van,
  pool,
  intercity,
  courier,
  wheelchair,
  pet,
  eco,
  electric,
}

enum VehicleType {
  economy,
  standard,
  premium,
  luxury,
  suv,
  van,
  motorcycle,
  bicycle,
  wheelchair,
  electric,
}
