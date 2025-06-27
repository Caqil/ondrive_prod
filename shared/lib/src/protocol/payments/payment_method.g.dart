// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: (json['id'] as num?)?.toInt(),
      paymentMethodId: json['paymentMethodId'] as String,
      userId: (json['userId'] as num).toInt(),
      type: $enumDecode(_$PaymentMethodTypeEnumMap, json['type']),
      isDefault: json['isDefault'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      addedAt: DateTime.parse(json['addedAt'] as String),
      lastUsedAt: json['lastUsedAt'] == null
          ? null
          : DateTime.parse(json['lastUsedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      last4: json['last4'] as String?,
      brand: json['brand'] as String?,
      expMonth: (json['expMonth'] as num?)?.toInt(),
      expYear: (json['expYear'] as num?)?.toInt(),
      fingerprint: json['fingerprint'] as String?,
      country: json['country'] as String?,
      funding: $enumDecodeNullable(_$CardFundingEnumMap, json['funding']),
      bankName: json['bankName'] as String?,
      accountLast4: json['accountLast4'] as String?,
      routingNumber: json['routingNumber'] as String?,
      accountType:
          $enumDecodeNullable(_$BankAccountTypeEnumMap, json['accountType']),
      accountHolderName: json['accountHolderName'] as String?,
      walletProvider: json['walletProvider'] as String?,
      walletEmail: json['walletEmail'] as String?,
      walletAccountId: json['walletAccountId'] as String?,
      companyName: json['companyName'] as String?,
      billingDepartment: json['billingDepartment'] as String?,
      purchaseOrderNumber: json['purchaseOrderNumber'] as String?,
      stripePaymentMethodId: json['stripePaymentMethodId'] as String?,
      stripeCustomerId: json['stripeCustomerId'] as String?,
      stripeMetadata: json['stripeMetadata'] as Map<String, dynamic>?,
      isVerified: json['isVerified'] as bool? ?? false,
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      verificationMethod: json['verificationMethod'] as String?,
      securityChecks: (json['securityChecks'] as List<dynamic>?)
          ?.map((e) => PaymentMethodCheck.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyLimit: (json['dailyLimit'] as num?)?.toDouble(),
      monthlyLimit: (json['monthlyLimit'] as num?)?.toDouble(),
      allowedMerchants: (json['allowedMerchants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      blockedMerchants: (json['blockedMerchants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nickname: json['nickname'] as String?,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paymentMethodId': instance.paymentMethodId,
      'userId': instance.userId,
      'type': _$PaymentMethodTypeEnumMap[instance.type]!,
      'isDefault': instance.isDefault,
      'isActive': instance.isActive,
      'addedAt': instance.addedAt.toIso8601String(),
      'lastUsedAt': instance.lastUsedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'last4': instance.last4,
      'brand': instance.brand,
      'expMonth': instance.expMonth,
      'expYear': instance.expYear,
      'fingerprint': instance.fingerprint,
      'country': instance.country,
      'funding': _$CardFundingEnumMap[instance.funding],
      'bankName': instance.bankName,
      'accountLast4': instance.accountLast4,
      'routingNumber': instance.routingNumber,
      'accountType': _$BankAccountTypeEnumMap[instance.accountType],
      'accountHolderName': instance.accountHolderName,
      'walletProvider': instance.walletProvider,
      'walletEmail': instance.walletEmail,
      'walletAccountId': instance.walletAccountId,
      'companyName': instance.companyName,
      'billingDepartment': instance.billingDepartment,
      'purchaseOrderNumber': instance.purchaseOrderNumber,
      'stripePaymentMethodId': instance.stripePaymentMethodId,
      'stripeCustomerId': instance.stripeCustomerId,
      'stripeMetadata': instance.stripeMetadata,
      'isVerified': instance.isVerified,
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'verificationMethod': instance.verificationMethod,
      'securityChecks': instance.securityChecks,
      'dailyLimit': instance.dailyLimit,
      'monthlyLimit': instance.monthlyLimit,
      'allowedMerchants': instance.allowedMerchants,
      'blockedMerchants': instance.blockedMerchants,
      'nickname': instance.nickname,
      'description': instance.description,
      'metadata': instance.metadata,
    };

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.card: 'card',
  PaymentMethodType.bankAccount: 'bankAccount',
  PaymentMethodType.digitalWallet: 'digitalWallet',
  PaymentMethodType.cash: 'cash',
  PaymentMethodType.corporate: 'corporate',
};

const _$CardFundingEnumMap = {
  CardFunding.credit: 'credit',
  CardFunding.debit: 'debit',
  CardFunding.prepaid: 'prepaid',
  CardFunding.unknown: 'unknown',
};

const _$BankAccountTypeEnumMap = {
  BankAccountType.checking: 'checking',
  BankAccountType.savings: 'savings',
  BankAccountType.business: 'business',
};

PaymentMethodCheck _$PaymentMethodCheckFromJson(Map<String, dynamic> json) =>
    PaymentMethodCheck(
      id: (json['id'] as num?)?.toInt(),
      checkType: json['checkType'] as String,
      status: $enumDecode(_$CheckStatusEnumMap, json['status']),
      checkedAt: DateTime.parse(json['checkedAt'] as String),
      details: json['details'] as String?,
    );

Map<String, dynamic> _$PaymentMethodCheckToJson(PaymentMethodCheck instance) =>
    <String, dynamic>{
      'id': instance.id,
      'checkType': instance.checkType,
      'status': _$CheckStatusEnumMap[instance.status]!,
      'checkedAt': instance.checkedAt.toIso8601String(),
      'details': instance.details,
    };

const _$CheckStatusEnumMap = {
  CheckStatus.passed: 'passed',
  CheckStatus.failed: 'failed',
  CheckStatus.unavailable: 'unavailable',
  CheckStatus.unchecked: 'unchecked',
};

PaymentMethodSetup _$PaymentMethodSetupFromJson(Map<String, dynamic> json) =>
    PaymentMethodSetup(
      id: (json['id'] as num?)?.toInt(),
      setupIntentId: json['setupIntentId'] as String,
      userId: (json['userId'] as num).toInt(),
      paymentType: $enumDecode(_$PaymentMethodTypeEnumMap, json['paymentType']),
      status: $enumDecodeNullable(_$SetupStatusEnumMap, json['status']) ??
          SetupStatus.pending,
      clientSecret: json['clientSecret'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      failureReason: json['failureReason'] as String?,
      setupMetadata: json['setupMetadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentMethodSetupToJson(PaymentMethodSetup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'setupIntentId': instance.setupIntentId,
      'userId': instance.userId,
      'paymentType': _$PaymentMethodTypeEnumMap[instance.paymentType]!,
      'status': _$SetupStatusEnumMap[instance.status]!,
      'clientSecret': instance.clientSecret,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'failureReason': instance.failureReason,
      'setupMetadata': instance.setupMetadata,
    };

const _$SetupStatusEnumMap = {
  SetupStatus.pending: 'pending',
  SetupStatus.processing: 'processing',
  SetupStatus.completed: 'completed',
  SetupStatus.failed: 'failed',
  SetupStatus.cancelled: 'cancelled',
};
