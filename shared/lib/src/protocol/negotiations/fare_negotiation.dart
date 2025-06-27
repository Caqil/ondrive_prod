import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import '../auth/user.dart';

part 'fare_negotiation.g.dart';

@JsonSerializable()
class FareNegotiation extends SerializableEntity {
  @override
  int? id;

  String negotiationId;
  String rideId;
  int passengerId;
  int? driverId;
  double passengerOffer;
  double? driverCounter;
  double? finalFare;
  double? suggestedFare;
  NegotiationStatus status;
  DateTime createdAt;
  DateTime? respondedAt;
  DateTime? completedAt;
  DateTime? expiresAt;
  String? passengerMessage;
  String? driverMessage;
  List<FareOffer> offerHistory;
  int maxCounters;
  int currentCounters;

  FareNegotiation({
    this.id,
    required this.negotiationId,
    required this.rideId,
    required this.passengerId,
    this.driverId,
    required this.passengerOffer,
    this.driverCounter,
    this.finalFare,
    this.suggestedFare,
    required this.status,
    required this.createdAt,
    this.respondedAt,
    this.completedAt,
    this.expiresAt,
    this.passengerMessage,
    this.driverMessage,
    this.offerHistory = const [],
    this.maxCounters = 3,
    this.currentCounters = 0,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get canCounter => currentCounters < maxCounters && !isExpired;
  bool get isActive =>
      status == NegotiationStatus.pending ||
      status == NegotiationStatus.driverResponded;

  factory FareNegotiation.fromJson(Map<String, dynamic> json) =>
      _$FareNegotiationFromJson(json);
  Map<String, dynamic> toJson() => _$FareNegotiationToJson(this);
}

@JsonSerializable()
class FareOffer extends SerializableEntity {
  @override
  int? id;

  String offerId;
  String negotiationId;
  int userId;
  UserType userType;
  double amount;
  String? message;
  DateTime createdAt;
  OfferStatus status;
  DateTime? expiresAt;

  FareOffer({
    this.id,
    required this.offerId,
    required this.negotiationId,
    required this.userId,
    required this.userType,
    required this.amount,
    this.message,
    required this.createdAt,
    required this.status,
    this.expiresAt,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory FareOffer.fromJson(Map<String, dynamic> json) =>
      _$FareOfferFromJson(json);
  Map<String, dynamic> toJson() => _$FareOfferToJson(this);
}

@JsonSerializable()
class NegotiationRequest extends SerializableEntity {
  @override
  int? id;

  String rideId;
  double offerAmount;
  String? message;
  int? targetDriverId; // null for broadcasting to all drivers

  NegotiationRequest({
    this.id,
    required this.rideId,
    required this.offerAmount,
    this.message,
    this.targetDriverId,
  });

  factory NegotiationRequest.fromJson(Map<String, dynamic> json) =>
      _$NegotiationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$NegotiationRequestToJson(this);
}

@JsonSerializable()
class NegotiationResponse extends SerializableEntity {
  @override
  int? id;

  String negotiationId;
  double counterOffer;
  String? message;
  NegotiationAction action;

  NegotiationResponse({
    this.id,
    required this.negotiationId,
    required this.counterOffer,
    this.message,
    required this.action,
  });

  factory NegotiationResponse.fromJson(Map<String, dynamic> json) =>
      _$NegotiationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NegotiationResponseToJson(this);
}

@JsonSerializable()
class NegotiationHistory extends SerializableEntity {
  @override
  int? id;

  String negotiationId;
  String rideId;
  List<FareOffer> offers;
  NegotiationStatus finalStatus;
  double? agreedFare;
  DateTime createdAt;
  DateTime? completedAt;
  String? completionReason;

  NegotiationHistory({
    this.id,
    required this.negotiationId,
    required this.rideId,
    this.offers = const [],
    required this.finalStatus,
    this.agreedFare,
    required this.createdAt,
    this.completedAt,
    this.completionReason,
  });

  factory NegotiationHistory.fromJson(Map<String, dynamic> json) =>
      _$NegotiationHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$NegotiationHistoryToJson(this);
}

enum NegotiationStatus {
  pending,
  driverResponded,
  passengerResponded,
  accepted,
  rejected,
  expired,
  cancelled,
}

enum OfferStatus {
  active,
  countered,
  accepted,
  rejected,
  expired,
}

enum NegotiationAction {
  accept,
  counter,
  reject,
}
