import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'earnings.g.dart';

@JsonSerializable()
class Earnings extends SerializableEntity {
  @override
  int? id;

  int driverId;
  String rideId;
  double baseFare;
  double distanceFare;
  double timeFare;
  double surgeFare;
  double tips;
  double bonuses;
  double tolls;
  double totalEarnings;
  double commission;
  double netEarnings;
  EarningsStatus status;
  DateTime earnedAt;
  DateTime? paidAt;
  String? paymentTransactionId;

  Earnings({
    this.id,
    required this.driverId,
    required this.rideId,
    required this.baseFare,
    required this.distanceFare,
    required this.timeFare,
    this.surgeFare = 0.0,
    this.tips = 0.0,
    this.bonuses = 0.0,
    this.tolls = 0.0,
    required this.totalEarnings,
    required this.commission,
    required this.netEarnings,
    this.status = EarningsStatus.pending,
    required this.earnedAt,
    this.paidAt,
    this.paymentTransactionId,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) =>
      _$EarningsFromJson(json);
  Map<String, dynamic> toJson() => _$EarningsToJson(this);
}

@JsonSerializable()
class DriverLocation extends SerializableEntity {
  @override
  int? id;

  int driverId;
  double latitude;
  double longitude;
  double? heading;
  double? speed;
  double? accuracy;
  bool isAvailable;
  bool isOnline;
  DateTime timestamp;
  String? currentRideId;
  LocationSource source;

  DriverLocation({
    this.id,
    required this.driverId,
    required this.latitude,
    required this.longitude,
    this.heading,
    this.speed,
    this.accuracy,
    this.isAvailable = false,
    this.isOnline = false,
    required this.timestamp,
    this.currentRideId,
    this.source = LocationSource.gps,
  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) =>
      _$DriverLocationFromJson(json);
  Map<String, dynamic> toJson() => _$DriverLocationToJson(this);
}

@JsonSerializable()
class BankingInfo extends SerializableEntity {
  @override
  int? id;

  int driverId;
  String bankName;
  String accountNumber;
  String routingNumber;
  String accountHolderName;
  AccountType accountType;
  String? swiftCode;
  String? iban;
  bool isVerified;
  DateTime addedAt;
  DateTime? verifiedAt;

  BankingInfo({
    this.id,
    required this.driverId,
    required this.bankName,
    required this.accountNumber,
    required this.routingNumber,
    required this.accountHolderName,
    required this.accountType,
    this.swiftCode,
    this.iban,
    this.isVerified = false,
    required this.addedAt,
    this.verifiedAt,
  });

  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    return '*' * (accountNumber.length - 4) +
        accountNumber.substring(accountNumber.length - 4);
  }

  factory BankingInfo.fromJson(Map<String, dynamic> json) =>
      _$BankingInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BankingInfoToJson(this);
}

enum EarningsStatus {
  pending,
  processing,
  paid,
  failed,
  disputed,
}

enum LocationSource {
  gps,
  network,
  passive,
  manual,
}

enum AccountType {
  checking,
  savings,
  business,
}
