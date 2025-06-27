import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'negotiation_status.g.dart';

@JsonSerializable()
class NegotiationStatus extends SerializableEntity {
  @override
  int? id;

  String negotiationId;
  String rideId;
  int passengerId;
  int? driverId;
  NegotiationPhase currentPhase;
  NegotiationState currentState;
  DateTime lastUpdated;
  DateTime? expiresAt;
  int totalOffers;
  int remainingOffers;
  double? lastOfferAmount;
  int? lastOfferUserId;
  bool canMakeOffer;
  bool canAcceptOffer;
  bool canRejectOffer;
  String? blockedReason;
  NegotiationSettings? settings;
  Map<String, dynamic>? metadata;

  NegotiationStatus({
    this.id,
    required this.negotiationId,
    required this.rideId,
    required this.passengerId,
    this.driverId,
    this.currentPhase = NegotiationPhase.initial,
    this.currentState = NegotiationState.waitingForDriver,
    required this.lastUpdated,
    this.expiresAt,
    this.totalOffers = 0,
    this.remainingOffers = 3,
    this.lastOfferAmount,
    this.lastOfferUserId,
    this.canMakeOffer = true,
    this.canAcceptOffer = false,
    this.canRejectOffer = false,
    this.blockedReason,
    this.settings,
    this.metadata,
  });

  // Check if negotiation is expired
  bool get isExpired {
    return expiresAt != null && DateTime.now().isAfter(expiresAt!);
  }

  // Check if negotiation is active
  bool get isActive {
    return currentState != NegotiationState.completed &&
        currentState != NegotiationState.cancelled &&
        currentState != NegotiationState.expired &&
        !isExpired;
  }

  // Check if negotiation is blocked
  bool get isBlocked {
    return blockedReason != null || !canMakeOffer;
  }

  // Get time remaining until expiration
  Duration? get timeRemaining {
    if (expiresAt == null) return null;
    final remaining = expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  // Get formatted time remaining
  String get formattedTimeRemaining {
    final remaining = timeRemaining;
    if (remaining == null) return 'No limit';
    if (remaining == Duration.zero) return 'Expired';

    if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes}m ${remaining.inSeconds % 60}s';
    } else {
      return '${remaining.inSeconds}s';
    }
  }

  // Get current phase description
  String get phaseDescription {
    switch (currentPhase) {
      case NegotiationPhase.initial:
        return 'Initial offer phase';
      case NegotiationPhase.negotiating:
        return 'Active negotiation';
      case NegotiationPhase.finalOffer:
        return 'Final offer phase';
      case NegotiationPhase.closing:
        return 'Closing negotiation';
    }
  }

  // Get current state description
  String get stateDescription {
    switch (currentState) {
      case NegotiationState.waitingForDriver:
        return 'Waiting for driver response';
      case NegotiationState.waitingForPassenger:
        return 'Waiting for passenger response';
      case NegotiationState.negotiating:
        return 'Active negotiation';
      case NegotiationState.completed:
        return 'Negotiation completed';
      case NegotiationState.cancelled:
        return 'Negotiation cancelled';
      case NegotiationState.expired:
        return 'Negotiation expired';
      case NegotiationState.blocked:
        return blockedReason ?? 'Negotiation blocked';
    }
  }

  // Check who can act next
  bool canUserAct(int userId) {
    if (!isActive || isBlocked) return false;

    switch (currentState) {
      case NegotiationState.waitingForDriver:
        return userId == driverId;
      case NegotiationState.waitingForPassenger:
        return userId == passengerId;
      case NegotiationState.negotiating:
        return userId == passengerId || userId == driverId;
      default:
        return false;
    }
  }

  // Get next possible actions for a user
  List<NegotiationAction> getAvailableActions(int userId) {
    if (!canUserAct(userId)) return [];

    final actions = <NegotiationAction>[];

    if (canAcceptOffer && lastOfferUserId != userId) {
      actions.add(NegotiationAction.accept);
    }

    if (canRejectOffer) {
      actions.add(NegotiationAction.reject);
    }

    if (canMakeOffer && remainingOffers > 0) {
      actions.add(NegotiationAction.counter);
    }

    return actions;
  }

  // Update status based on new offer
  void updateForNewOffer(int userId, double amount) {
    lastOfferAmount = amount;
    lastOfferUserId = userId;
    totalOffers++;
    remainingOffers = math.max(0, remainingOffers - 1);
    lastUpdated = DateTime.now();

    // Update state based on who made the offer
    if (userId == passengerId) {
      currentState = NegotiationState.waitingForDriver;
    } else if (userId == driverId) {
      currentState = NegotiationState.waitingForPassenger;
    }

    // Update phase based on remaining offers
    if (remainingOffers <= 1) {
      currentPhase = NegotiationPhase.finalOffer;
    } else if (totalOffers > 1) {
      currentPhase = NegotiationPhase.negotiating;
    }

    // Update permissions
    canAcceptOffer = true;
    canRejectOffer = true;
    canMakeOffer = remainingOffers > 0;
  }

  factory NegotiationStatus.fromJson(Map<String, dynamic> json) =>
      _$NegotiationStatusFromJson(json);
  Map<String, dynamic> toJson() => _$NegotiationStatusToJson(this);
}

@JsonSerializable()
class NegotiationSettings extends SerializableEntity {
  @override
  int? id;

  int maxOffers;
  Duration offerTimeout;
  Duration negotiationTimeout;
  double? minimumFare;
  double? maximumFare;
  bool allowSystemSuggestions;
  bool autoExpireOnTimeout;
  List<String>? blockedUsers;
  Map<String, dynamic>? customRules;

  NegotiationSettings({
    this.id,
    this.maxOffers = 3,
    this.offerTimeout = const Duration(minutes: 5),
    this.negotiationTimeout = const Duration(minutes: 15),
    this.minimumFare,
    this.maximumFare,
    this.allowSystemSuggestions = true,
    this.autoExpireOnTimeout = true,
    this.blockedUsers,
    this.customRules,
  });

  factory NegotiationSettings.fromJson(Map<String, dynamic> json) =>
      _$NegotiationSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$NegotiationSettingsToJson(this);
}

enum NegotiationPhase {
  initial,
  negotiating,
  finalOffer,
  closing,
}

enum NegotiationState {
  waitingForDriver,
  waitingForPassenger,
  negotiating,
  completed,
  cancelled,
  expired,
  blocked,
}

enum NegotiationAction {
  accept,
  reject,
  counter,
  withdraw,
}
