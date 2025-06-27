import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:math' as math;

import 'payment_method.dart';

part 'payment_status.g.dart';

@JsonSerializable()
class PaymentStatus extends SerializableEntity {
  @override
  int? id;

  String paymentId;
  String rideId;
  int userId;
  PaymentState currentState;
  PaymentMethodType paymentMethodType;
  double amount; // in cents
  String currency;
  DateTime createdAt;
  DateTime? lastUpdatedAt;

  // State tracking
  List<PaymentStateTransition> stateHistory;
  Map<String, dynamic>? currentStateData;

  // Processing information
  String? processorTransactionId;
  String? processorReference;
  PaymentProcessorType? processor;

  // Failure information
  String? lastFailureCode;
  String? lastFailureMessage;
  DateTime? lastFailureAt;
  int failureCount;

  // Retry information
  bool canRetry;
  DateTime? nextRetryAt;
  int maxRetries;
  int currentRetries;

  // External references
  String? stripePaymentIntentId;
  String? stripeChargeId;
  Map<String, dynamic>? externalData;

  PaymentStatus({
    this.id,
    required this.paymentId,
    required this.rideId,
    required this.userId,
    this.currentState = PaymentState.pending,
    required this.paymentMethodType,
    required this.amount,
    this.currency = 'USD',
    required this.createdAt,
    this.lastUpdatedAt,
    this.stateHistory = const [],
    this.currentStateData,
    this.processorTransactionId,
    this.processorReference,
    this.processor,
    this.lastFailureCode,
    this.lastFailureMessage,
    this.lastFailureAt,
    this.failureCount = 0,
    this.canRetry = true,
    this.nextRetryAt,
    this.maxRetries = 3,
    this.currentRetries = 0,
    this.stripePaymentIntentId,
    this.stripeChargeId,
    this.externalData,
  });

  // Check if payment is in a final state
  bool get isFinalState {
    return currentState == PaymentState.completed ||
        currentState == PaymentState.failed ||
        currentState == PaymentState.cancelled ||
        currentState == PaymentState.refunded;
  }

  // Check if payment is successful
  bool get isSuccessful {
    return currentState == PaymentState.completed;
  }

  // Check if payment has failed
  bool get hasFailed {
    return currentState == PaymentState.failed;
  }

  // Check if payment is still processing
  bool get isProcessing {
    return currentState == PaymentState.processing ||
        currentState == PaymentState.authorizing ||
        currentState == PaymentState.capturing;
  }

  // Check if payment can be retried
  bool get isRetryable {
    return canRetry &&
        currentRetries < maxRetries &&
        hasFailed &&
        (nextRetryAt == null || DateTime.now().isAfter(nextRetryAt!));
  }

  // Get user-friendly status description
  String get statusDescription {
    switch (currentState) {
      case PaymentState.pending:
        return 'Payment pending';
      case PaymentState.processing:
        return 'Processing payment';
      case PaymentState.authorizing:
        return 'Authorizing payment';
      case PaymentState.authorized:
        return 'Payment authorized';
      case PaymentState.capturing:
        return 'Capturing payment';
      case PaymentState.completed:
        return 'Payment completed';
      case PaymentState.failed:
        return lastFailureMessage ?? 'Payment failed';
      case PaymentState.cancelled:
        return 'Payment cancelled';
      case PaymentState.refunded:
        return 'Payment refunded';
      case PaymentState.partiallyRefunded:
        return 'Payment partially refunded';
      case PaymentState.disputed:
        return 'Payment disputed';
    }
  }

  // Transition to a new state
  void transitionTo(
    PaymentState newState, {
    String? reason,
    Map<String, dynamic>? stateData,
    String? failureCode,
    String? failureMessage,
  }) {
    final transition = PaymentStateTransition(
      fromState: currentState,
      toState: newState,
      transitionedAt: DateTime.now(),
      reason: reason,
      stateData: stateData,
    );

    // Update state history
    final newHistory = List<PaymentStateTransition>.from(stateHistory);
    newHistory.add(transition);

    // Update current state
    currentState = newState;
    lastUpdatedAt = DateTime.now();
    currentStateData = stateData;

    // Handle failure-specific updates
    if (newState == PaymentState.failed) {
      lastFailureCode = failureCode;
      lastFailureMessage = failureMessage;
      lastFailureAt = DateTime.now();
      failureCount++;
      currentRetries++;

      // Set next retry time if retryable
      if (isRetryable) {
        final retryDelayMinutes =
            math.pow(2, currentRetries).toInt(); // Exponential backoff
        nextRetryAt = DateTime.now().add(Duration(minutes: retryDelayMinutes));
      }
    }
  }

  // Get time in current state
  Duration get timeInCurrentState {
    final lastTransition = stateHistory.isNotEmpty ? stateHistory.last : null;
    final stateStartTime = lastTransition?.transitionedAt ?? createdAt;
    return DateTime.now().difference(stateStartTime);
  }

  // Get total processing time
  Duration get totalProcessingTime {
    return (lastUpdatedAt ?? DateTime.now()).difference(createdAt);
  }

  factory PaymentStatus.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatusFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentStatusToJson(this);
}

@JsonSerializable()
class PaymentStateTransition extends SerializableEntity {
  @override
  int? id;

  PaymentState fromState;
  PaymentState toState;
  DateTime transitionedAt;
  String? reason;
  Map<String, dynamic>? stateData;
  String? triggeredBy; // user_id, system, external_event

  PaymentStateTransition({
    this.id,
    required this.fromState,
    required this.toState,
    required this.transitionedAt,
    this.reason,
    this.stateData,
    this.triggeredBy,
  });

  Duration get duration {
    // This would be calculated when the next transition occurs
    return Duration.zero;
  }

  factory PaymentStateTransition.fromJson(Map<String, dynamic> json) =>
      _$PaymentStateTransitionFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentStateTransitionToJson(this);
}

@JsonSerializable()
class PaymentWebhook extends SerializableEntity {
  @override
  int? id;

  String webhookId;
  String paymentId;
  WebhookSource source;
  String eventType;
  Map<String, dynamic> eventData;
  DateTime receivedAt;
  DateTime? processedAt;
  WebhookStatus status;
  String? processingError;
  int retryCount;

  PaymentWebhook({
    this.id,
    required this.webhookId,
    required this.paymentId,
    required this.source,
    required this.eventType,
    required this.eventData,
    required this.receivedAt,
    this.processedAt,
    this.status = WebhookStatus.pending,
    this.processingError,
    this.retryCount = 0,
  });

  bool get isProcessed => status == WebhookStatus.processed;
  bool get hasFailed => status == WebhookStatus.failed;

  factory PaymentWebhook.fromJson(Map<String, dynamic> json) =>
      _$PaymentWebhookFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentWebhookToJson(this);
}

enum PaymentState {
  pending,
  processing,
  authorizing,
  authorized,
  capturing,
  completed,
  failed,
  cancelled,
  refunded,
  partiallyRefunded,
  disputed,
}

enum PaymentProcessorType {
  stripe,
  paypal,
  square,
  braintree,
  other,
}

enum WebhookSource {
  stripe,
  paypal,
  bank,
  other,
}

enum WebhookStatus {
  pending,
  processing,
  processed,
  failed,
  ignored,
}
