// server/lib/src/services/payment_service.dart

import 'dart:convert';
import 'dart:math';
import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:ride_hailing_shared/shared.dart';
import '../utils/error_codes.dart';

/// Service for handling payment processing through Stripe
class PaymentService {
  static const String _className = 'PaymentService';
  
  // Stripe configuration
  static String? _stripeSecretKey;
  static String? _stripePublishableKey;
  static String? _stripeWebhookSecret;
  static const String _stripeApiUrl = 'https://api.stripe.com/v1';
  
  // Payment configuration
  static const String _currency = 'usd';
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  /// Initialize payment service with Stripe keys
  static void initialize({
    required String stripeSecretKey,
    required String stripePublishableKey,
    required String stripeWebhookSecret,
  }) {
    _stripeSecretKey = stripeSecretKey;
    _stripePublishableKey = stripePublishableKey;
    _stripeWebhookSecret = stripeWebhookSecret;
  }

  /// Create a payment intent for a ride
  static Future<PaymentIntent> createPaymentIntent(
    Session session, {
    required double amount,
    required int userId,
    required String rideId,
    String? paymentMethodId,
    String? customerId,
    bool confirmImmediately = false,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      session.log('$_className: Creating payment intent for ride $rideId, amount: \$${amount.toStringAsFixed(2)}', 
        level: LogLevel.info);

      _ensureInitialized();

      // Convert amount to cents
      final amountCents = (amount * 100).round();

      final requestBody = {
        'amount': amountCents.toString(),
        'currency': _currency,
        'automatic_payment_methods': jsonEncode({'enabled': true}),
        'metadata': jsonEncode({
          'ride_id': rideId,
          'user_id': userId.toString(),
          ...?metadata,
        }),
      };

      if (customerId != null) {
        requestBody['customer'] = customerId;
      }

      if (paymentMethodId != null) {
        requestBody['payment_method'] = paymentMethodId;
        if (confirmImmediately) {
          requestBody['confirm'] = 'true';
          requestBody['return_url'] = 'https://your-app.com/payment-return';
        }
      }

      final response = await _makeStripeRequest(
        session,
        'POST',
        '/payment_intents',
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final paymentIntent = PaymentIntent(
          id: data['id'],
          amount: (data['amount'] as int) / 100.0,
          currency: data['currency'],
          status: PaymentIntentStatus.values.firstWhere(
            (status) => status.toString().split('.').last == data['status'],
            orElse: () => PaymentIntentStatus.requiresPaymentMethod,
          ),
          clientSecret: data['client_secret'],
          paymentMethodId: data['payment_method'],
          customerId: data['customer'],
          metadata: Map<String, String>.from(data['metadata'] ?? {}),
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['created'] * 1000),
        );

        session.log('$_className: Payment intent created: ${paymentIntent.id}', level: LogLevel.info);
        return paymentIntent;

      } else {
        final error = jsonDecode(response.body);
        throw Exception('Stripe error: ${error['error']['message']}');
      }

    } catch (e, stackTrace) {
      session.log('$_className: Failed to create payment intent: $e', 
        level: LogLevel.error, exception: e, stackTrace: stackTrace);
      throw Exception(ErrorCodes.paymentCreationFailed);
    }
  }

  /// Confirm a payment intent
  static Future<PaymentIntent> confirmPaymentIntent(
    Session session, {
    required String paymentIntentId,
    String? paymentMethodId,
    String? returnUrl,
  }) async {
    try {
      session.log('$_className: Confirming payment intent: $paymentIntentId', level: LogLevel.info);

      _ensureInitialized();

      final requestBody = <String, String>{};
      
      if (paymentMethodId != null) {
        requestBody['payment_method'] = paymentMethodId;
      }
      
      if (returnUrl != null) {
        requestBody['return_url'] = returnUrl;
      }

      final response = await _makeStripeRequest(
        session,
        'POST',
        '/payment_intents/$paymentIntentId/confirm',
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        return PaymentIntent(
          id: data['id'],
          amount: (data['amount'] as int) / 100.0,
          currency: data['currency'],
          status: PaymentIntentStatus.values.firstWhere(
            (status) => status.toString().split('.').last == data['status'],
            orElse: () => PaymentIntentStatus.requiresPaymentMethod,
          ),
          clientSecret: data['client_secret'],
          paymentMethodId: data['payment_method'],
          customerId: data['customer'],
          metadata: Map<String, String>.from(data['metadata'] ?? {}),
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['created'] * 1000),
        );

      } else {
        final error = jsonDecode(response.body);
        throw Exception('Stripe error: ${error['error']['message']}');
      }

    } catch (e, stackTrace) {
      session.log('$_className: Failed to confirm payment intent: $e', 
        level: LogLevel.error, exception: e, stackTrace: stackTrace);
      throw Exception(ErrorCodes.paymentConfirmationFailed);
    }
  }

  /// Create a customer in Stripe
  static Future<String> createCustomer(
    Session session, {
    required int userId,
    required String email,
    String? name,
    String? phone,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      session.log('$_className: Creating Stripe customer for user $userId', level: LogLevel.info);

      _ensureInitialized();

      final requestBody = {
        'email': email,
        'metadata': jsonEncode({
          'user_id': userId.toString(),
          ...?metadata,
        }),
      };

      if (name != null) {
        requestBody['name'] = name;
      }

      if (phone != null) {
        requestBody['phone'] = phone;
      }

      final response = await _makeStripeRequest(
        session,
        'POST',
        '/customers',
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        session.log('$_className: Stripe customer created: ${data['id']}', level: LogLevel.info);
        return data['id'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception('Stripe error: ${error['error']['message']}');
      }

    } catch (e, stackTrace) {
      session.log('$_className: Failed to create customer: $e', 
        level: LogLevel.error, exception: e, stackTrace: stackTrace);
      throw Exception(ErrorCodes.customerCreationFailed);
    }
  }

  /// Attach payment method to customer
  static Future<bool> attachPaymentMethod(
    Session session, {
    required String paymentMethodId,
    required String customerId,
  }) async {
    try {
      session.log('$_className: Attaching payment method to customer', level: LogLevel.info);

      _ensureInitialized();

      final response = await _makeStripeRequest(
        session,
        'POST',
        '/payment_methods/$paymentMethodId/attach',
        body: {'customer': customerId},
      );

      if (response.statusCode == 200) {
        session.log('$_className: Payment method attached successfully', level: LogLevel.info);
        return true;
      } else {
        final error = jsonDecode(response.body);
        session.log('$_className: Failed to attach payment method: ${error['error']['message']}', 
          level: LogLevel.error);
        return false;
      }

    } catch (e) {
      session.log('$_className: Error attaching payment method: $e', level: LogLevel.error);
      return false;
    }
  }

  /// Process ride payment
  static Future<Payment> processRidePayment(
    Session session, {
    required String rideId,
    required int userId,
    required double amount,
    required String paymentMethodId,
    String? customerId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      session.log('$_className: Processing ride payment for ride $rideId', level: LogLevel.info);

      // Create payment intent
      final paymentIntent = await createPaymentIntent(
        session,
        amount: amount,
        userId: userId,
        rideId: rideId,
        paymentMethodId: paymentMethodId,
        customerId: customerId,
        confirmImmediately: true,
        metadata: metadata,
      );

      // Create payment record
      final payment = Payment(
        id: null,
        userId: userId,
        rideId: rideId,
        amount: amount,
        currency: _currency,
        status: _mapPaymentIntentStatusToPaymentStatus(paymentIntent.status),
        paymentMethodId: paymentMethodId,
        stripePaymentIntentId: paymentIntent.id,
        stripeCustomerId: customerId,
        metadata: {
          'stripe_client_secret': paymentIntent.clientSecret,
          ...?metadata,
        },
        createdAt: DateTime.now(),
        processedAt: paymentIntent.status == PaymentIntentStatus.succeeded 
          ? DateTime.now() 
          : null,
      );

      // Store payment in database (would typically be implemented)
      // await _storePayment(session, payment);

      session.log('$_className: Payment processed: ${payment.stripePaymentIntentId}', level: LogLevel.info);
      return payment;

    } catch (e, stackTrace) {
      session.log('$_className: Failed to process ride payment: $e', 
        level: LogLevel.error, exception: e, stackTrace: stackTrace);
      throw Exception(ErrorCodes.paymentProcessingFailed);
    }
  }

  /// Refund a payment
  static Future<Refund> refundPayment(
    Session session, {
    required String paymentIntentId,
    double? amount,
    String? reason,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      session.log('$_className: Processing refund for payment intent: $paymentIntentId', level: LogLevel.info);

      _ensureInitialized();

      final requestBody = {
        'payment_intent': paymentIntentId,
        'metadata': jsonEncode(metadata ?? {}),
      };

      if (amount != null) {
        requestBody['amount'] = ((amount * 100).round()).toString();
      }

      if (reason != null) {
        requestBody['reason'] = reason;
      }

      final response = await _makeStripeRequest(
        session,
        'POST',
        '/refunds',
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final refund = Refund(
          id: data['id'],
          paymentIntentId: data['payment_intent'],
          amount: (data['amount'] as int) / 100.0,
          currency: data['currency'],
          status: RefundStatus.values.firstWhere(
            (status) => status.toString().split('.').last == data['status'],
            orElse: () => RefundStatus.pending,
          ),
          reason: data['reason'],
          metadata: Map<String, String>.from(data['metadata'] ?? {}),
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['created'] * 1000),
        );

        session.log('$_className: Refund processed: ${refund.id}', level: LogLevel.info);
        return refund;

      } else {
        final error = jsonDecode(response.body);
        throw Exception('Stripe error: ${error['error']['message']}');
      }

    } catch (e, stackTrace) {
      session.log('$_className: Failed to process refund: $e', 
        level: LogLevel.error, exception: e, stackTrace: stackTrace);
      throw Exception(ErrorCodes.refundProcessingFailed);
    }
  }

  /// Handle Stripe webhook
  static Future<bool> handleWebhook(
    Session session, {
    required String payload,
    required String signature,
  }) async {
    try {
      session.log('$_className: Processing Stripe webhook', level: LogLevel.info);

      _ensureInitialized();

      // Verify webhook signature
      if (!_verifyWebhookSignature(payload, signature)) {
        session.log('$_className: Invalid webhook signature', level: LogLevel.error);
        return false;
      }

      final event = jsonDecode(payload);
      final eventType = event['type'] as String;
      final eventData = event['data']['object'];

      session.log('$_className: Processing webhook event: $eventType', level: LogLevel.info);

      switch (eventType) {
        case 'payment_intent.succeeded':
          await _handlePaymentSucceeded(session, eventData);
          break;

        case 'payment_intent.payment_failed':
          await _handlePaymentFailed(session, eventData);
          break;

        case 'payment_intent.requires_action':
          await _handlePaymentRequiresAction(session, eventData);
          break;

        case 'payment_method.attached':
          await _handlePaymentMethodAttached(session, eventData);
          break;

        case 'customer.created':
          await _handleCustomerCreated(session, eventData);
          break;

        case 'invoice.payment_succeeded':
          await _handleInvoicePaymentSucceeded(session, eventData);
          break;

        case 'invoice.payment_failed':
          await _handleInvoicePaymentFailed(session, eventData);
          break;

        default:
          session.log('$_className: Unhandled webhook event: $eventType', level: LogLevel.info);
      }

      return true;

    } catch (e, stackTrace) {
      session.log('$_className: Failed to handle webhook: $e', 
        level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Get payment methods for a customer
  static Future<List<PaymentMethod>> getCustomerPaymentMethods(
    Session session, {
    required String customerId,
    String type = 'card',
  }) async {
    try {
      session.log('$_className: Getting payment methods for customer: $customerId', level: LogLevel.info);

      _ensureInitialized();

      final response = await _makeStripeRequest(
        session,
        'GET',
        '/payment_methods?customer=$customerId&type=$type',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentMethods = <PaymentMethod>[];

        for (final pmData in data['data']) {
          final paymentMethod = PaymentMethod(
            paymentMethodId: pmData['id'],
            userId: 0, // Would need to be mapped from customer
            type: _mapStripeTypeToPaymentMethodType(pmData['type']),
            isDefault: false, // Would need to be determined separately
            isActive: true,
            addedAt: DateTime.fromMillisecondsSinceEpoch(pmData['created'] * 1000),
            last4: pmData['card']?['last4'],
            brand: pmData['card']?['brand'],
            expMonth: pmData['card']?['exp_month'],
            expYear: pmData['card']?['exp_year'],
            fingerprint: pmData['card']?['fingerprint'],
            country: pmData['card']?['country'],
            funding: _mapStripeFundingToCardFunding(pmData['card']?['funding']),
            stripePaymentMethodId: pmData['id'],
            stripeCustomerId: customerId,
            isVerified: true,
          );

          paymentMethods.add(paymentMethod);
        }

        return paymentMethods;

      } else {
        final error = jsonDecode(response.body);
        throw Exception('Stripe error: ${error['error']['message']}');
      }

    } catch (e, stackTrace) {
      session.log('$_className: Failed to get payment methods: $e', 
        level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Calculate platform fees and driver earnings
  static Map<String, double> calculatePaymentBreakdown(
    double totalAmount, {
    double platformCommissionRate = 0.20, // 20%
    double paymentProcessingRate = 0.029, // 2.9%
    double paymentProcessingFixed = 0.30, // $0.30
  }) {
    final platformCommission = totalAmount * platformCommissionRate;
    final paymentProcessingFee = (totalAmount * paymentProcessingRate) + paymentProcessingFixed;
    final driverEarnings = totalAmount - platformCommission - paymentProcessingFee;

    return {
      'totalAmount': totalAmount,
      'platformCommission': platformCommission,
      'paymentProcessingFee': paymentProcessingFee,
      'driverEarnings': driverEarnings,
    };
  }

  // Private helper methods

  static void _ensureInitialized() {
    if (_stripeSecretKey == null) {
      throw Exception('Payment service not initialized');
    }
  }

  static Future<http.Response> _makeStripeRequest(
    Session session,
    String method,
    String endpoint, {
    Map<String, String>? body,
    int retryCount = 0,
  }) async {
    try {
      final uri = Uri.parse('$_stripeApiUrl$endpoint');
      final headers = {
        'Authorization': 'Bearer $_stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Stripe-Version': '2023-10-16',
      };

      late http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body?.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&'),
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body?.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&'),
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Retry on rate limit or server errors
      if ((response.statusCode == 429 || response.statusCode >= 500) && retryCount < _maxRetries) {
        await Future.delayed(_retryDelay * (retryCount + 1));
        return _makeStripeRequest(session, method, endpoint, body: body, retryCount: retryCount + 1);
      }

      return response;

    } catch (e) {
      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay * (retryCount + 1));
        return _makeStripeRequest(session, method, endpoint, body: body, retryCount: retryCount + 1);
      }
      rethrow;
    }
  }

  static bool _verifyWebhookSignature(String payload, String signature) {
    try {
      if (_stripeWebhookSecret == null) return false;

  static bool _verifyWebhookSignature(String payload, String signature) {
    try {
      if (_stripeWebhookSecret == null) return false;

      final signatureParts = signature.split(',');
      final timestamp = signatureParts
          .firstWhere((part) => part.startsWith('t='))
          .substring(2);
      final signatures = signatureParts
          .where((part) => part.startsWith('v1='))
          .map((part) => part.substring(3))
          .toList();

      // Check timestamp (should be within 5 minutes)
      final timestampInt = int.tryParse(timestamp);
      if (timestampInt == null) return false;
      
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if ((now - timestampInt).abs() > 300) return false; // 5 minutes

      // Verify signature
      final signedPayload = '$timestamp.$payload';
      final key = utf8.encode(_stripeWebhookSecret!);
      final bytes = utf8.encode(signedPayload);
      final hmac = Hmac(sha256, key);
      final expectedSignature = hmac.convert(bytes).toString();

      return signatures.contains(expectedSignature);

    } catch (e) {
      return false;
    }
  }

  static PaymentStatus _mapPaymentIntentStatusToPaymentStatus(PaymentIntentStatus status) {
    switch (status) {
      case PaymentIntentStatus.succeeded:
        return PaymentStatus.completed;
      case PaymentIntentStatus.requiresPaymentMethod:
      case PaymentIntentStatus.requiresConfirmation:
      case PaymentIntentStatus.requiresAction:
        return PaymentStatus.pending;
      case PaymentIntentStatus.processing:
        return PaymentStatus.processing;
      case PaymentIntentStatus.canceled:
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.failed;
    }
  }

  static PaymentMethodType _mapStripeTypeToPaymentMethodType(String stripeType) {
    switch (stripeType) {
      case 'card':
        return PaymentMethodType.card;
      case 'us_bank_account':
        return PaymentMethodType.bankAccount;
      case 'paypal':
        return PaymentMethodType.digitalWallet;
      default:
        return PaymentMethodType.card;
    }
  }

  static CardFunding? _mapStripeFundingToCardFunding(String? stripeFunding) {
    if (stripeFunding == null) return null;
    
    switch (stripeFunding) {
      case 'credit':
        return CardFunding.credit;
      case 'debit':
        return CardFunding.debit;
      case 'prepaid':
        return CardFunding.prepaid;
      default:
        return CardFunding.unknown;
    }
  }

  // Webhook event handlers

  static Future<void> _handlePaymentSucceeded(Session session, Map<String, dynamic> eventData) async {
    try {
      final paymentIntentId = eventData['id'];
      final rideId = eventData['metadata']?['ride_id'];
      
      session.log('$_className: Payment succeeded for ride: $rideId', level: LogLevel.info);
      
      // Update payment status in database
      // Update ride status to completed
      // Send notification to user and driver
      // Trigger driver payout process
      
    } catch (e) {
      session.log('$_className: Error handling payment succeeded: $e', level: LogLevel.error);
    }
  }

  static Future<void> _handlePaymentFailed(Session session, Map<String, dynamic> eventData) async {
    try {
      final paymentIntentId = eventData['id'];
      final rideId = eventData['metadata']?['ride_id'];
      final error = eventData['last_payment_error'];
      
      session.log('$_className: Payment failed for ride: $rideId, error: ${error?['message']}', 
        level: LogLevel.warning);
      
      // Update payment status in database
      // Send notification to user about payment failure
      // Potentially retry payment or request alternative payment method
      
    } catch (e) {
      session.log('$_className: Error handling payment failed: $e', level: LogLevel.error);
    }
  }

  static Future<void> _handlePaymentRequiresAction(Session session, Map<String, dynamic> eventData) async {
    try {
      final paymentIntentId = eventData['id'];
      final rideId = eventData['metadata']?['ride_id'];
      
      session.log('$_className: Payment requires action for ride: $rideId', level: LogLevel.info);
      
      // Send notification to user to complete payment authentication
      // Update payment status to requires_action
      
    } catch (e) {
      session.log('$_className: Error handling payment requires action: $e', level: LogLevel.error);
    }
  }

  static Future<void> _handlePaymentMethodAttached(Session session, Map<String, dynamic> eventData) async {
    try {
      final paymentMethodId = eventData['id'];
      final customerId = eventData['customer'];
      
      session.log('$_className: Payment method attached: $paymentMethodId to customer: $customerId', 
        level: LogLevel.info);
      
      // Update user's payment methods in database
      // Send confirmation to user
      
    } catch (e) {
      session.log('$_className: Error handling payment method attached: $e', level: LogLevel.error);
    }
  }

  static Future<void> _handleCustomerCreated(Session session, Map<String, dynamic> eventData) async {
    try {
      final customerId = eventData['id'];
      final userId = eventData['metadata']?['user_id'];
      
      session.log('$_className: Customer created: $customerId for user: $userId', level: LogLevel.info);
      
      // Update user record with Stripe customer ID
      
    } catch (e) {
      session.log('$_className: Error handling customer created: $e', level: LogLevel.error);
    }
  }

  static Future<void> _handleInvoicePaymentSucceeded(Session session, Map<String, dynamic> eventData) async {
    try {
      final invoiceId = eventData['id'];
      final customerId = eventData['customer'];
      
      session.log('$_className: Invoice payment succeeded: $invoiceId for customer: $customerId', 
        level: LogLevel.info);
      
      // Handle subscription or recurring payment success
      
    } catch (e) {
      session.log('$_className: Error handling invoice payment succeeded: $e', level: LogLevel.error);
    }
  }

  static Future<void> _handleInvoicePaymentFailed(Session session, Map<String, dynamic> eventData) async {
    try {
      final invoiceId = eventData['id'];
      final customerId = eventData['customer'];
      
      session.log('$_className: Invoice payment failed: $invoiceId for customer: $customerId', 
        level: LogLevel.warning);
      
      // Handle subscription or recurring payment failure
      // Notify user and potentially suspend service
      
    } catch (e) {
      session.log('$_className: Error handling invoice payment failed: $e', level: LogLevel.error);
    }
  }
}

/// Payment Intent data structure
class PaymentIntent {
  final String id;
  final double amount;
  final String currency;
  final PaymentIntentStatus status;
  final String? clientSecret;
  final String? paymentMethodId;
  final String? customerId;
  final Map<String, String> metadata;
  final DateTime createdAt;

  PaymentIntent({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    this.clientSecret,
    this.paymentMethodId,
    this.customerId,
    required this.metadata,
    required this.createdAt,
  });
}

/// Payment Intent Status enum
enum PaymentIntentStatus {
  requiresPaymentMethod,
  requiresConfirmation,
  requiresAction,
  processing,
  requiresCapture,
  canceled,
  succeeded,
}

/// Refund data structure
class Refund {
  final String id;
  final String paymentIntentId;
  final double amount;
  final String currency;
  final RefundStatus status;
  final String? reason;
  final Map<String, String> metadata;
  final DateTime createdAt;

  Refund({
    required this.id,
    required this.paymentIntentId,
    required this.amount,
    required this.currency,
    required this.status,
    this.reason,
    required this.metadata,
    required this.createdAt,
  });
}

/// Refund Status enum
enum RefundStatus {
  pending,
  succeeded,
  failed,
  canceled,
}