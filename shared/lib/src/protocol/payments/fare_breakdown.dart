import 'dart:math' as math;

import 'package:ride_hailing_shared/src/protocol/rides/ride_type.dart';
import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../rides/ride.dart';

part 'fare_breakdown.g.dart';

@JsonSerializable()
class FareBreakdown extends SerializableEntity {
  @override
  int? id;

  String rideId;

  // Base fare components (all amounts in cents)
  double baseFare;
  double distanceFare;
  double timeFare;
  double waitingTimeFare;

  // Dynamic pricing
  double surgeFare;
  double? surgeMultiplier;
  String? surgeReason;

  // Additional charges
  double tolls;
  double airportFee;
  double cleaningFee;
  double cancellationFee;
  double tips;

  // Taxes and fees
  double taxes;
  double serviceFee;
  double processingFee;
  double regulatoryFee;

  // Discounts and promotions
  double discounts;
  double promoDiscount;
  double loyaltyDiscount;
  double couponDiscount;
  double referralDiscount;

  // Totals
  double subtotal;
  double totalFare;
  double totalDiscount;
  double totalTax;
  double totalFees;

  // Metadata
  String currency;
  DateTime calculatedAt;
  String? calculationVersion;
  Map<String, dynamic>? calculationMetadata;

  // Additional components for complex fare structures
  List<FareComponent>? additionalComponents;

  FareBreakdown({
    this.id,
    required this.rideId,
    required this.baseFare,
    required this.distanceFare,
    required this.timeFare,
    this.waitingTimeFare = 0.0,
    this.surgeFare = 0.0,
    this.surgeMultiplier,
    this.surgeReason,
    this.tolls = 0.0,
    this.airportFee = 0.0,
    this.cleaningFee = 0.0,
    this.cancellationFee = 0.0,
    this.tips = 0.0,
    this.taxes = 0.0,
    this.serviceFee = 0.0,
    this.processingFee = 0.0,
    this.regulatoryFee = 0.0,
    this.discounts = 0.0,
    this.promoDiscount = 0.0,
    this.loyaltyDiscount = 0.0,
    this.couponDiscount = 0.0,
    this.referralDiscount = 0.0,
    required this.subtotal,
    required this.totalFare,
    required this.totalDiscount,
    required this.totalTax,
    required this.totalFees,
    this.currency = 'USD',
    required this.calculatedAt,
    this.calculationVersion,
    this.calculationMetadata,
    this.additionalComponents,
  });

  // Convert all amounts to dollars for display
  double get baseFareDollars => baseFare / 100;
  double get distanceFareDollars => distanceFare / 100;
  double get timeFareDollars => timeFare / 100;
  double get surgeFareDollars => surgeFare / 100;
  double get totalFareDollars => totalFare / 100;
  double get totalDiscountDollars => totalDiscount / 100;
  double get tipsDollars => tips / 100;

  // Calculate ride fare before surge
  double get baseTotalFare {
    return baseFare + distanceFare + timeFare + waitingTimeFare;
  }

  // Calculate all additional fees
  double get additionalFees {
    return tolls + airportFee + cleaningFee + cancellationFee;
  }

  // Calculate all service fees
  double get allServiceFees {
    return serviceFee + processingFee + regulatoryFee;
  }

  // Calculate total before discounts
  double get totalBeforeDiscounts {
    return baseTotalFare + surgeFare + additionalFees + allServiceFees + taxes;
  }

  // Validate that calculations are correct
  bool get isCalculationValid {
    final calculatedTotal = totalBeforeDiscounts - totalDiscount + tips;
    return (calculatedTotal - totalFare).abs() < 1; // Within 1 cent
  }

  // Get breakdown as a list of line items for display
  List<FareLineItem> getLineItems() {
    final items = <FareLineItem>[];

    // Base components
    if (baseFare > 0) {
      items.add(FareLineItem(
        name: 'Base Fare',
        amount: baseFare,
        type: FareLineItemType.baseFare,
      ));
    }

    if (distanceFare > 0) {
      items.add(FareLineItem(
        name: 'Distance',
        amount: distanceFare,
        type: FareLineItemType.distance,
      ));
    }

    if (timeFare > 0) {
      items.add(FareLineItem(
        name: 'Time',
        amount: timeFare,
        type: FareLineItemType.time,
      ));
    }

    if (waitingTimeFare > 0) {
      items.add(FareLineItem(
        name: 'Waiting Time',
        amount: waitingTimeFare,
        type: FareLineItemType.waitingTime,
      ));
    }

    // Surge pricing
    if (surgeFare > 0) {
      items.add(FareLineItem(
        name:
            'Surge Pricing${surgeMultiplier != null ? ' (${surgeMultiplier}x)' : ''}',
        amount: surgeFare,
        type: FareLineItemType.surge,
      ));
    }

    // Additional fees
    if (tolls > 0) {
      items.add(FareLineItem(
        name: 'Tolls',
        amount: tolls,
        type: FareLineItemType.tolls,
      ));
    }

    if (airportFee > 0) {
      items.add(FareLineItem(
        name: 'Airport Fee',
        amount: airportFee,
        type: FareLineItemType.airportFee,
      ));
    }

    // Taxes and service fees
    if (taxes > 0) {
      items.add(FareLineItem(
        name: 'Taxes',
        amount: taxes,
        type: FareLineItemType.tax,
      ));
    }

    if (serviceFee > 0) {
      items.add(FareLineItem(
        name: 'Service Fee',
        amount: serviceFee,
        type: FareLineItemType.serviceFee,
      ));
    }

    // Discounts (negative amounts)
    if (promoDiscount > 0) {
      items.add(FareLineItem(
        name: 'Promotion Discount',
        amount: -promoDiscount,
        type: FareLineItemType.discount,
      ));
    }

    if (loyaltyDiscount > 0) {
      items.add(FareLineItem(
        name: 'Loyalty Discount',
        amount: -loyaltyDiscount,
        type: FareLineItemType.discount,
      ));
    }

    // Tips
    if (tips > 0) {
      items.add(FareLineItem(
        name: 'Tip',
        amount: tips,
        type: FareLineItemType.tip,
      ));
    }

    // Additional components
    if (additionalComponents != null) {
      for (final component in additionalComponents!) {
        items.add(FareLineItem(
          name: component.name,
          amount: component.amount,
          type: _mapComponentTypeToLineItemType(component.type),
          description: component.description,
        ));
      }
    }

    return items;
  }

  FareLineItemType _mapComponentTypeToLineItemType(ComponentType type) {
    switch (type) {
      case ComponentType.fee:
        return FareLineItemType.fee;
      case ComponentType.discount:
        return FareLineItemType.discount;
      case ComponentType.tax:
        return FareLineItemType.tax;
      case ComponentType.tip:
        return FareLineItemType.tip;
      case ComponentType.other:
        return FareLineItemType.other;
      case ComponentType.surge:
        return FareLineItemType.surge;
    }
  }

  factory FareBreakdown.fromJson(Map<String, dynamic> json) =>
      _$FareBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$FareBreakdownToJson(this);
}

@JsonSerializable()
class FareComponent extends SerializableEntity {
  @override
  int? id;

  String name;
  String description;
  double amount; // in cents
  ComponentType type;
  bool isRefundable;
  Map<String, dynamic>? componentMetadata;

  FareComponent({
    this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.type,
    this.isRefundable = true,
    this.componentMetadata,
  });

  double get amountDollars => amount / 100;

  factory FareComponent.fromJson(Map<String, dynamic> json) =>
      _$FareComponentFromJson(json);
  Map<String, dynamic> toJson() => _$FareComponentToJson(this);
}

@JsonSerializable()
class FareLineItem extends SerializableEntity {
  @override
  int? id;

  String name;
  double amount; // in cents
  FareLineItemType type;
  String? description;
  Map<String, dynamic>? itemMetadata;

  FareLineItem({
    this.id,
    required this.name,
    required this.amount,
    required this.type,
    this.description,
    this.itemMetadata,
  });

  double get amountDollars => amount / 100;
  bool get isDiscount => amount < 0;
  bool get isCharge => amount > 0;

  String get formattedAmount {
    final dollars = amountDollars.abs();
    final sign = amount < 0 ? '-' : '';
    return '$sign\$${dollars.toStringAsFixed(2)}';
  }

  factory FareLineItem.fromJson(Map<String, dynamic> json) =>
      _$FareLineItemFromJson(json);
  Map<String, dynamic> toJson() => _$FareLineItemToJson(this);
}

@JsonSerializable()
class FareCalculationRule extends SerializableEntity {
  @override
  int? id;

  String ruleId;
  String name;
  String? description;
  RideType applicableRideType;
  String? applicableRegion;

  // Base fare structure
  double baseAmount; // Fixed base fare in cents
  double perKmRate; // Rate per kilometer in cents
  double perMinuteRate; // Rate per minute in cents
  double perKmMinimum; // Minimum distance charge
  double perMinuteMinimum; // Minimum time charge

  // Surge pricing rules
  bool surgePricingEnabled;
  double maxSurgeMultiplier;
  Map<String, double>? surgeTimeRules; // Hour -> multiplier

  // Additional fees
  double cancellationFeeAmount;
  int cancellationFeeGracePeriod; // minutes
  double airportFeeAmount;
  double tollPassthroughRate; // percentage

  // Tax configuration
  double taxRate; // percentage
  bool taxIncluded; // whether tax is included in base rates

  bool isActive;
  DateTime effectiveFrom;
  DateTime? effectiveUntil;

  FareCalculationRule({
    this.id,
    required this.ruleId,
    required this.name,
    this.description,
    required this.applicableRideType,
    this.applicableRegion,
    required this.baseAmount,
    required this.perKmRate,
    required this.perMinuteRate,
    this.perKmMinimum = 0.0,
    this.perMinuteMinimum = 0.0,
    this.surgePricingEnabled = true,
    this.maxSurgeMultiplier = 3.0,
    this.surgeTimeRules,
    this.cancellationFeeAmount = 0.0,
    this.cancellationFeeGracePeriod = 5,
    this.airportFeeAmount = 0.0,
    this.tollPassthroughRate = 100.0,
    this.taxRate = 0.0,
    this.taxIncluded = false,
    this.isActive = true,
    required this.effectiveFrom,
    this.effectiveUntil,
  });

  // Calculate estimated fare
  double calculateEstimatedFare(double distanceKm, int durationMinutes) {
    double fare = baseAmount;
    fare += math.max(distanceKm * perKmRate, perKmMinimum);
    fare += math.max(durationMinutes * perMinuteRate, perMinuteMinimum);

    if (!taxIncluded && taxRate > 0) {
      fare *= (1 + taxRate / 100);
    }

    return fare;
  }

  factory FareCalculationRule.fromJson(Map<String, dynamic> json) =>
      _$FareCalculationRuleFromJson(json);
  Map<String, dynamic> toJson() => _$FareCalculationRuleToJson(this);
}

enum ComponentType {
  fee,
  discount,
  tax,
  tip,
  surge,
  other,
}

enum FareLineItemType {
  baseFare,
  distance,
  time,
  waitingTime,
  surge,
  tolls,
  airportFee,
  tax,
  serviceFee,
  discount,
  tip,
  fee,
  other,
}
