// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: (json['id'] as num?)?.toInt(),
      transactionId: json['transactionId'] as String,
      userId: (json['userId'] as num).toInt(),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      direction: $enumDecode(_$TransactionDirectionEnumMap, json['direction']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      status: $enumDecodeNullable(_$TransactionStatusEnumMap, json['status']) ??
          TransactionStatus.pending,
      description: json['description'] as String?,
      referenceId: json['referenceId'] as String?,
      referenceType: json['referenceType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      rideId: json['rideId'] as String?,
      paymentId: json['paymentId'] as String?,
      refundId: json['refundId'] as String?,
      payoutId: json['payoutId'] as String?,
      feeAmount: (json['feeAmount'] as num?)?.toDouble(),
      netAmount: (json['netAmount'] as num?)?.toDouble(),
      exchangeRate: (json['exchangeRate'] as num?)?.toDouble(),
      originalCurrency: json['originalCurrency'] as String?,
      originalAmount: (json['originalAmount'] as num?)?.toDouble(),
      paymentMethodType: $enumDecodeNullable(
          _$PaymentMethodTypeEnumMap, json['paymentMethodType']),
      paymentMethodLast4: json['paymentMethodLast4'] as String?,
      paymentMethodBrand: json['paymentMethodBrand'] as String?,
      externalTransactionId: json['externalTransactionId'] as String?,
      processorReference: json['processorReference'] as String?,
      processor:
          $enumDecodeNullable(_$PaymentProcessorTypeEnumMap, json['processor']),
      fromAccountId: json['fromAccountId'] as String?,
      toAccountId: json['toAccountId'] as String?,
      accountingCategory: json['accountingCategory'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      notes: json['notes'] as String?,
      isReconciled: json['isReconciled'] as bool? ?? false,
      reconciledAt: json['reconciledAt'] == null
          ? null
          : DateTime.parse(json['reconciledAt'] as String),
      reconciliationReference: json['reconciliationReference'] as String?,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'userId': instance.userId,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'direction': _$TransactionDirectionEnumMap[instance.direction]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'description': instance.description,
      'referenceId': instance.referenceId,
      'referenceType': instance.referenceType,
      'createdAt': instance.createdAt.toIso8601String(),
      'processedAt': instance.processedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'rideId': instance.rideId,
      'paymentId': instance.paymentId,
      'refundId': instance.refundId,
      'payoutId': instance.payoutId,
      'feeAmount': instance.feeAmount,
      'netAmount': instance.netAmount,
      'exchangeRate': instance.exchangeRate,
      'originalCurrency': instance.originalCurrency,
      'originalAmount': instance.originalAmount,
      'paymentMethodType':
          _$PaymentMethodTypeEnumMap[instance.paymentMethodType],
      'paymentMethodLast4': instance.paymentMethodLast4,
      'paymentMethodBrand': instance.paymentMethodBrand,
      'externalTransactionId': instance.externalTransactionId,
      'processorReference': instance.processorReference,
      'processor': _$PaymentProcessorTypeEnumMap[instance.processor],
      'fromAccountId': instance.fromAccountId,
      'toAccountId': instance.toAccountId,
      'accountingCategory': instance.accountingCategory,
      'metadata': instance.metadata,
      'tags': instance.tags,
      'notes': instance.notes,
      'isReconciled': instance.isReconciled,
      'reconciledAt': instance.reconciledAt?.toIso8601String(),
      'reconciliationReference': instance.reconciliationReference,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.ridePayment: 'ridePayment',
  TransactionType.refund: 'refund',
  TransactionType.tip: 'tip',
  TransactionType.bonus: 'bonus',
  TransactionType.commission: 'commission',
  TransactionType.withdrawal: 'withdrawal',
  TransactionType.topUp: 'topUp',
  TransactionType.cancellationFee: 'cancellationFee',
  TransactionType.toll: 'toll',
  TransactionType.tax: 'tax',
  TransactionType.fee: 'fee',
  TransactionType.adjustment: 'adjustment',
  TransactionType.chargeback: 'chargeback',
  TransactionType.other: 'other',
};

const _$TransactionDirectionEnumMap = {
  TransactionDirection.credit: 'credit',
  TransactionDirection.debit: 'debit',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.processing: 'processing',
  TransactionStatus.completed: 'completed',
  TransactionStatus.failed: 'failed',
  TransactionStatus.cancelled: 'cancelled',
};

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.card: 'card',
  PaymentMethodType.bankAccount: 'bankAccount',
  PaymentMethodType.digitalWallet: 'digitalWallet',
  PaymentMethodType.cash: 'cash',
  PaymentMethodType.corporate: 'corporate',
};

const _$PaymentProcessorTypeEnumMap = {
  PaymentProcessorType.stripe: 'stripe',
  PaymentProcessorType.paypal: 'paypal',
  PaymentProcessorType.square: 'square',
  PaymentProcessorType.braintree: 'braintree',
  PaymentProcessorType.other: 'other',
};

TransactionSummary _$TransactionSummaryFromJson(Map<String, dynamic> json) =>
    TransactionSummary(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num).toInt(),
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
      currency: json['currency'] as String? ?? 'USD',
      totalCredits: (json['totalCredits'] as num?)?.toDouble() ?? 0.0,
      totalDebits: (json['totalDebits'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['netAmount'] as num?)?.toDouble() ?? 0.0,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      creditsByType: (json['creditsByType'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry($enumDecode(_$TransactionTypeEnumMap, k),
                (e as num).toDouble()),
          ) ??
          const {},
      debitsByType: (json['debitsByType'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry($enumDecode(_$TransactionTypeEnumMap, k),
                (e as num).toDouble()),
          ) ??
          const {},
      countsByType: (json['countsByType'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                $enumDecode(_$TransactionTypeEnumMap, k), (e as num).toInt()),
          ) ??
          const {},
      completedTransactions:
          (json['completedTransactions'] as num?)?.toInt() ?? 0,
      pendingTransactions: (json['pendingTransactions'] as num?)?.toInt() ?? 0,
      failedTransactions: (json['failedTransactions'] as num?)?.toInt() ?? 0,
      totalFees: (json['totalFees'] as num?)?.toDouble() ?? 0.0,
      totalAdjustments: (json['totalAdjustments'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$TransactionSummaryToJson(TransactionSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
      'currency': instance.currency,
      'totalCredits': instance.totalCredits,
      'totalDebits': instance.totalDebits,
      'netAmount': instance.netAmount,
      'transactionCount': instance.transactionCount,
      'creditsByType': instance.creditsByType
          .map((k, e) => MapEntry(_$TransactionTypeEnumMap[k]!, e)),
      'debitsByType': instance.debitsByType
          .map((k, e) => MapEntry(_$TransactionTypeEnumMap[k]!, e)),
      'countsByType': instance.countsByType
          .map((k, e) => MapEntry(_$TransactionTypeEnumMap[k]!, e)),
      'completedTransactions': instance.completedTransactions,
      'pendingTransactions': instance.pendingTransactions,
      'failedTransactions': instance.failedTransactions,
      'totalFees': instance.totalFees,
      'totalAdjustments': instance.totalAdjustments,
    };

ReconciliationRecord _$ReconciliationRecordFromJson(
        Map<String, dynamic> json) =>
    ReconciliationRecord(
      id: (json['id'] as num?)?.toInt(),
      reconciliationId: json['reconciliationId'] as String,
      reconciliationDate: DateTime.parse(json['reconciliationDate'] as String),
      reconciliationType: json['reconciliationType'] as String,
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
      totalTransactions: (json['totalTransactions'] as num?)?.toInt() ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      reconciledTransactions:
          (json['reconciledTransactions'] as num?)?.toInt() ?? 0,
      reconciledAmount: (json['reconciledAmount'] as num?)?.toDouble() ?? 0.0,
      unreconciledTransactions:
          (json['unreconciledTransactions'] as num?)?.toInt() ?? 0,
      unreconciledAmount:
          (json['unreconciledAmount'] as num?)?.toDouble() ?? 0.0,
      discrepancies: (json['discrepancies'] as List<dynamic>?)
              ?.map((e) =>
                  ReconciliationDiscrepancy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status:
          $enumDecodeNullable(_$ReconciliationStatusEnumMap, json['status']) ??
              ReconciliationStatus.pending,
      notes: json['notes'] as String?,
      performedBy: (json['performedBy'] as num).toInt(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$ReconciliationRecordToJson(
        ReconciliationRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reconciliationId': instance.reconciliationId,
      'reconciliationDate': instance.reconciliationDate.toIso8601String(),
      'reconciliationType': instance.reconciliationType,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
      'totalTransactions': instance.totalTransactions,
      'totalAmount': instance.totalAmount,
      'reconciledTransactions': instance.reconciledTransactions,
      'reconciledAmount': instance.reconciledAmount,
      'unreconciledTransactions': instance.unreconciledTransactions,
      'unreconciledAmount': instance.unreconciledAmount,
      'discrepancies': instance.discrepancies,
      'status': _$ReconciliationStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'performedBy': instance.performedBy,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$ReconciliationStatusEnumMap = {
  ReconciliationStatus.pending: 'pending',
  ReconciliationStatus.inProgress: 'inProgress',
  ReconciliationStatus.completed: 'completed',
  ReconciliationStatus.failed: 'failed',
};

ReconciliationDiscrepancy _$ReconciliationDiscrepancyFromJson(
        Map<String, dynamic> json) =>
    ReconciliationDiscrepancy(
      id: (json['id'] as num?)?.toInt(),
      transactionId: json['transactionId'] as String,
      type: $enumDecode(_$DiscrepancyTypeEnumMap, json['type']),
      description: json['description'] as String,
      expectedAmount: (json['expectedAmount'] as num).toDouble(),
      actualAmount: (json['actualAmount'] as num).toDouble(),
      variance: (json['variance'] as num).toDouble(),
      status: $enumDecodeNullable(_$DiscrepancyStatusEnumMap, json['status']) ??
          DiscrepancyStatus.open,
      resolution: json['resolution'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
    );

Map<String, dynamic> _$ReconciliationDiscrepancyToJson(
        ReconciliationDiscrepancy instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'type': _$DiscrepancyTypeEnumMap[instance.type]!,
      'description': instance.description,
      'expectedAmount': instance.expectedAmount,
      'actualAmount': instance.actualAmount,
      'variance': instance.variance,
      'status': _$DiscrepancyStatusEnumMap[instance.status]!,
      'resolution': instance.resolution,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
    };

const _$DiscrepancyTypeEnumMap = {
  DiscrepancyType.amountMismatch: 'amountMismatch',
  DiscrepancyType.missingTransaction: 'missingTransaction',
  DiscrepancyType.duplicateTransaction: 'duplicateTransaction',
  DiscrepancyType.statusMismatch: 'statusMismatch',
  DiscrepancyType.other: 'other',
};

const _$DiscrepancyStatusEnumMap = {
  DiscrepancyStatus.open: 'open',
  DiscrepancyStatus.investigating: 'investigating',
  DiscrepancyStatus.resolved: 'resolved',
  DiscrepancyStatus.ignored: 'ignored',
};
