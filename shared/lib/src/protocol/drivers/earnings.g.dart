// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earnings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Earnings _$EarningsFromJson(Map<String, dynamic> json) => Earnings(
      id: (json['id'] as num?)?.toInt(),
      driverId: (json['driverId'] as num).toInt(),
      rideId: json['rideId'] as String,
      baseFare: (json['baseFare'] as num).toDouble(),
      distanceFare: (json['distanceFare'] as num).toDouble(),
      timeFare: (json['timeFare'] as num).toDouble(),
      surgeFare: (json['surgeFare'] as num?)?.toDouble() ?? 0.0,
      tips: (json['tips'] as num?)?.toDouble() ?? 0.0,
      bonuses: (json['bonuses'] as num?)?.toDouble() ?? 0.0,
      tolls: (json['tolls'] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (json['totalEarnings'] as num).toDouble(),
      commission: (json['commission'] as num).toDouble(),
      netEarnings: (json['netEarnings'] as num).toDouble(),
      status: $enumDecodeNullable(_$EarningsStatusEnumMap, json['status']) ??
          EarningsStatus.pending,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      paymentTransactionId: json['paymentTransactionId'] as String?,
    );

Map<String, dynamic> _$EarningsToJson(Earnings instance) => <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'rideId': instance.rideId,
      'baseFare': instance.baseFare,
      'distanceFare': instance.distanceFare,
      'timeFare': instance.timeFare,
      'surgeFare': instance.surgeFare,
      'tips': instance.tips,
      'bonuses': instance.bonuses,
      'tolls': instance.tolls,
      'totalEarnings': instance.totalEarnings,
      'commission': instance.commission,
      'netEarnings': instance.netEarnings,
      'status': _$EarningsStatusEnumMap[instance.status]!,
      'earnedAt': instance.earnedAt.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'paymentTransactionId': instance.paymentTransactionId,
    };

const _$EarningsStatusEnumMap = {
  EarningsStatus.pending: 'pending',
  EarningsStatus.processing: 'processing',
  EarningsStatus.paid: 'paid',
  EarningsStatus.failed: 'failed',
  EarningsStatus.disputed: 'disputed',
};

DriverLocation _$DriverLocationFromJson(Map<String, dynamic> json) =>
    DriverLocation(
      id: (json['id'] as num?)?.toInt(),
      driverId: (json['driverId'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      isAvailable: json['isAvailable'] as bool? ?? false,
      isOnline: json['isOnline'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
      currentRideId: json['currentRideId'] as String?,
      source: $enumDecodeNullable(_$LocationSourceEnumMap, json['source']) ??
          LocationSource.gps,
    );

Map<String, dynamic> _$DriverLocationToJson(DriverLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'heading': instance.heading,
      'speed': instance.speed,
      'accuracy': instance.accuracy,
      'isAvailable': instance.isAvailable,
      'isOnline': instance.isOnline,
      'timestamp': instance.timestamp.toIso8601String(),
      'currentRideId': instance.currentRideId,
      'source': _$LocationSourceEnumMap[instance.source]!,
    };

const _$LocationSourceEnumMap = {
  LocationSource.gps: 'gps',
  LocationSource.network: 'network',
  LocationSource.passive: 'passive',
  LocationSource.manual: 'manual',
};

BankingInfo _$BankingInfoFromJson(Map<String, dynamic> json) => BankingInfo(
      id: (json['id'] as num?)?.toInt(),
      driverId: (json['driverId'] as num).toInt(),
      bankName: json['bankName'] as String,
      accountNumber: json['accountNumber'] as String,
      routingNumber: json['routingNumber'] as String,
      accountHolderName: json['accountHolderName'] as String,
      accountType: $enumDecode(_$AccountTypeEnumMap, json['accountType']),
      swiftCode: json['swiftCode'] as String?,
      iban: json['iban'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      addedAt: DateTime.parse(json['addedAt'] as String),
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
    );

Map<String, dynamic> _$BankingInfoToJson(BankingInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'routingNumber': instance.routingNumber,
      'accountHolderName': instance.accountHolderName,
      'accountType': _$AccountTypeEnumMap[instance.accountType]!,
      'swiftCode': instance.swiftCode,
      'iban': instance.iban,
      'isVerified': instance.isVerified,
      'addedAt': instance.addedAt.toIso8601String(),
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
    };

const _$AccountTypeEnumMap = {
  AccountType.checking: 'checking',
  AccountType.savings: 'savings',
  AccountType.business: 'business',
};
