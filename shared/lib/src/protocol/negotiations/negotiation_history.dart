import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'negotiation_history.g.dart';

@JsonSerializable()
class NegotiationHistory extends SerializableEntity {
  @override
  int? id;

  String negotiationId;
  String rideId;
  int passengerId;
  int? driverId;
  List<NegotiationEvent> events;
  NegotiationOutcome outcome;
  double? initialPassengerOffer;
  double? initialDriverOffer;
  double? finalAgreedAmount;
  DateTime startedAt;
  DateTime? completedAt;
  Duration? totalDuration;
  int totalOffers;
  int passengerOffers;
  int driverOffers;
  String? completionReason;
  Map<String, dynamic>? analytics;

  NegotiationHistory({
    this.id,
    required this.negotiationId,
    required this.rideId,
    required this.passengerId,
    this.driverId,
    this.events = const [],
    this.outcome = NegotiationOutcome.pending,
    this.initialPassengerOffer,
    this.initialDriverOffer,
    this.finalAgreedAmount,
    required this.startedAt,
    this.completedAt,
    this.totalDuration,
    this.totalOffers = 0,
    this.passengerOffers = 0,
    this.driverOffers = 0,
    this.completionReason,
    this.analytics,
  });

  // Calculate duration if not set
  Duration get calculatedDuration {
    if (totalDuration != null) return totalDuration!;
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt);
  }

  // Check if negotiation is still active
  bool get isActive {
    return outcome == NegotiationOutcome.pending && completedAt == null;
  }

  // Check if negotiation was successful
  bool get wasSuccessful {
    return outcome == NegotiationOutcome.agreed;
  }

  // Get the last event
  NegotiationEvent? get lastEvent {
    return events.isEmpty ? null : events.last;
  }

  // Get events by type
  List<NegotiationEvent> getEventsByType(NegotiationEventType type) {
    return events.where((event) => event.eventType == type).toList();
  }

  // Get all offer amounts in chronological order
  List<double> get offerAmountHistory {
    return events
        .where((event) => event.eventType == NegotiationEventType.offerMade)
        .map((event) => event.amount ?? 0.0)
        .toList();
  }

  // Calculate negotiation metrics
  NegotiationMetrics calculateMetrics() {
    final offerAmounts = offerAmountHistory;

    return NegotiationMetrics(
      totalEvents: events.length,
      totalOffers: totalOffers,
      averageOfferAmount: offerAmounts.isNotEmpty
          ? offerAmounts.reduce((a, b) => a + b) / offerAmounts.length
          : 0.0,
      priceVolatility: _calculatePriceVolatility(offerAmounts),
      negotiationEfficiency: _calculateEfficiency(),
      timeToAgreement: calculatedDuration,
      finalAgreedAmount: finalAgreedAmount,
      wasSuccessful: wasSuccessful,
    );
  }

  double _calculatePriceVolatility(List<double> amounts) {
    if (amounts.length < 2) return 0.0;

    double sum = 0.0;
    for (int i = 1; i < amounts.length; i++) {
      sum += (amounts[i] - amounts[i - 1]).abs();
    }
    return sum / (amounts.length - 1);
  }

  double _calculateEfficiency() {
    if (totalOffers == 0) return 0.0;
    if (!wasSuccessful) return 0.0;

    // Efficiency score: fewer offers = higher efficiency
    // Maximum efficiency of 1.0 for single offer acceptance
    return math.max(0.0, 1.0 - (totalOffers - 1) * 0.2);
  }

  // Add event to history
  void addEvent(NegotiationEvent event) {
    events.add(event);

    // Update counters
    if (event.eventType == NegotiationEventType.offerMade) {
      totalOffers++;
      if (event.userId == passengerId) {
        passengerOffers++;
      } else if (event.userId == driverId) {
        driverOffers++;
      }
    }
  }

  factory NegotiationHistory.fromJson(Map<String, dynamic> json) =>
      _$NegotiationHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$NegotiationHistoryToJson(this);
}

@JsonSerializable()
class NegotiationEvent extends SerializableEntity {
  @override
  int? id;

  String eventId;
  String negotiationId;
  NegotiationEventType eventType;
  int? userId;
  String? userType; // 'passenger', 'driver', 'system'
  DateTime timestamp;
  double? amount;
  String? message;
  String? reason;
  Map<String, dynamic>? eventData;

  NegotiationEvent({
    this.id,
    required this.eventId,
    required this.negotiationId,
    required this.eventType,
    this.userId,
    this.userType,
    required this.timestamp,
    this.amount,
    this.message,
    this.reason,
    this.eventData,
  });

  // Get user-friendly event description
  String get description {
    switch (eventType) {
      case NegotiationEventType.started:
        return 'Negotiation started';
      case NegotiationEventType.offerMade:
        final amountStr = amount?.toStringAsFixed(2) ?? 'unknown';
        return '$userType offered \$${amountStr}';
      case NegotiationEventType.offerAccepted:
        return 'Offer accepted';
      case NegotiationEventType.offerRejected:
        return 'Offer rejected${reason != null ? ': $reason' : ''}';
      case NegotiationEventType.counterOffer:
        final amountStr = amount?.toStringAsFixed(2) ?? 'unknown';
        return '$userType countered with \$${amountStr}';
      case NegotiationEventType.expired:
        return 'Negotiation expired';
      case NegotiationEventType.cancelled:
        return 'Negotiation cancelled${reason != null ? ': $reason' : ''}';
      case NegotiationEventType.agreed:
        final amountStr = amount?.toStringAsFixed(2) ?? 'unknown';
        return 'Agreement reached at \$${amountStr}';
      case NegotiationEventType.timeout:
        return 'Negotiation timed out';
      case NegotiationEventType.systemIntervention:
        return 'System intervention${reason != null ? ': $reason' : ''}';
    }
  }

  factory NegotiationEvent.fromJson(Map<String, dynamic> json) =>
      _$NegotiationEventFromJson(json);
  Map<String, dynamic> toJson() => _$NegotiationEventToJson(this);
}

@JsonSerializable()
class NegotiationMetrics extends SerializableEntity {
  @override
  int? id;

  int totalEvents;
  int totalOffers;
  double averageOfferAmount;
  double priceVolatility;
  double negotiationEfficiency; // 0-1 score
  Duration timeToAgreement;
  double? finalAgreedAmount;
  bool wasSuccessful;
  Map<String, dynamic>? additionalMetrics;

  NegotiationMetrics({
    this.id,
    required this.totalEvents,
    required this.totalOffers,
    required this.averageOfferAmount,
    required this.priceVolatility,
    required this.negotiationEfficiency,
    required this.timeToAgreement,
    this.finalAgreedAmount,
    required this.wasSuccessful,
    this.additionalMetrics,
  });

  // Get efficiency rating
  String get efficiencyRating {
    if (negotiationEfficiency >= 0.8) return 'Excellent';
    if (negotiationEfficiency >= 0.6) return 'Good';
    if (negotiationEfficiency >= 0.4) return 'Fair';
    if (negotiationEfficiency >= 0.2) return 'Poor';
    return 'Very Poor';
  }

  // Get volatility rating
  String get volatilityRating {
    if (priceVolatility >= 10.0) return 'Very High';
    if (priceVolatility >= 5.0) return 'High';
    if (priceVolatility >= 2.0) return 'Moderate';
    if (priceVolatility >= 1.0) return 'Low';
    return 'Very Low';
  }

  factory NegotiationMetrics.fromJson(Map<String, dynamic> json) =>
      _$NegotiationMetricsFromJson(json);
  Map<String, dynamic> toJson() => _$NegotiationMetricsToJson(this);
}

enum NegotiationOutcome {
  pending,
  agreed,
  rejected,
  expired,
  cancelled,
  timeout,
}

enum NegotiationEventType {
  started,
  offerMade,
  offerAccepted,
  offerRejected,
  counterOffer,
  expired,
  cancelled,
  agreed,
  timeout,
  systemIntervention,
}
