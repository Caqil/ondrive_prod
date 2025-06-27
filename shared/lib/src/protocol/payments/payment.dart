import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment extends SerializableEntity {
  @override
  int? id;

  String paymentId;
  String rideId;
  int passengerId;
  int? driverId;
  double amount; // in cents
  String currency;
  PaymentMethod paymentMethod;
  PaymentStatus status;
  String? stripePaymentIntentId;
  String? stripeChargeId;
  DateTime createdAt;
  DateTime? processedAt;
  DateTime? completedAt;
  String? failureReason;
  FareBreakdown? fareBreakdown;
  List<PaymentRefund>? refunds;
  Map<String, dynamic>? metadata;

  Payment({
    this.id,
    required this.paymentId,
    required this.rideId,
    required this.passengerId,
    this.driverId,
    required this.amount,
    this.currency = 'USD',
    required this.paymentMethod,
    this.status = PaymentStatus.pending,
    this.stripePaymentIntentId,
    this.stripeChargeId,
    required this.createdAt,
    this.processedAt,
    this.completedAt,
    this.failureReason,
    this.fareBreakdown,
    this.refunds,
    this.metadata,
  });

  double get amountInDollars => amount / 100;
  bool get isSuccessful => status == PaymentStatus.completed;
  bool get isFailed =>
      status == PaymentStatus.failed || status == PaymentStatus.cancelled;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class PaymentMethod extends SerializableEntity {
  @override
  int? id;

  String paymentMethodId;
  int userId;
  PaymentType type;
  bool isDefault;
  bool isActive;
  DateTime addedAt;
  DateTime? lastUsedAt;

  // Card details (masked)
  String? last4;
  String? brand;
  int? expMonth;
  int? expYear;
  String? fingerprint;

  // Bank details (masked)
  String? bankName;
  String? accountLast4;
  String? routingNumber;

  // Digital wallet
  String? walletProvider;
  String? walletEmail;

  PaymentMethod({
    this.id,
    required this.paymentMethodId,
    required this.userId,
    required this.type,
    this.isDefault = false,
    this.isActive = true,
    required this.addedAt,
    this.lastUsedAt,
    this.last4,
    this.brand,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.bankName,
    this.accountLast4,
    this.routingNumber,
    this.walletProvider,
    this.walletEmail,
  });

  String get displayName {
    switch (type) {
      case PaymentType.card:
        return '$brand •••• $last4';
      case PaymentType.bankAccount:
        return '$bankName •••• $accountLast4';
      case PaymentType.digitalWallet:
        return '$walletProvider ($walletEmail)';
      case PaymentType.cash:
        return 'Cash';
      case PaymentType.corporate:
        return 'Corporate Account';
    }
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}

@JsonSerializable()
class FareBreakdown extends SerializableEntity {
  @override
  int? id;

  double baseFare;
  double distanceFare;
  double timeFare;
  double surgeFare;
  double tips;
  double tolls;
  double taxes;
  double discounts;
  double promoDiscount;
  double loyaltyDiscount;
  double subtotal;
  double totalFare;
  String currency;
  double? surgeMultiplier;
  List<FareComponent>? additionalComponents;

  FareBreakdown({
    this.id,
    required this.baseFare,
    required this.distanceFare,
    required this.timeFare,
    this.surgeFare = 0.0,
    this.tips = 0.0,
    this.tolls = 0.0,
    this.taxes = 0.0,
    this.discounts = 0.0,
    this.promoDiscount = 0.0,
    this.loyaltyDiscount = 0.0,
    required this.subtotal,
    required this.totalFare,
    this.currency = 'USD',
    this.surgeMultiplier,
    this.additionalComponents,
  });

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
  double amount;
  ComponentType type;

  FareComponent({
    this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.type,
  });

  factory FareComponent.fromJson(Map<String, dynamic> json) =>
      _$FareComponentFromJson(json);
  Map<String, dynamic> toJson() => _$FareComponentToJson(this);
}

@JsonSerializable()
class PaymentRefund extends SerializableEntity {
  @override
  int? id;

  String refundId;
  String paymentId;
  double amount;
  String currency;
  RefundReason reason;
  RefundStatus status;
  DateTime requestedAt;
  DateTime? processedAt;
  String? stripeRefundId;
  String? notes;
  int? processedBy;

  PaymentRefund({
    this.id,
    required this.refundId,
    required this.paymentId,
    required this.amount,
    this.currency = 'USD',
    required this.reason,
    this.status = RefundStatus.pending,
    required this.requestedAt,
    this.processedAt,
    this.stripeRefundId,
    this.notes,
    this.processedBy,
  });

  double get amountInDollars => amount / 100;

  factory PaymentRefund.fromJson(Map<String, dynamic> json) =>
      _$PaymentRefundFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRefundToJson(this);
}

@JsonSerializable()
class Transaction extends SerializableEntity {
  @override
  int? id;

  String transactionId;
  int userId;
  TransactionType type;
  double amount;
  String currency;
  TransactionStatus status;
  String? description;
  String? referenceId; // rideId, paymentId, etc.
  DateTime createdAt;
  DateTime? processedAt;
  Map<String, dynamic>? metadata;

  Transaction({
    this.id,
    required this.transactionId,
    required this.userId,
    required this.type,
    required this.amount,
    this.currency = 'USD',
    this.status = TransactionStatus.pending,
    this.description,
    this.referenceId,
    required this.createdAt,
    this.processedAt,
    this.metadata,
  });

  double get amountInDollars => amount / 100;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class Commission extends SerializableEntity {
  @override
  int? id;

  String rideId;
  int driverId;
  double rideAmount;
  double commissionRate; // percentage
  double commissionAmount;
  double driverEarnings;
  CommissionStatus status;
  DateTime calculatedAt;
  DateTime? paidAt;

  Commission({
    this.id,
    required this.rideId,
    required this.driverId,
    required this.rideAmount,
    required this.commissionRate,
    required this.commissionAmount,
    required this.driverEarnings,
    this.status = CommissionStatus.pending,
    required this.calculatedAt,
    this.paidAt,
  });

  factory Commission.fromJson(Map<String, dynamic> json) =>
      _$CommissionFromJson(json);
  Map<String, dynamic> toJson() => _$CommissionToJson(this);
}

enum PaymentType {
  card,
  bankAccount,
  digitalWallet,
  cash,
  corporate,
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
  partiallyRefunded,
}

enum RefundReason {
  userRequested,
  rideCancelled,
  driverCancelled,
  systemError,
  disputeResolution,
  other,
}

enum RefundStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

enum TransactionType {
  ridePayment,
  refund,
  tip,
  bonus,
  commission,
  withdrawal,
  topUp,
  other,
}

enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

enum ComponentType {
  fee,
  discount,
  tax,
  tip,
  other,
}

enum CommissionStatus {
  pending,
  calculated,
  paid,
  disputed,
}
