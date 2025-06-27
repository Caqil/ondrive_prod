import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import 'payment.dart';
import 'payment_status.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction extends SerializableEntity {
  @override
  int? id;

  String transactionId;
  int userId;
  TransactionType type;
  TransactionDirection direction;
  double amount; // in cents
  String currency;
  TransactionStatus status;
  String? description;
  String? referenceId; // rideId, paymentId, etc.
  String? referenceType; // 'ride', 'payment', 'refund', etc.
  DateTime createdAt;
  DateTime? processedAt;
  DateTime? completedAt;

  // Related entities
  String? rideId;
  String? paymentId;
  String? refundId;
  String? payoutId;

  // Financial details
  double? feeAmount; // Processing fees in cents
  double? netAmount; // Amount after fees in cents
  double? exchangeRate; // If currency conversion is involved
  String? originalCurrency;
  double? originalAmount;

  // Payment method information
  PaymentType? paymentMethodType;
  String? paymentMethodLast4;
  String? paymentMethodBrand;

  // External system references
  String? externalTransactionId;
  String? processorReference;
  PaymentProcessorType? processor;

  // Account information
  String? fromAccountId;
  String? toAccountId;
  String? accountingCategory;

  // Metadata and tags
  Map<String, dynamic>? metadata;
  List<String>? tags;
  String? notes;

  // Reconciliation
  bool isReconciled;
  DateTime? reconciledAt;
  String? reconciliationReference;

  Transaction({
    this.id,
    required this.transactionId,
    required this.userId,
    required this.type,
    required this.direction,
    required this.amount,
    this.currency = 'USD',
    this.status = TransactionStatus.pending,
    this.description,
    this.referenceId,
    this.referenceType,
    required this.createdAt,
    this.processedAt,
    this.completedAt,
    this.rideId,
    this.paymentId,
    this.refundId,
    this.payoutId,
    this.feeAmount,
    this.netAmount,
    this.exchangeRate,
    this.originalCurrency,
    this.originalAmount,
    this.paymentMethodType,
    this.paymentMethodLast4,
    this.paymentMethodBrand,
    this.externalTransactionId,
    this.processorReference,
    this.processor,
    this.fromAccountId,
    this.toAccountId,
    this.accountingCategory,
    this.metadata,
    this.tags,
    this.notes,
    this.isReconciled = false,
    this.reconciledAt,
    this.reconciliationReference,
  });

  // Convert amounts to dollars
  double get amountDollars => amount / 100;
  double? get feeAmountDollars => feeAmount != null ? feeAmount! / 100 : null;
  double? get netAmountDollars => netAmount != null ? netAmount! / 100 : null;

  // Check transaction status
  bool get isCompleted => status == TransactionStatus.completed;
  bool get isPending => status == TransactionStatus.pending;
  bool get hasFailed => status == TransactionStatus.failed;
  bool get isCancelled => status == TransactionStatus.cancelled;

  // Check if transaction is a credit (money in)
  bool get isCredit => direction == TransactionDirection.credit;

  // Check if transaction is a debit (money out)
  bool get isDebit => direction == TransactionDirection.debit;

  // Get formatted amount with currency
  String get formattedAmount {
    final sign = isDebit ? '-' : '+';
    return '$sign\${amountDollars.toStringAsFixed(2)} $currency';
  }

  // Get user-friendly type description
  String get typeDescription {
    switch (type) {
      case TransactionType.ridePayment:
        return 'Ride Payment';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.tip:
        return 'Tip';
      case TransactionType.bonus:
        return 'Bonus';
      case TransactionType.commission:
        return 'Commission';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.topUp:
        return 'Top Up';
      case TransactionType.cancellationFee:
        return 'Cancellation Fee';
      case TransactionType.toll:
        return 'Toll';
      case TransactionType.tax:
        return 'Tax';
      case TransactionType.fee:
        return 'Fee';
      case TransactionType.adjustment:
        return 'Adjustment';
      case TransactionType.chargeback:
        return 'Chargeback';
      case TransactionType.other:
        return 'Other';
    }
  }

  // Get processing duration
  Duration? get processingDuration {
    if (processedAt == null) return null;
    return processedAt!.difference(createdAt);
  }

  // Get completion duration
  Duration? get completionDuration {
    if (completedAt == null) return null;
    return completedAt!.difference(createdAt);
  }

  // Create a related transaction (e.g., refund)
  Transaction createRelatedTransaction({
    required TransactionType type,
    required TransactionDirection direction,
    required double amount,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      type: type,
      direction: direction,
      amount: amount,
      currency: currency,
      description: description,
      referenceId: transactionId, // Reference to this transaction
      referenceType: 'transaction',
      createdAt: DateTime.now(),
      rideId: rideId,
      paymentId: paymentId,
      processor: processor,
      fromAccountId:
          direction == TransactionDirection.debit ? fromAccountId : toAccountId,
      toAccountId:
          direction == TransactionDirection.debit ? toAccountId : fromAccountId,
      metadata: metadata,
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class TransactionSummary extends SerializableEntity {
  @override
  int? id;

  int userId;
  DateTime periodStart;
  DateTime periodEnd;
  String currency;

  // Summary totals
  double totalCredits; // in cents
  double totalDebits; // in cents
  double netAmount; // in cents
  int transactionCount;

  // By transaction type
  Map<TransactionType, double> creditsByType;
  Map<TransactionType, double> debitsByType;
  Map<TransactionType, int> countsByType;

  // By status
  int completedTransactions;
  int pendingTransactions;
  int failedTransactions;

  // Fees and adjustments
  double totalFees; // in cents
  double totalAdjustments; // in cents

  TransactionSummary({
    this.id,
    required this.userId,
    required this.periodStart,
    required this.periodEnd,
    this.currency = 'USD',
    this.totalCredits = 0.0,
    this.totalDebits = 0.0,
    this.netAmount = 0.0,
    this.transactionCount = 0,
    this.creditsByType = const {},
    this.debitsByType = const {},
    this.countsByType = const {},
    this.completedTransactions = 0,
    this.pendingTransactions = 0,
    this.failedTransactions = 0,
    this.totalFees = 0.0,
    this.totalAdjustments = 0.0,
  });

  // Convert amounts to dollars
  double get totalCreditsDollars => totalCredits / 100;
  double get totalDebitsDollars => totalDebits / 100;
  double get netAmountDollars => netAmount / 100;
  double get totalFeesDollars => totalFees / 100;

  // Calculate averages
  double get averageTransactionAmount {
    return transactionCount > 0
        ? (totalCredits + totalDebits) / transactionCount / 100
        : 0.0;
  }

  double get averageCredit {
    final creditCount =
        countsByType.values.fold(0, (sum, count) => sum + count);
    return creditCount > 0 ? totalCredits / creditCount / 100 : 0.0;
  }

  factory TransactionSummary.fromJson(Map<String, dynamic> json) =>
      _$TransactionSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionSummaryToJson(this);
}

@JsonSerializable()
class ReconciliationRecord extends SerializableEntity {
  @override
  int? id;

  String reconciliationId;
  DateTime reconciliationDate;
  String reconciliationType; // 'daily', 'monthly', 'manual'
  DateTime periodStart;
  DateTime periodEnd;

  // Summary figures
  int totalTransactions;
  double totalAmount; // in cents
  int reconciledTransactions;
  double reconciledAmount; // in cents
  int unreconciledTransactions;
  double unreconciledAmount; // in cents

  // Discrepancies
  List<ReconciliationDiscrepancy> discrepancies;

  // Status
  ReconciliationStatus status;
  String? notes;
  int performedBy;
  DateTime? completedAt;

  ReconciliationRecord({
    this.id,
    required this.reconciliationId,
    required this.reconciliationDate,
    required this.reconciliationType,
    required this.periodStart,
    required this.periodEnd,
    this.totalTransactions = 0,
    this.totalAmount = 0.0,
    this.reconciledTransactions = 0,
    this.reconciledAmount = 0.0,
    this.unreconciledTransactions = 0,
    this.unreconciledAmount = 0.0,
    this.discrepancies = const [],
    this.status = ReconciliationStatus.pending,
    this.notes,
    required this.performedBy,
    this.completedAt,
  });

  double get reconciliationRate {
    return totalTransactions > 0
        ? (reconciledTransactions / totalTransactions) * 100
        : 0.0;
  }

  bool get hasDiscrepancies => discrepancies.isNotEmpty;

  factory ReconciliationRecord.fromJson(Map<String, dynamic> json) =>
      _$ReconciliationRecordFromJson(json);
  Map<String, dynamic> toJson() => _$ReconciliationRecordToJson(this);
}

@JsonSerializable()
class ReconciliationDiscrepancy extends SerializableEntity {
  @override
  int? id;

  String transactionId;
  DiscrepancyType type;
  String description;
  double expectedAmount; // in cents
  double actualAmount; // in cents
  double variance; // in cents
  DiscrepancyStatus status;
  String? resolution;
  DateTime? resolvedAt;

  ReconciliationDiscrepancy({
    this.id,
    required this.transactionId,
    required this.type,
    required this.description,
    required this.expectedAmount,
    required this.actualAmount,
    required this.variance,
    this.status = DiscrepancyStatus.open,
    this.resolution,
    this.resolvedAt,
  });

  double get varianceDollars => variance / 100;
  bool get isResolved => status == DiscrepancyStatus.resolved;

  factory ReconciliationDiscrepancy.fromJson(Map<String, dynamic> json) =>
      _$ReconciliationDiscrepancyFromJson(json);
  Map<String, dynamic> toJson() => _$ReconciliationDiscrepancyToJson(this);
}

enum TransactionType {
  ridePayment,
  refund,
  tip,
  bonus,
  commission,
  withdrawal,
  topUp,
  cancellationFee,
  toll,
  tax,
  fee,
  adjustment,
  chargeback,
  other,
}

enum TransactionDirection {
  credit, // Money in
  debit, // Money out
}

enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

enum ReconciliationStatus {
  pending,
  inProgress,
  completed,
  failed,
}

enum DiscrepancyType {
  amountMismatch,
  missingTransaction,
  duplicateTransaction,
  statusMismatch,
  other,
}

enum DiscrepancyStatus {
  open,
  investigating,
  resolved,
  ignored,
}
