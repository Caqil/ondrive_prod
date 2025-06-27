import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import 'location_point.dart';
part 'waypoint.g.dart';

@JsonSerializable()
class Waypoint extends SerializableEntity {
  @override
  int? id;

  String waypointId;
  LocationPoint location;
  WaypointType type;
  int sequenceOrder; // Order in the route
  String? name;
  String? description;
  String? instructions; // Special pickup/dropoff instructions

  // Timing
  DateTime? scheduledTime;
  DateTime? actualTime;
  int? estimatedDuration; // Stop duration in seconds
  int? actualDuration;

  // Passenger information
  List<WaypointPassenger>? passengers; // For multi-passenger rides
  String? contactInfo;
  String? accessCode; // Building codes, gate codes, etc.

  // Status tracking
  WaypointStatus status;
  DateTime? arrivedAt;
  DateTime? completedAt;
  String? notes;

  // Business rules
  bool isRequired;
  bool allowsSkip;
  int? maxWaitTime; // in seconds
  double? additionalFee; // in cents

  Waypoint({
    this.id,
    required this.waypointId,
    required this.location,
    required this.type,
    required this.sequenceOrder,
    this.name,
    this.description,
    this.instructions,
    this.scheduledTime,
    this.actualTime,
    this.estimatedDuration,
    this.actualDuration,
    this.passengers,
    this.contactInfo,
    this.accessCode,
    this.status = WaypointStatus.pending,
    this.arrivedAt,
    this.completedAt,
    this.notes,
    this.isRequired = true,
    this.allowsSkip = false,
    this.maxWaitTime,
    this.additionalFee,
  });

  // Status checking
  bool get isCompleted => status == WaypointStatus.completed;
  bool get isSkipped => status == WaypointStatus.skipped;
  bool get isPending => status == WaypointStatus.pending;
  bool get isInProgress => status == WaypointStatus.inProgress;

  // Timing calculations
  Duration? get waitDuration {
    if (arrivedAt == null || completedAt == null) return null;
    return completedAt!.difference(arrivedAt!);
  }

  bool get isOverdue {
    return scheduledTime != null &&
        DateTime.now().isAfter(scheduledTime!) &&
        !isCompleted;
  }

  Duration? get delayDuration {
    if (scheduledTime == null || actualTime == null) return null;
    return actualTime!.difference(scheduledTime!);
  }

  // Passenger management
  int get passengerCount => passengers?.length ?? 0;

  List<WaypointPassenger> get pickupPassengers {
    return passengers
            ?.where((p) => p.action == PassengerAction.pickup)
            .toList() ??
        [];
  }

  List<WaypointPassenger> get dropoffPassengers {
    return passengers
            ?.where((p) => p.action == PassengerAction.dropoff)
            .toList() ??
        [];
  }

  // Update status and timing
  void markAsArrived() {
    status = WaypointStatus.inProgress;
    arrivedAt = DateTime.now();
  }

  void markAsCompleted({String? notes}) {
    status = WaypointStatus.completed;
    completedAt = DateTime.now();
    actualTime = DateTime.now();
    if (notes != null) this.notes = notes;

    if (arrivedAt != null && completedAt != null) {
      actualDuration = completedAt!.difference(arrivedAt!).inSeconds;
    }
  }

  void markAsSkipped({String? reason}) {
    status = WaypointStatus.skipped;
    completedAt = DateTime.now();
    notes = reason;
  }

  factory Waypoint.fromJson(Map<String, dynamic> json) =>
      _$WaypointFromJson(json);
  Map<String, dynamic> toJson() => _$WaypointToJson(this);
}

@JsonSerializable()
class WaypointPassenger extends SerializableEntity {
  @override
  int? id;

  int? passengerId; // null for non-registered passengers
  String name;
  String? phone;
  PassengerAction action;
  String? notes;
  bool isPresent;
  DateTime? confirmedAt;

  WaypointPassenger({
    this.id,
    this.passengerId,
    required this.name,
    this.phone,
    required this.action,
    this.notes,
    this.isPresent = false,
    this.confirmedAt,
  });

  void markAsPresent() {
    isPresent = true;
    confirmedAt = DateTime.now();
  }

  factory WaypointPassenger.fromJson(Map<String, dynamic> json) =>
      _$WaypointPassengerFromJson(json);
  Map<String, dynamic> toJson() => _$WaypointPassengerToJson(this);
}

@JsonSerializable()
class RouteOptimization extends SerializableEntity {
  @override
  int? id;

  String routeId;
  List<Waypoint> originalWaypoints;
  List<Waypoint> optimizedWaypoints;
  OptimizationGoal goal;

  // Optimization results
  double originalDistance; // in meters
  double optimizedDistance;
  int originalDuration; // in seconds
  int optimizedDuration;
  double distanceSaved; // in meters
  int timeSaved; // in seconds
  double fuelSaved; // estimated

  // Algorithm metadata
  String algorithm;
  DateTime optimizedAt;
  Map<String, dynamic>? optimizationData;

  RouteOptimization({
    this.id,
    required this.routeId,
    required this.originalWaypoints,
    required this.optimizedWaypoints,
    required this.goal,
    required this.originalDistance,
    required this.optimizedDistance,
    required this.originalDuration,
    required this.optimizedDuration,
    required this.distanceSaved,
    required this.timeSaved,
    this.fuelSaved = 0.0,
    required this.algorithm,
    required this.optimizedAt,
    this.optimizationData,
  });

  double get distanceSavedPercentage =>
      originalDistance > 0 ? (distanceSaved / originalDistance) * 100 : 0;

  double get timeSavedPercentage =>
      originalDuration > 0 ? (timeSaved / originalDuration) * 100 : 0;

  factory RouteOptimization.fromJson(Map<String, dynamic> json) =>
      _$RouteOptimizationFromJson(json);
  Map<String, dynamic> toJson() => _$RouteOptimizationToJson(this);
}

enum WaypointType {
  pickup,
  dropoff,
  stop,
  waypoint,
  checkpoint,
}

enum WaypointStatus {
  pending,
  inProgress,
  completed,
  skipped,
  failed,
}

enum PassengerAction {
  pickup,
  dropoff,
}

enum OptimizationGoal {
  shortestDistance,
  shortestTime,
  leastFuel,
  balanced,
}
