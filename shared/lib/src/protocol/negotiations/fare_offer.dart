import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import '../auth/user.dart';
import 'counter_offer.dart';

part 'fare_offer.g.dart';

@JsonSerializable()
class FareOffer extends SerializableEntity {
  @override
  int? id;

  String offerId;
  String negotiationId;
  String? rideId;
  int userId;
  UserType userType;
  double amount;
  String? message;
  DateTime createdAt;
  DateTime? expiresAt;
  FareOfferStatus status;
  String? rejectionReason;
  DateTime? respondedAt;
  int? respondedBy;

  // Offer context
  FareOfferType offerType;
  double? previousAmount;
  bool isInitialOffer;
  bool isCounterOffer;
  bool isFinalOffer;
  int offerSequence;

  // AI/System generated
  bool isSystemGenerated;
  double? confidenceScore; // 0-1 for AI generated offers
  Map<String, dynamic>? aiContext;

  // Business rules
  double? minimumAcceptableAmount;
  double? maximumAcceptableAmount;
  List<String>? offerReasons;
  Map<String, dynamic>? metadata;

  FareOffer({
    this.id,
    required this.offerId,
    required this.negotiationId,
    this.rideId,
    required this.userId,
    required this.userType,
    required this.amount,
    this.message,
    required this.createdAt,
    this.expiresAt,
    this.status = FareOfferStatus.active,
    this.rejectionReason,
    this.respondedAt,
    this.respondedBy,
    this.offerType = FareOfferType.standard,
    this.previousAmount,
    this.isInitialOffer = false,
    this.isCounterOffer = false,
    this.isFinalOffer = false,
    this.offerSequence = 1,
    this.isSystemGenerated = false,
    this.confidenceScore,
    this.aiContext,
    this.minimumAcceptableAmount,
    this.maximumAcceptableAmount,
    this.offerReasons,
    this.metadata,
  });

  // Check if offer is expired
  bool get isExpired {
    return expiresAt != null && DateTime.now().isAfter(expiresAt!);
  }

  // Check if offer is still active
  bool get isActive {
    return status == FareOfferStatus.active && !isExpired;
  }

  // Check if offer can be accepted
  bool get canBeAccepted {
    return isActive && status == FareOfferStatus.active;
  }

  // Check if offer can be countered
  bool get canBeCountered {
    return isActive && !isFinalOffer;
  }

  // Calculate percentage change from previous amount
  double? get percentageChange {
    if (previousAmount == null || previousAmount == 0) return null;
    return ((amount - previousAmount!) / previousAmount!) * 100;
  }

  // Get offer direction relative to previous amount
  OfferDirection get direction {
    if (previousAmount == null) return OfferDirection.unknown;
    if (amount > previousAmount!) return OfferDirection.higher;
    if (amount < previousAmount!) return OfferDirection.lower;
    return OfferDirection.same;
  }

  // Get time remaining until expiration
  Duration? get timeRemaining {
    if (expiresAt == null) return null;
    final remaining = expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  // Format time remaining as string
  String get formattedTimeRemaining {
    final remaining = timeRemaining;
    if (remaining == null) return 'No expiration';
    if (remaining == Duration.zero) return 'Expired';

    if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes}m';
    } else {
      return '${remaining.inSeconds}s';
    }
  }

  // Check if amount is within acceptable range
  bool get isWithinAcceptableRange {
    if (minimumAcceptableAmount != null && amount < minimumAcceptableAmount!) {
      return false;
    }
    if (maximumAcceptableAmount != null && amount > maximumAcceptableAmount!) {
      return false;
    }
    return true;
  }

  // Get user-friendly status description
  String get statusDescription {
    switch (status) {
      case FareOfferStatus.active:
        return isExpired ? 'Expired' : 'Waiting for response';
      case FareOfferStatus.accepted:
        return 'Accepted';
      case FareOfferStatus.rejected:
        return rejectionReason ?? 'Rejected';
      case FareOfferStatus.countered:
        return 'Countered';
      case FareOfferStatus.expired:
        return 'Expired';
      case FareOfferStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  // Create acceptance response
  FareOfferResponse createAcceptance({String? message}) {
    return FareOfferResponse(
      offerId: offerId,
      action: FareOfferAction.accept,
      message: message,
      respondedAt: DateTime.now(),
    );
  }

  // Create rejection response
  FareOfferResponse createRejection({required String reason, String? message}) {
    return FareOfferResponse(
      offerId: offerId,
      action: FareOfferAction.reject,
      rejectionReason: reason,
      message: message,
      respondedAt: DateTime.now(),
    );
  }

  // Create counter offer response
  FareOfferResponse createCounterOffer({
    required double counterAmount,
    String? message,
  }) {
    return FareOfferResponse(
      offerId: offerId,
      action: FareOfferAction.counter,
      counterAmount: counterAmount,
      message: message,
      respondedAt: DateTime.now(),
    );
  }

  factory FareOffer.fromJson(Map<String, dynamic> json) =>
      _$FareOfferFromJson(json);
  Map<String, dynamic> toJson() => _$FareOfferToJson(this);
}

@JsonSerializable()
class FareOfferResponse extends SerializableEntity {
  @override
  int? id;

  String offerId;
  FareOfferAction action;
  double? counterAmount;
  String? message;
  String? rejectionReason;
  DateTime respondedAt;
  Map<String, dynamic>? metadata;

  FareOfferResponse({
    this.id,
    required this.offerId,
    required this.action,
    this.counterAmount,
    this.message,
    this.rejectionReason,
    required this.respondedAt,
    this.metadata,
  });

  bool get isAcceptance => action == FareOfferAction.accept;
  bool get isRejection => action == FareOfferAction.reject;
  bool get isCounterOffer => action == FareOfferAction.counter;

  factory FareOfferResponse.fromJson(Map<String, dynamic> json) =>
      _$FareOfferResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FareOfferResponseToJson(this);
}

@JsonSerializable()
class FareOfferAnalytics extends SerializableEntity {
  @override
  int? id;

  String negotiationId;
  int totalOffers;
  int acceptedOffers;
  int rejectedOffers;
  int expiredOffers;
  double averageOfferAmount;
  double finalAgreedAmount;
  Duration negotiationDuration;
  int offerRounds;
  bool wasSuccessful;
  String? failureReason;
  Map<String, double> offerAmountHistory;
  Map<String, dynamic>? insights;

  FareOfferAnalytics({
    this.id,
    required this.negotiationId,
    this.totalOffers = 0,
    this.acceptedOffers = 0,
    this.rejectedOffers = 0,
    this.expiredOffers = 0,
    this.averageOfferAmount = 0.0,
    this.finalAgreedAmount = 0.0,
    required this.negotiationDuration,
    this.offerRounds = 0,
    this.wasSuccessful = false,
    this.failureReason,
    this.offerAmountHistory = const {},
    this.insights,
  });

  double get acceptanceRate {
    return totalOffers > 0 ? (acceptedOffers / totalOffers) * 100 : 0.0;
  }

  double get rejectionRate {
    return totalOffers > 0 ? (rejectedOffers / totalOffers) * 100 : 0.0;
  }

  factory FareOfferAnalytics.fromJson(Map<String, dynamic> json) =>
      _$FareOfferAnalyticsFromJson(json);
  Map<String, dynamic> toJson() => _$FareOfferAnalyticsToJson(this);
}

enum FareOfferStatus {
  active,
  accepted,
  rejected,
  countered,
  expired,
  withdrawn,
}

enum FareOfferType {
  standard,
  premium,
  discount,
  surge,
  promotional,
}

enum FareOfferAction {
  accept,
  reject,
  counter,
  withdraw,
}
