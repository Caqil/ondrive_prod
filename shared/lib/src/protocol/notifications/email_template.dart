import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_template.g.dart';

@JsonSerializable()
class EmailTemplate extends SerializableEntity {
  @override
  int? id;

  String templateId;
  String name;
  String subject;
  String htmlContent;
  String? textContent;
  EmailType emailType;
  EmailCategory category;
  Map<String, dynamic>? defaultVariables;
  Map<String, TemplateVariable>? requiredVariables;
  bool isActive;
  String? description;
  String? previewText; // Email preview text
  DateTime createdAt;
  DateTime? updatedAt;
  int createdBy;
  String? version;

  // SendGrid specific fields
  String? sendGridTemplateId;
  Map<String, dynamic>? sendGridConfig;

  // Template metadata
  List<String>? tags;
  String? locale;
  Map<String, String>? localizedSubjects;
  Map<String, String>? localizedHtmlContent;

  EmailTemplate({
    this.id,
    required this.templateId,
    required this.name,
    required this.subject,
    required this.htmlContent,
    this.textContent,
    required this.emailType,
    this.category = EmailCategory.transactional,
    this.defaultVariables,
    this.requiredVariables,
    this.isActive = true,
    this.description,
    this.previewText,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
    this.version = '1.0',
    this.sendGridTemplateId,
    this.sendGridConfig,
    this.tags,
    this.locale = 'en',
    this.localizedSubjects,
    this.localizedHtmlContent,
  });

  // Get subject for specific locale
  String getLocalizedSubject(String locale) {
    return localizedSubjects?[locale] ?? subject;
  }

  // Get HTML content for specific locale
  String getLocalizedHtmlContent(String locale) {
    return localizedHtmlContent?[locale] ?? htmlContent;
  }

  // Render template with variables
  String renderSubject(Map<String, dynamic> variables) {
    String rendered = getLocalizedSubject(locale ?? 'en');

    // Merge with default variables
    final allVariables = <String, dynamic>{
      ...?defaultVariables,
      ...variables,
    };

    // Replace variables in format {{variableName}}
    allVariables.forEach((key, value) {
      rendered = rendered.replaceAll('{{$key}}', value.toString());
    });

    return rendered;
  }

  // Render HTML content with variables
  String renderHtmlContent(Map<String, dynamic> variables) {
    String rendered = getLocalizedHtmlContent(locale ?? 'en');

    // Merge with default variables
    final allVariables = <String, dynamic>{
      ...?defaultVariables,
      ...variables,
    };

    // Replace variables in format {{variableName}}
    allVariables.forEach((key, value) {
      rendered = rendered.replaceAll('{{$key}}', value.toString());
    });

    return rendered;
  }

  // Validate required variables
  bool hasRequiredVariables(Map<String, dynamic> variables) {
    if (requiredVariables == null) return true;

    for (final required in requiredVariables!.keys) {
      if (!variables.containsKey(required) || variables[required] == null) {
        return false;
      }
    }
    return true;
  }

  // Get missing required variables
  List<String> getMissingVariables(Map<String, dynamic> variables) {
    if (requiredVariables == null) return [];

    final missing = <String>[];
    for (final required in requiredVariables!.keys) {
      if (!variables.containsKey(required) || variables[required] == null) {
        missing.add(required);
      }
    }
    return missing;
  }

  factory EmailTemplate.fromJson(Map<String, dynamic> json) =>
      _$EmailTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$EmailTemplateToJson(this);
}

@JsonSerializable()
class TemplateVariable extends SerializableEntity {
  @override
  int? id;

  String name;
  String displayName;
  String? description;
  VariableType type;
  bool isRequired;
  String? defaultValue;
  Map<String, dynamic>? validation;

  TemplateVariable({
    this.id,
    required this.name,
    required this.displayName,
    this.description,
    required this.type,
    this.isRequired = false,
    this.defaultValue,
    this.validation,
  });

  factory TemplateVariable.fromJson(Map<String, dynamic> json) =>
      _$TemplateVariableFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateVariableToJson(this);
}

@JsonSerializable()
class EmailDelivery extends SerializableEntity {
  @override
  int? id;

  String deliveryId;
  String templateId;
  String recipientEmail;
  String? recipientName;
  int? userId;
  String renderedSubject;
  String renderedHtmlContent;
  String? renderedTextContent;
  Map<String, dynamic> variables;
  EmailDeliveryStatus status;
  DateTime scheduledAt;
  DateTime? sentAt;
  DateTime? deliveredAt;
  DateTime? openedAt;
  DateTime? clickedAt;
  String? failureReason;
  String? externalMessageId; // SendGrid message ID
  Map<String, dynamic>? deliveryMetadata;

  EmailDelivery({
    this.id,
    required this.deliveryId,
    required this.templateId,
    required this.recipientEmail,
    this.recipientName,
    this.userId,
    required this.renderedSubject,
    required this.renderedHtmlContent,
    this.renderedTextContent,
    this.variables = const {},
    this.status = EmailDeliveryStatus.pending,
    required this.scheduledAt,
    this.sentAt,
    this.deliveredAt,
    this.openedAt,
    this.clickedAt,
    this.failureReason,
    this.externalMessageId,
    this.deliveryMetadata,
  });

  bool get wasOpened => openedAt != null;
  bool get wasClicked => clickedAt != null;
  bool get wasDelivered => deliveredAt != null;
  bool get wasSent => sentAt != null;
  bool get failed => status == EmailDeliveryStatus.failed;

  factory EmailDelivery.fromJson(Map<String, dynamic> json) =>
      _$EmailDeliveryFromJson(json);
  Map<String, dynamic> toJson() => _$EmailDeliveryToJson(this);
}

enum EmailType {
  verification,
  passwordReset,
  rideReceipt,
  rideConfirmation,
  rideReminder,
  rideCancellation,
  driverAssigned,
  paymentReceipt,
  paymentFailed,
  welcome,
  promotional,
  newsletter,
  notification,
  support,
  dispute,
  documentExpiry,
  systemMaintenance,
  other,
}

enum EmailCategory {
  transactional,
  promotional,
  system,
  marketing,
}

enum VariableType {
  string,
  number,
  boolean,
  date,
  url,
  email,
  currency,
}

enum EmailDeliveryStatus {
  pending,
  sending,
  sent,
  delivered,
  opened,
  clicked,
  bounced,
  failed,
  spam,
  unsubscribed,
}
