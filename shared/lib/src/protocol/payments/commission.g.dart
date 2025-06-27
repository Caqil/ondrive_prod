// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Commission _$CommissionFromJson(Map<String, dynamic> json) => Commission(
      id: (json['id'] as num?)?.toInt(),
      commissionId: json['commissionId'] as String,
      rideId: json['rideId'] as String,
      driverId: (json['driverId'] as num).toInt(),
      rideAmount: (json['rideAmount'] as num).toDouble(),
      commissionRate: (json['commissionRate'] as num).toDouble(),
      commissionAmount: (json['commissionAmount'] as num).toDouble(),
      driverEarnings: (json['driverEarnings'] as num).toDouble(),
      status: $enumDecodeNullable(_$CommissionStatusEnumMap, json['status']) ??
          CommissionStatus.pending,
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      breakdown: json['breakdown'] == null
          ? null
          : CommissionBreakdown.fromJson(
              json['breakdown'] as Map<String, dynamic>),
      paymentId: json['paymentId'] as String?,
      paymentTransactionId: json['paymentTransactionId'] as String?,
      paymentMethod: json['paymentMethod'] == null
          ? null
          : PaymentMethod.fromJson(
              json['paymentMethod'] as Map<String, dynamic>),
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      processingFee: (json['processingFee'] as num?)?.toDouble() ?? 0.0,
      adjustments: (json['adjustments'] as num?)?.toDouble() ?? 0.0,
      bonuses: (json['bonuses'] as num?)?.toDouble() ?? 0.0,
      tips: (json['tips'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      taxApplicable: json['taxApplicable'] as bool? ?? false,
      taxJurisdiction: json['taxJurisdiction'] as String?,
      currency: json['currency'] as String? ?? 'USD',
      metadata: json['metadata'] as Map<String, dynamic>?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CommissionToJson(Commission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commissionId': instance.commissionId,
      'rideId': instance.rideId,
      'driverId': instance.driverId,
      'rideAmount': instance.rideAmount,
      'commissionRate': instance.commissionRate,
      'commissionAmount': instance.commissionAmount,
      'driverEarnings': instance.driverEarnings,
      'status': _$CommissionStatusEnumMap[instance.status]!,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'breakdown': instance.breakdown,
      'paymentId': instance.paymentId,
      'paymentTransactionId': instance.paymentTransactionId,
      'paymentMethod': instance.paymentMethod,
      'platformFee': instance.platformFee,
      'processingFee': instance.processingFee,
      'adjustments': instance.adjustments,
      'bonuses': instance.bonuses,
      'tips': instance.tips,
      'taxAmount': instance.taxAmount,
      'taxApplicable': instance.taxApplicable,
      'taxJurisdiction': instance.taxJurisdiction,
      'currency': instance.currency,
      'metadata': instance.metadata,
      'notes': instance.notes,
    };

const _$CommissionStatusEnumMap = {
  CommissionStatus.pending: 'pending',
  CommissionStatus.calculated: 'calculated',
  CommissionStatus.approved: 'approved',
  CommissionStatus.paid: 'paid',
  CommissionStatus.disputed: 'disputed',
  CommissionStatus.cancelled: 'cancelled',
};

CommissionBreakdown _$CommissionBreakdownFromJson(Map<String, dynamic> json) =>
    CommissionBreakdown(
      id: (json['id'] as num?)?.toInt(),
      baseFareCommission:
          (json['baseFareCommission'] as num?)?.toDouble() ?? 0.0,
      distanceFareCommission:
          (json['distanceFareCommission'] as num?)?.toDouble() ?? 0.0,
      timeFareCommission:
          (json['timeFareCommission'] as num?)?.toDouble() ?? 0.0,
      surgeFareCommission:
          (json['surgeFareCommission'] as num?)?.toDouble() ?? 0.0,
      tollsCommission: (json['tollsCommission'] as num?)?.toDouble() ?? 0.0,
      feesCommission: (json['feesCommission'] as num?)?.toDouble() ?? 0.0,
      discountImpact: (json['discountImpact'] as num?)?.toDouble() ?? 0.0,
      promoImpact: (json['promoImpact'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$CommissionBreakdownToJson(
        CommissionBreakdown instance) =>
    <String, dynamic>{
      'id': instance.id,
      'baseFareCommission': instance.baseFareCommission,
      'distanceFareCommission': instance.distanceFareCommission,
      'timeFareCommission': instance.timeFareCommission,
      'surgeFareCommission': instance.surgeFareCommission,
      'tollsCommission': instance.tollsCommission,
      'feesCommission': instance.feesCommission,
      'discountImpact': instance.discountImpact,
      'promoImpact': instance.promoImpact,
    };

CommissionRule _$CommissionRuleFromJson(Map<String, dynamic> json) =>
    CommissionRule(
      id: (json['id'] as num?)?.toInt(),
      ruleId: json['ruleId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      defaultRate: (json['defaultRate'] as num).toDouble(),
      tiers: (json['tiers'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, CommissionTier.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      applicableRideTypes: (json['applicableRideTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      applicableRegions: (json['applicableRegions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
      effectiveUntil: json['effectiveUntil'] == null
          ? null
          : DateTime.parse(json['effectiveUntil'] as String),
      conditions: json['conditions'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CommissionRuleToJson(CommissionRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ruleId': instance.ruleId,
      'name': instance.name,
      'description': instance.description,
      'defaultRate': instance.defaultRate,
      'tiers': instance.tiers,
      'applicableRideTypes': instance.applicableRideTypes,
      'applicableRegions': instance.applicableRegions,
      'isActive': instance.isActive,
      'effectiveFrom': instance.effectiveFrom.toIso8601String(),
      'effectiveUntil': instance.effectiveUntil?.toIso8601String(),
      'conditions': instance.conditions,
    };

CommissionTier _$CommissionTierFromJson(Map<String, dynamic> json) =>
    CommissionTier(
      id: (json['id'] as num?)?.toInt(),
      tierName: json['tierName'] as String,
      rate: (json['rate'] as num).toDouble(),
      minimumRides: (json['minimumRides'] as num?)?.toInt(),
      minimumEarnings: (json['minimumEarnings'] as num?)?.toDouble(),
      minimumRating: (json['minimumRating'] as num?)?.toInt(),
      additionalRequirements:
          json['additionalRequirements'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CommissionTierToJson(CommissionTier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tierName': instance.tierName,
      'rate': instance.rate,
      'minimumRides': instance.minimumRides,
      'minimumEarnings': instance.minimumEarnings,
      'minimumRating': instance.minimumRating,
      'additionalRequirements': instance.additionalRequirements,
    };

CommissionPayout _$CommissionPayoutFromJson(Map<String, dynamic> json) =>
    CommissionPayout(
      id: (json['id'] as num?)?.toInt(),
      payoutId: json['payoutId'] as String,
      driverId: (json['driverId'] as num).toInt(),
      commissionIds: (json['commissionIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      totalCommissions: (json['totalCommissions'] as num).toDouble(),
      totalBonuses: (json['totalBonuses'] as num?)?.toDouble() ?? 0.0,
      totalTips: (json['totalTips'] as num?)?.toDouble() ?? 0.0,
      totalAdjustments: (json['totalAdjustments'] as num?)?.toDouble() ?? 0.0,
      totalTaxes: (json['totalTaxes'] as num?)?.toDouble() ?? 0.0,
      status: $enumDecodeNullable(_$PayoutStatusEnumMap, json['status']) ??
          PayoutStatus.pending,
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      paymentMethod: json['paymentMethod'] as String?,
      paymentTransactionId: json['paymentTransactionId'] as String?,
      failureReason: json['failureReason'] as String?,
      currency: json['currency'] as String? ?? 'USD',
      payoutMetadata: json['payoutMetadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CommissionPayoutToJson(CommissionPayout instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payoutId': instance.payoutId,
      'driverId': instance.driverId,
      'commissionIds': instance.commissionIds,
      'totalAmount': instance.totalAmount,
      'totalCommissions': instance.totalCommissions,
      'totalBonuses': instance.totalBonuses,
      'totalTips': instance.totalTips,
      'totalAdjustments': instance.totalAdjustments,
      'totalTaxes': instance.totalTaxes,
      'status': _$PayoutStatusEnumMap[instance.status]!,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'paymentMethod': instance.paymentMethod,
      'paymentTransactionId': instance.paymentTransactionId,
      'failureReason': instance.failureReason,
      'currency': instance.currency,
      'payoutMetadata': instance.payoutMetadata,
    };

const _$PayoutStatusEnumMap = {
  PayoutStatus.pending: 'pending',
  PayoutStatus.scheduled: 'scheduled',
  PayoutStatus.processing: 'processing',
  PayoutStatus.paid: 'paid',
  PayoutStatus.failed: 'failed',
  PayoutStatus.cancelled: 'cancelled',
};
