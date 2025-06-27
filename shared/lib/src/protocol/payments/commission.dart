import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import 'payment_method.dart';

part 'commission.g.dart';

@JsonSerializable()
class Commission extends SerializableEntity {
  @override
  int? id;

  String commissionId;
  String rideId;
  int driverId;
  double rideAmount; // Total ride fare in cents
  double commissionRate; // Percentage (e.g., 12.5 for 12.5%)
  double commissionAmount; // Commission amount in cents
  double driverEarnings; // Driver earnings after commission in cents
  CommissionStatus status;
  DateTime calculatedAt;
  DateTime? paidAt;
  DateTime? dueDate;

  // Commission breakdown
  CommissionBreakdown? breakdown;

  // Payment tracking
  String? paymentId;
  String? paymentTransactionId;
  PaymentMethod? paymentMethod;

  // Additional fees and adjustments
  double platformFee; // Additional platform fees in cents
  double processingFee; // Payment processing fees in cents
  double adjustments; // Manual adjustments (positive or negative) in cents
  double bonuses; // Driver bonuses in cents
  double tips; // Tips from passengers in cents

  // Tax and compliance
  double taxAmount; // Tax withheld in cents
  bool taxApplicable;
  String? taxJurisdiction;

  // Metadata
  String currency;
  Map<String, dynamic>? metadata;
  String? notes;

  Commission({
    this.id,
    required this.commissionId,
    required this.rideId,
    required this.driverId,
    required this.rideAmount,
    required this.commissionRate,
    required this.commissionAmount,
    required this.driverEarnings,
    this.status = CommissionStatus.pending,
    required this.calculatedAt,
    this.paidAt,
    this.dueDate,
    this.breakdown,
    this.paymentId,
    this.paymentTransactionId,
    this.paymentMethod,
    this.platformFee = 0.0,
    this.processingFee = 0.0,
    this.adjustments = 0.0,
    this.bonuses = 0.0,
    this.tips = 0.0,
    this.taxAmount = 0.0,
    this.taxApplicable = false,
    this.taxJurisdiction,
    this.currency = 'USD',
    this.metadata,
    this.notes,
  });

  // Calculate total driver payout
  double get totalDriverPayout {
    return driverEarnings + bonuses + tips + adjustments - taxAmount;
  }

  // Calculate net commission (commission minus processing fees)
  double get netCommission {
    return commissionAmount - processingFee;
  }

  // Get commission rate as decimal (e.g., 0.125 for 12.5%)
  double get commissionRateDecimal {
    return commissionRate / 100;
  }

  // Convert amounts from cents to dollars
  double get rideAmountDollars => rideAmount / 100;
  double get commissionAmountDollars => commissionAmount / 100;
  double get driverEarningsDollars => driverEarnings / 100;
  double get totalDriverPayoutDollars => totalDriverPayout / 100;

  // Check if commission is overdue
  bool get isOverdue {
    return dueDate != null &&
        DateTime.now().isAfter(dueDate!) &&
        status != CommissionStatus.paid;
  }

  // Calculate days until due
  int? get daysUntilDue {
    if (dueDate == null) return null;
    final difference = dueDate!.difference(DateTime.now()).inDays;
    return difference < 0 ? 0 : difference;
  }

  // Validate commission calculation
  bool get isCalculationValid {
    final expectedCommission = rideAmount * commissionRateDecimal;
    final expectedDriverEarnings = rideAmount - expectedCommission;

    return (commissionAmount - expectedCommission).abs() < 1 && // Within 1 cent
        (driverEarnings - expectedDriverEarnings).abs() < 1;
  }

  factory Commission.fromJson(Map<String, dynamic> json) =>
      _$CommissionFromJson(json);
  Map<String, dynamic> toJson() => _$CommissionToJson(this);
}

@JsonSerializable()
class CommissionBreakdown extends SerializableEntity {
  @override
  int? id;

  double baseFareCommission;
  double distanceFareCommission;
  double timeFareCommission;
  double surgeFareCommission;
  double tollsCommission;
  double feesCommission;
  double discountImpact; // How discounts affect commission
  double promoImpact; // How promos affect commission

  CommissionBreakdown({
    this.id,
    this.baseFareCommission = 0.0,
    this.distanceFareCommission = 0.0,
    this.timeFareCommission = 0.0,
    this.surgeFareCommission = 0.0,
    this.tollsCommission = 0.0,
    this.feesCommission = 0.0,
    this.discountImpact = 0.0,
    this.promoImpact = 0.0,
  });

  double get totalCommission {
    return baseFareCommission +
        distanceFareCommission +
        timeFareCommission +
        surgeFareCommission +
        tollsCommission +
        feesCommission +
        discountImpact +
        promoImpact;
  }

  factory CommissionBreakdown.fromJson(Map<String, dynamic> json) =>
      _$CommissionBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$CommissionBreakdownToJson(this);
}

@JsonSerializable()
class CommissionRule extends SerializableEntity {
  @override
  int? id;

  String ruleId;
  String name;
  String? description;
  double defaultRate; // Default commission rate percentage
  Map<String, CommissionTier> tiers; // Volume-based tiers
  List<String> applicableRideTypes;
  List<String> applicableRegions;
  bool isActive;
  DateTime effectiveFrom;
  DateTime? effectiveUntil;
  Map<String, dynamic>? conditions;

  CommissionRule({
    this.id,
    required this.ruleId,
    required this.name,
    this.description,
    required this.defaultRate,
    this.tiers = const {},
    this.applicableRideTypes = const [],
    this.applicableRegions = const [],
    this.isActive = true,
    required this.effectiveFrom,
    this.effectiveUntil,
    this.conditions,
  });

  // Calculate commission rate for a driver based on their volume
  double calculateRateForDriver(
      int driverRidesThisMonth, double driverEarningsThisMonth) {
    if (tiers.isEmpty) return defaultRate;

    // Find applicable tier based on rides or earnings
    CommissionTier? applicableTier;
    for (final tier in tiers.values) {
      if (tier.meetsRequirements(
          driverRidesThisMonth, driverEarningsThisMonth)) {
        if (applicableTier == null || tier.rate < applicableTier.rate) {
          applicableTier = tier;
        }
      }
    }

    return applicableTier?.rate ?? defaultRate;
  }

  // Check if rule applies to specific ride
  bool appliesTo(String rideType, String region) {
    if (applicableRideTypes.isNotEmpty &&
        !applicableRideTypes.contains(rideType)) {
      return false;
    }
    if (applicableRegions.isNotEmpty && !applicableRegions.contains(region)) {
      return false;
    }
    return true;
  }

  factory CommissionRule.fromJson(Map<String, dynamic> json) =>
      _$CommissionRuleFromJson(json);
  Map<String, dynamic> toJson() => _$CommissionRuleToJson(this);
}

@JsonSerializable()
class CommissionTier extends SerializableEntity {
  @override
  int? id;

  String tierName;
  double rate; // Commission rate for this tier
  int? minimumRides; // Minimum rides per month
  double? minimumEarnings; // Minimum earnings per month (in cents)
  int? minimumRating; // Minimum rating (1-5 stars * 100)
  Map<String, dynamic>? additionalRequirements;

  CommissionTier({
    this.id,
    required this.tierName,
    required this.rate,
    this.minimumRides,
    this.minimumEarnings,
    this.minimumRating,
    this.additionalRequirements,
  });

  bool meetsRequirements(int rides, double earnings) {
    if (minimumRides != null && rides < minimumRides!) return false;
    if (minimumEarnings != null && earnings < minimumEarnings!) return false;
    // Rating check would need to be passed in separately
    return true;
  }

  factory CommissionTier.fromJson(Map<String, dynamic> json) =>
      _$CommissionTierFromJson(json);
  Map<String, dynamic> toJson() => _$CommissionTierToJson(this);
}

@JsonSerializable()
class CommissionPayout extends SerializableEntity {
  @override
  int? id;

  String payoutId;
  int driverId;
  List<String> commissionIds; // List of commission IDs included in this payout
  double totalAmount; // Total payout amount in cents
  double totalCommissions; // Total commissions in cents
  double totalBonuses; // Total bonuses in cents
  double totalTips; // Total tips in cents
  double totalAdjustments; // Total adjustments in cents
  double totalTaxes; // Total taxes withheld in cents
  PayoutStatus status;
  DateTime calculatedAt;
  DateTime? scheduledAt;
  DateTime? paidAt;
  String? paymentMethod;
  String? paymentTransactionId;
  String? failureReason;
  String currency;
  Map<String, dynamic>? payoutMetadata;

  CommissionPayout({
    this.id,
    required this.payoutId,
    required this.driverId,
    required this.commissionIds,
    required this.totalAmount,
    required this.totalCommissions,
    this.totalBonuses = 0.0,
    this.totalTips = 0.0,
    this.totalAdjustments = 0.0,
    this.totalTaxes = 0.0,
    this.status = PayoutStatus.pending,
    required this.calculatedAt,
    this.scheduledAt,
    this.paidAt,
    this.paymentMethod,
    this.paymentTransactionId,
    this.failureReason,
    this.currency = 'USD',
    this.payoutMetadata,
  });

  double get totalAmountDollars => totalAmount / 100;
  int get commissionCount => commissionIds.length;

  factory CommissionPayout.fromJson(Map<String, dynamic> json) =>
      _$CommissionPayoutFromJson(json);
  Map<String, dynamic> toJson() => _$CommissionPayoutToJson(this);
}

enum CommissionStatus {
  pending,
  calculated,
  approved,
  paid,
  disputed,
  cancelled,
}

enum PayoutStatus {
  pending,
  scheduled,
  processing,
  paid,
  failed,
  cancelled,
}
