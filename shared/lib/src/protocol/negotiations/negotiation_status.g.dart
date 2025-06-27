// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'negotiation_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NegotiationStatus _$NegotiationStatusFromJson(Map<String, dynamic> json) =>
    NegotiationStatus(
      id: (json['id'] as num?)?.toInt(),
      negotiationId: json['negotiationId'] as String,
      rideId: json['rideId'] as String,
      passengerId: (json['passengerId'] as num).toInt(),
      driverId: (json['driverId'] as num?)?.toInt(),
      currentPhase: $enumDecodeNullable(
              _$NegotiationPhaseEnumMap, json['currentPhase']) ??
          NegotiationPhase.initial,
      currentState: $enumDecodeNullable(
              _$NegotiationStateEnumMap, json['currentState']) ??
          NegotiationState.waitingForDriver,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      totalOffers: (json['totalOffers'] as num?)?.toInt() ?? 0,
      remainingOffers: (json['remainingOffers'] as num?)?.toInt() ?? 3,
      lastOfferAmount: (json['lastOfferAmount'] as num?)?.toDouble(),
      lastOfferUserId: (json['lastOfferUserId'] as num?)?.toInt(),
      canMakeOffer: json['canMakeOffer'] as bool? ?? true,
      canAcceptOffer: json['canAcceptOffer'] as bool? ?? false,
      canRejectOffer: json['canRejectOffer'] as bool? ?? false,
      blockedReason: json['blockedReason'] as String?,
      settings: json['settings'] == null
          ? null
          : NegotiationSettings.fromJson(
              json['settings'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NegotiationStatusToJson(NegotiationStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'negotiationId': instance.negotiationId,
      'rideId': instance.rideId,
      'passengerId': instance.passengerId,
      'driverId': instance.driverId,
      'currentPhase': _$NegotiationPhaseEnumMap[instance.currentPhase]!,
      'currentState': _$NegotiationStateEnumMap[instance.currentState]!,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'totalOffers': instance.totalOffers,
      'remainingOffers': instance.remainingOffers,
      'lastOfferAmount': instance.lastOfferAmount,
      'lastOfferUserId': instance.lastOfferUserId,
      'canMakeOffer': instance.canMakeOffer,
      'canAcceptOffer': instance.canAcceptOffer,
      'canRejectOffer': instance.canRejectOffer,
      'blockedReason': instance.blockedReason,
      'settings': instance.settings,
      'metadata': instance.metadata,
    };

const _$NegotiationPhaseEnumMap = {
  NegotiationPhase.initial: 'initial',
  NegotiationPhase.negotiating: 'negotiating',
  NegotiationPhase.finalOffer: 'finalOffer',
  NegotiationPhase.closing: 'closing',
};

const _$NegotiationStateEnumMap = {
  NegotiationState.waitingForDriver: 'waitingForDriver',
  NegotiationState.waitingForPassenger: 'waitingForPassenger',
  NegotiationState.negotiating: 'negotiating',
  NegotiationState.completed: 'completed',
  NegotiationState.cancelled: 'cancelled',
  NegotiationState.expired: 'expired',
  NegotiationState.blocked: 'blocked',
};

NegotiationSettings _$NegotiationSettingsFromJson(Map<String, dynamic> json) =>
    NegotiationSettings(
      id: (json['id'] as num?)?.toInt(),
      maxOffers: (json['maxOffers'] as num?)?.toInt() ?? 3,
      offerTimeout: json['offerTimeout'] == null
          ? const Duration(minutes: 5)
          : Duration(microseconds: (json['offerTimeout'] as num).toInt()),
      negotiationTimeout: json['negotiationTimeout'] == null
          ? const Duration(minutes: 15)
          : Duration(microseconds: (json['negotiationTimeout'] as num).toInt()),
      minimumFare: (json['minimumFare'] as num?)?.toDouble(),
      maximumFare: (json['maximumFare'] as num?)?.toDouble(),
      allowSystemSuggestions: json['allowSystemSuggestions'] as bool? ?? true,
      autoExpireOnTimeout: json['autoExpireOnTimeout'] as bool? ?? true,
      blockedUsers: (json['blockedUsers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      customRules: json['customRules'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NegotiationSettingsToJson(
        NegotiationSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'maxOffers': instance.maxOffers,
      'offerTimeout': instance.offerTimeout.inMicroseconds,
      'negotiationTimeout': instance.negotiationTimeout.inMicroseconds,
      'minimumFare': instance.minimumFare,
      'maximumFare': instance.maximumFare,
      'allowSystemSuggestions': instance.allowSystemSuggestions,
      'autoExpireOnTimeout': instance.autoExpireOnTimeout,
      'blockedUsers': instance.blockedUsers,
      'customRules': instance.customRules,
    };
