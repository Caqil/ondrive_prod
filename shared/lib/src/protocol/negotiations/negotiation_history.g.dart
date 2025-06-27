// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'negotiation_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NegotiationHistory _$NegotiationHistoryFromJson(Map<String, dynamic> json) =>
    NegotiationHistory(
      id: (json['id'] as num?)?.toInt(),
      negotiationId: json['negotiationId'] as String,
      rideId: json['rideId'] as String,
      passengerId: (json['passengerId'] as num).toInt(),
      driverId: (json['driverId'] as num?)?.toInt(),
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => NegotiationEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      outcome:
          $enumDecodeNullable(_$NegotiationOutcomeEnumMap, json['outcome']) ??
              NegotiationOutcome.pending,
      initialPassengerOffer:
          (json['initialPassengerOffer'] as num?)?.toDouble(),
      initialDriverOffer: (json['initialDriverOffer'] as num?)?.toDouble(),
      finalAgreedAmount: (json['finalAgreedAmount'] as num?)?.toDouble(),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      totalDuration: json['totalDuration'] == null
          ? null
          : Duration(microseconds: (json['totalDuration'] as num).toInt()),
      totalOffers: (json['totalOffers'] as num?)?.toInt() ?? 0,
      passengerOffers: (json['passengerOffers'] as num?)?.toInt() ?? 0,
      driverOffers: (json['driverOffers'] as num?)?.toInt() ?? 0,
      completionReason: json['completionReason'] as String?,
      analytics: json['analytics'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NegotiationHistoryToJson(NegotiationHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'negotiationId': instance.negotiationId,
      'rideId': instance.rideId,
      'passengerId': instance.passengerId,
      'driverId': instance.driverId,
      'events': instance.events,
      'outcome': _$NegotiationOutcomeEnumMap[instance.outcome]!,
      'initialPassengerOffer': instance.initialPassengerOffer,
      'initialDriverOffer': instance.initialDriverOffer,
      'finalAgreedAmount': instance.finalAgreedAmount,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'totalDuration': instance.totalDuration?.inMicroseconds,
      'totalOffers': instance.totalOffers,
      'passengerOffers': instance.passengerOffers,
      'driverOffers': instance.driverOffers,
      'completionReason': instance.completionReason,
      'analytics': instance.analytics,
    };

const _$NegotiationOutcomeEnumMap = {
  NegotiationOutcome.pending: 'pending',
  NegotiationOutcome.agreed: 'agreed',
  NegotiationOutcome.rejected: 'rejected',
  NegotiationOutcome.expired: 'expired',
  NegotiationOutcome.cancelled: 'cancelled',
  NegotiationOutcome.timeout: 'timeout',
};

NegotiationEvent _$NegotiationEventFromJson(Map<String, dynamic> json) =>
    NegotiationEvent(
      id: (json['id'] as num?)?.toInt(),
      eventId: json['eventId'] as String,
      negotiationId: json['negotiationId'] as String,
      eventType: $enumDecode(_$NegotiationEventTypeEnumMap, json['eventType']),
      userId: (json['userId'] as num?)?.toInt(),
      userType: json['userType'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      amount: (json['amount'] as num?)?.toDouble(),
      message: json['message'] as String?,
      reason: json['reason'] as String?,
      eventData: json['eventData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NegotiationEventToJson(NegotiationEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'negotiationId': instance.negotiationId,
      'eventType': _$NegotiationEventTypeEnumMap[instance.eventType]!,
      'userId': instance.userId,
      'userType': instance.userType,
      'timestamp': instance.timestamp.toIso8601String(),
      'amount': instance.amount,
      'message': instance.message,
      'reason': instance.reason,
      'eventData': instance.eventData,
    };

const _$NegotiationEventTypeEnumMap = {
  NegotiationEventType.started: 'started',
  NegotiationEventType.offerMade: 'offerMade',
  NegotiationEventType.offerAccepted: 'offerAccepted',
  NegotiationEventType.offerRejected: 'offerRejected',
  NegotiationEventType.counterOffer: 'counterOffer',
  NegotiationEventType.expired: 'expired',
  NegotiationEventType.cancelled: 'cancelled',
  NegotiationEventType.agreed: 'agreed',
  NegotiationEventType.timeout: 'timeout',
  NegotiationEventType.systemIntervention: 'systemIntervention',
};

NegotiationMetrics _$NegotiationMetricsFromJson(Map<String, dynamic> json) =>
    NegotiationMetrics(
      id: (json['id'] as num?)?.toInt(),
      totalEvents: (json['totalEvents'] as num).toInt(),
      totalOffers: (json['totalOffers'] as num).toInt(),
      averageOfferAmount: (json['averageOfferAmount'] as num).toDouble(),
      priceVolatility: (json['priceVolatility'] as num).toDouble(),
      negotiationEfficiency: (json['negotiationEfficiency'] as num).toDouble(),
      timeToAgreement:
          Duration(microseconds: (json['timeToAgreement'] as num).toInt()),
      finalAgreedAmount: (json['finalAgreedAmount'] as num?)?.toDouble(),
      wasSuccessful: json['wasSuccessful'] as bool,
      additionalMetrics: json['additionalMetrics'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NegotiationMetricsToJson(NegotiationMetrics instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalEvents': instance.totalEvents,
      'totalOffers': instance.totalOffers,
      'averageOfferAmount': instance.averageOfferAmount,
      'priceVolatility': instance.priceVolatility,
      'negotiationEfficiency': instance.negotiationEfficiency,
      'timeToAgreement': instance.timeToAgreement.inMicroseconds,
      'finalAgreedAmount': instance.finalAgreedAmount,
      'wasSuccessful': instance.wasSuccessful,
      'additionalMetrics': instance.additionalMetrics,
    };
