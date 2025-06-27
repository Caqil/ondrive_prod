import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'driver_document.dart';
import 'earnings.dart';
import 'vehicle.dart';

part 'driver_profile.g.dart';

@JsonSerializable()
class DriverProfile extends SerializableEntity {
  @override
  int? id;

  int userId;
  String licenseNumber;
  DateTime licenseExpiryDate;
  String licenseIssuingCountry;
  String licenseIssuingState;
  DriverStatus status;
  DriverVerificationStatus verificationStatus;
  double? rating;
  int totalRides;
  int totalEarnings; // in cents
  DateTime? onboardingCompletedAt;
  DateTime? lastActiveAt;
  bool isAvailable;
  bool isOnline;
  List<String> serviceTypes; // ['city', 'intercity', 'courier', 'luxury']
  List<String> operatingCities;
  DriverPreferences preferences;
  List<DriverDocument> documents;
  List<Vehicle> vehicles;
  BankingInfo? bankingInfo;
  DriverStatistics? statistics;

  DriverProfile({
    this.id,
    required this.userId,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.licenseIssuingCountry,
    required this.licenseIssuingState,
    this.status = DriverStatus.pending,
    this.verificationStatus = DriverVerificationStatus.pending,
    this.rating,
    this.totalRides = 0,
    this.totalEarnings = 0,
    this.onboardingCompletedAt,
    this.lastActiveAt,
    this.isAvailable = false,
    this.isOnline = false,
    this.serviceTypes = const [],
    this.operatingCities = const [],
    required this.preferences,
    this.documents = const [],
    this.vehicles = const [],
    this.bankingInfo,
    this.statistics,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DriverProfileToJson(this);
}

@JsonSerializable()
class DriverPreferences extends SerializableEntity {
  @override
  int? id;

  bool autoAcceptRides;
  int maxRideDistance; // in km
  int maxRideDuration; // in minutes
  bool acceptLongRides;
  bool acceptPoolRides;
  bool acceptPetRides;
  bool acceptLuggageRides;
  List<String> preferredRideTypes;
  Map<String, dynamic> workingHours; // Day -> {start, end}
  bool workWeekends;
  int maxDailyRides;
  double minimumFareAmount;

  DriverPreferences({
    this.id,
    this.autoAcceptRides = false,
    this.maxRideDistance = 50,
    this.maxRideDuration = 120,
    this.acceptLongRides = true,
    this.acceptPoolRides = true,
    this.acceptPetRides = false,
    this.acceptLuggageRides = true,
    this.preferredRideTypes = const [],
    this.workingHours = const {},
    this.workWeekends = true,
    this.maxDailyRides = 20,
    this.minimumFareAmount = 5.0,
  });

  factory DriverPreferences.fromJson(Map<String, dynamic> json) =>
      _$DriverPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$DriverPreferencesToJson(this);
}

@JsonSerializable()
class DriverStatistics extends SerializableEntity {
  @override
  int? id;

  int driverId;
  int totalRidesCompleted;
  int totalRidesCancelled;
  int totalRidesDeclined;
  double totalDistanceDriven; // in km
  int totalDrivingTime; // in minutes
  double totalEarnings; // in currency
  double averageRating;
  int totalRatings;
  int fiveStarRatings;
  int fourStarRatings;
  int threeStarRatings;
  int twoStarRatings;
  int oneStarRatings;
  double acceptanceRate; // percentage
  double cancellationRate; // percentage
  double averageResponseTime; // in seconds
  DateTime? lastUpdated;
  Map<String, dynamic> monthlyStats;
  Map<String, dynamic> weeklyStats;

  DriverStatistics({
    this.id,
    required this.driverId,
    this.totalRidesCompleted = 0,
    this.totalRidesCancelled = 0,
    this.totalRidesDeclined = 0,
    this.totalDistanceDriven = 0.0,
    this.totalDrivingTime = 0,
    this.totalEarnings = 0.0,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.fiveStarRatings = 0,
    this.fourStarRatings = 0,
    this.threeStarRatings = 0,
    this.twoStarRatings = 0,
    this.oneStarRatings = 0,
    this.acceptanceRate = 0.0,
    this.cancellationRate = 0.0,
    this.averageResponseTime = 0.0,
    this.lastUpdated,
    this.monthlyStats = const {},
    this.weeklyStats = const {},
  });

  factory DriverStatistics.fromJson(Map<String, dynamic> json) =>
      _$DriverStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$DriverStatisticsToJson(this);
}

enum DriverStatus {
  pending,
  active,
  inactive,
  suspended,
  blocked,
  onboarding,
}

enum DriverVerificationStatus {
  pending,
  documentsSubmitted,
  underReview,
  approved,
  rejected,
  requiresUpdate,
}
