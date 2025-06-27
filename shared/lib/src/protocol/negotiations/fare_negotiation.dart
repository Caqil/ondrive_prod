// shared/lib/src/protocol/negotiations/fare_negotiation.dart
import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import '../auth/user.dart';
import 'fare_offer.dart'; // Import the complete FareOffer
import 'negotiation_status.dart'; // Import the complete NegotiationStatus class
import 'negotiation_history.dart'; // Import the complete NegotiationHistory

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
  String statusId; // Reference to NegotiationStatus by ID
  DateTime createdAt;
  DateTime? respondedAt;
  DateTime? completedAt;
  DateTime? expiresAt;
  String? passengerMessage;
  String? driverMessage;
  List<FareOffer> offerHistory; // Use the imported FareOffer
  int maxCounters;
  int currentCounters;

  // Optional embedded status for convenience
  NegotiationStatus? negotiationStatus;

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
    required this.statusId,
    required this.createdAt,
    this.respondedAt,
    this.completedAt,
    this.expiresAt,
    this.passengerMessage,
    this.driverMessage,
    this.offerHistory = const [],
    this.maxCounters = 3,
    this.currentCounters = 0,
    this.negotiationStatus,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get canCounter => currentCounters < maxCounters && !isExpired;

  // Use the rich NegotiationStatus for business logic
  bool get isActive {
    if (negotiationStatus != null) {
      return negotiationStatus!.isActive;
    }
    // Fallback logic if status not loaded
    return !isExpired && completedAt == null;
  }

  // Check if user can make actions based on full status
  bool canUserAct(int userId) {
    return negotiationStatus?.canUserAct(userId) ?? false;
  }

  // Get available actions for user
  List<NegotiationAction>? getAvailableActions(int userId) {
    final actions = negotiationStatus?.getAvailableActions(userId);
    if (actions == null) return [];
    return actions.whereType<NegotiationAction>().toList();
  }

  factory FareNegotiation.fromJson(Map<String, dynamic> json) =>
      _$FareNegotiationFromJson(json);
  Map<String, dynamic> toJson() => _$FareNegotiationToJson(this);
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

// Keep only essential enums that don't conflict
enum OfferStatus {
  active,
  countered,
  accepted,
  rejected,
  expired,
}
