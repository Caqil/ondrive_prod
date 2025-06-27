// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_negotiation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareNegotiation _$FareNegotiationFromJson(Map<String, dynamic> json) =>
    FareNegotiation(
      id: (json['id'] as num?)?.toInt(),
      negotiationId: json['negotiationId'] as String,
      rideId: json['rideId'] as String,
      passengerId: (json['passengerId'] as num).toInt(),
      driverId: (json['driverId'] as num?)?.toInt(),
      passengerOffer: (json['passengerOffer'] as num).toDouble(),
      driverCounter: (json['driverCounter'] as num?)?.toDouble(),
      finalFare: (json['finalFare'] as num?)?.toDouble(),
      suggestedFare: (json['suggestedFare'] as num?)?.toDouble(),
      status: $enumDecode(_$NegotiationStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      passengerMessage: json['passengerMessage'] as String?,
      driverMessage: json['driverMessage'] as String?,
      offerHistory: (json['offerHistory'] as List<dynamic>?)
              ?.map((e) => FareOffer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      maxCounters: (json['maxCounters'] as num?)?.toInt() ?? 3,
      currentCounters: (json['currentCounters'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FareNegotiationToJson(FareNegotiation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'negotiationId': instance.negotiationId,
      'rideId': instance.rideId,
      'passengerId': instance.passengerId,
      'driverId': instance.driverId,
      'passengerOffer': instance.passengerOffer,
      'driverCounter': instance.driverCounter,
      'finalFare': instance.finalFare,
      'suggestedFare': instance.suggestedFare,
      'status': _$NegotiationStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'passengerMessage': instance.passengerMessage,
      'driverMessage': instance.driverMessage,
      'offerHistory': instance.offerHistory,
      'maxCounters': instance.maxCounters,
      'currentCounters': instance.currentCounters,
    };

const _$NegotiationStatusEnumMap = {
  NegotiationStatus.pending: 'pending',
  NegotiationStatus.driverResponded: 'driverResponded',
  NegotiationStatus.passengerResponded: 'passengerResponded',
  NegotiationStatus.accepted: 'accepted',
  NegotiationStatus.rejected: 'rejected',
  NegotiationStatus.expired: 'expired',
  NegotiationStatus.cancelled: 'cancelled',
};

FareOffer _$FareOfferFromJson(Map<String, dynamic> json) => FareOffer(
      id: (json['id'] as num?)?.toInt(),
      offerId: json['offerId'] as String,
      negotiationId: json['negotiationId'] as String,
      userId: (json['userId'] as num).toInt(),
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      amount: (json['amount'] as num).toDouble(),
      message: json['message'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: $enumDecode(_$OfferStatusEnumMap, json['status']),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$FareOfferToJson(FareOffer instance) => <String, dynamic>{
      'id': instance.id,
      'offerId': instance.offerId,
      'negotiationId': instance.negotiationId,
      'userId': instance.userId,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'amount': instance.amount,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$OfferStatusEnumMap[instance.status]!,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$UserTypeEnumMap = {
  UserType.passenger: 'passenger',
  UserType.driver: 'driver',
  UserType.admin: 'admin',
};

const _$OfferStatusEnumMap = {
  OfferStatus.active: 'active',
  OfferStatus.countered: 'countered',
  OfferStatus.accepted: 'accepted',
  OfferStatus.rejected: 'rejected',
  OfferStatus.expired: 'expired',
};

NegotiationRequest _$NegotiationRequestFromJson(Map<String, dynamic> json) =>
    NegotiationRequest(
      id: (json['id'] as num?)?.toInt(),
      rideId: json['rideId'] as String,
      offerAmount: (json['offerAmount'] as num).toDouble(),
      message: json['message'] as String?,
      targetDriverId: (json['targetDriverId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NegotiationRequestToJson(NegotiationRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rideId': instance.rideId,
      'offerAmount': instance.offerAmount,
      'message': instance.message,
      'targetDriverId': instance.targetDriverId,
    };

NegotiationResponse _$NegotiationResponseFromJson(Map<String, dynamic> json) =>
    NegotiationResponse(
      id: (json['id'] as num?)?.toInt(),
      negotiationId: json['negotiationId'] as String,
      counterOffer: (json['counterOffer'] as num).toDouble(),
      message: json['message'] as String?,
      action: $enumDecode(_$NegotiationActionEnumMap, json['action']),
    );

Map<String, dynamic> _$NegotiationResponseToJson(
        NegotiationResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'negotiationId': instance.negotiationId,
      'counterOffer': instance.counterOffer,
      'message': instance.message,
      'action': _$NegotiationActionEnumMap[instance.action]!,
    };

const _$NegotiationActionEnumMap = {
  NegotiationAction.accept: 'accept',
  NegotiationAction.counter: 'counter',
  NegotiationAction.reject: 'reject',
};

NegotiationHistory _$NegotiationHistoryFromJson(Map<String, dynamic> json) =>
    NegotiationHistory(
      id: (json['id'] as num?)?.toInt(),
      negotiationId: json['negotiationId'] as String,
      rideId: json['rideId'] as String,
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => FareOffer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      finalStatus: $enumDecode(_$NegotiationStatusEnumMap, json['finalStatus']),
      agreedFare: (json['agreedFare'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      completionReason: json['completionReason'] as String?,
    );

Map<String, dynamic> _$NegotiationHistoryToJson(NegotiationHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'negotiationId': instance.negotiationId,
      'rideId': instance.rideId,
      'offers': instance.offers,
      'finalStatus': _$NegotiationStatusEnumMap[instance.finalStatus]!,
      'agreedFare': instance.agreedFare,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'completionReason': instance.completionReason,
    };
