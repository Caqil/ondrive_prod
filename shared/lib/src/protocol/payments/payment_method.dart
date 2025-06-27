import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:math' as math;

part 'payment_method.g.dart';

@JsonSerializable()
class PaymentMethod extends SerializableEntity {
  @override
  int? id;

  String paymentMethodId;
  int userId;
  PaymentMethodType type;
  bool isDefault;
  bool isActive;
  DateTime addedAt;
  DateTime? lastUsedAt;
  DateTime? expiresAt;

  // Card details (masked for security)
  String? last4;
  String? brand; // visa, mastercard, amex, etc.
  int? expMonth;
  int? expYear;
  String? fingerprint; // Unique identifier for the card
  String? country; // Card issuing country
  CardFunding? funding; // credit, debit, prepaid, unknown

  // Bank account details (masked)
  String? bankName;
  String? accountLast4;
  String? routingNumber;
  BankAccountType? accountType;
  String? accountHolderName;

  // Digital wallet details
  String? walletProvider; // apple_pay, google_pay, paypal, etc.
  String? walletEmail;
  String? walletAccountId;

  // Corporate account details
  String? companyName;
  String? billingDepartment;
  String? purchaseOrderNumber;

  // Stripe integration
  String? stripePaymentMethodId;
  String? stripeCustomerId;
  Map<String, dynamic>? stripeMetadata;

  // Security and verification
  bool isVerified;
  DateTime? verifiedAt;
  String? verificationMethod;
  List<PaymentMethodCheck>? securityChecks;

  // Usage restrictions
  double? dailyLimit; // in cents
  double? monthlyLimit; // in cents
  List<String>? allowedMerchants;
  List<String>? blockedMerchants;

  // Metadata
  String? nickname; // User-friendly name
  String? description;
  Map<String, dynamic>? metadata;

  PaymentMethod({
    this.id,
    required this.paymentMethodId,
    required this.userId,
    required this.type,
    this.isDefault = false,
    this.isActive = true,
    required this.addedAt,
    this.lastUsedAt,
    this.expiresAt,
    this.last4,
    this.brand,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.country,
    this.funding,
    this.bankName,
    this.accountLast4,
    this.routingNumber,
    this.accountType,
    this.accountHolderName,
    this.walletProvider,
    this.walletEmail,
    this.walletAccountId,
    this.companyName,
    this.billingDepartment,
    this.purchaseOrderNumber,
    this.stripePaymentMethodId,
    this.stripeCustomerId,
    this.stripeMetadata,
    this.isVerified = false,
    this.verifiedAt,
    this.verificationMethod,
    this.securityChecks,
    this.dailyLimit,
    this.monthlyLimit,
    this.allowedMerchants,
    this.blockedMerchants,
    this.nickname,
    this.description,
    this.metadata,
  });

  // Get user-friendly display name
  String get displayName {
    if (nickname != null && nickname!.isNotEmpty) {
      return nickname!;
    }

    switch (type) {
      case PaymentMethodType.card:
        return '${brand?.toUpperCase() ?? 'Card'} •••• ${last4 ?? '****'}';
      case PaymentMethodType.bankAccount:
        return '${bankName ?? 'Bank'} •••• ${accountLast4 ?? '****'}';
      case PaymentMethodType.digitalWallet:
        return '${walletProvider?.replaceAll('_', ' ').toUpperCase() ?? 'Wallet'}${walletEmail != null ? ' (${_maskEmail(walletEmail!)})' : ''}';
      case PaymentMethodType.cash:
        return 'Cash';
      case PaymentMethodType.corporate:
        return companyName ?? 'Corporate Account';
    }
  }

  // Get icon name for UI
  String get iconName {
    switch (type) {
      case PaymentMethodType.card:
        return brand?.toLowerCase() ?? 'credit_card';
      case PaymentMethodType.bankAccount:
        return 'account_balance';
      case PaymentMethodType.digitalWallet:
        return walletProvider?.toLowerCase() ?? 'account_balance_wallet';
      case PaymentMethodType.cash:
        return 'money';
      case PaymentMethodType.corporate:
        return 'business';
    }
  }

  // Check if payment method is expired
  bool get isExpired {
    if (expiresAt != null) {
      return DateTime.now().isAfter(expiresAt!);
    }

    // Check card expiration
    if (type == PaymentMethodType.card && expMonth != null && expYear != null) {
      final now = DateTime.now();
      final expiration =
          DateTime(expYear!, expMonth! + 1, 0); // Last day of expiry month
      return now.isAfter(expiration);
    }

    return false;
  }

  // Check if payment method is expiring soon (within 30 days)
  bool get isExpiringSoon {
    if (expiresAt != null) {
      final daysUntilExpiry = expiresAt!.difference(DateTime.now()).inDays;
      return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
    }

    if (type == PaymentMethodType.card && expMonth != null && expYear != null) {
      final now = DateTime.now();
      final expiration = DateTime(expYear!, expMonth! + 1, 0);
      final daysUntilExpiry = expiration.difference(now).inDays;
      return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
    }

    return false;
  }

  // Check if payment method can be used for a specific amount
  bool canProcessAmount(double amountCents) {
    if (!isActive || isExpired) return false;

    if (dailyLimit != null && amountCents > dailyLimit!) return false;
    if (monthlyLimit != null && amountCents > monthlyLimit!) return false;

    return true;
  }

  // Get security score (0-100)
  int get securityScore {
    int score = 0;

    if (isVerified) score += 30;
    if (securityChecks != null) {
      for (final check in securityChecks!) {
        if (check.status == CheckStatus.passed) score += 10;
      }
    }
    if (type == PaymentMethodType.card && funding == CardFunding.credit)
      score += 20;
    if (type == PaymentMethodType.digitalWallet) score += 15;

    return math.min(100, score);
  }

  // Mask email for display
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return email;

    final masked = username.substring(0, 2) + '*' * (username.length - 2);
    return '$masked@$domain';
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}

@JsonSerializable()
class PaymentMethodCheck extends SerializableEntity {
  @override
  int? id;

  String
      checkType; // 'cvc_check', 'address_line1_check', 'address_postal_code_check'
  CheckStatus status;
  DateTime checkedAt;
  String? details;

  PaymentMethodCheck({
    this.id,
    required this.checkType,
    required this.status,
    required this.checkedAt,
    this.details,
  });

  factory PaymentMethodCheck.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodCheckFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodCheckToJson(this);
}

@JsonSerializable()
class PaymentMethodSetup extends SerializableEntity {
  @override
  int? id;

  String setupIntentId;
  int userId;
  PaymentMethodType paymentType;
  SetupStatus status;
  String? clientSecret;
  DateTime createdAt;
  DateTime? completedAt;
  String? failureReason;
  Map<String, dynamic>? setupMetadata;

  PaymentMethodSetup({
    this.id,
    required this.setupIntentId,
    required this.userId,
    required this.paymentType,
    this.status = SetupStatus.pending,
    this.clientSecret,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
    this.setupMetadata,
  });

  bool get isCompleted => status == SetupStatus.completed;
  bool get isFailed => status == SetupStatus.failed;

  factory PaymentMethodSetup.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodSetupFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodSetupToJson(this);
}

// Updated enum names to avoid conflicts
enum PaymentMethodType {
  card,
  bankAccount,
  digitalWallet,
  cash,
  corporate,
}

enum CardFunding {
  credit,
  debit,
  prepaid,
  unknown,
}

enum BankAccountType {
  checking,
  savings,
  business,
}

enum CheckStatus {
  passed,
  failed,
  unavailable,
  unchecked,
}

enum SetupStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}
