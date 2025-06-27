import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import 'location_point.dart';

part 'ride_status.g.dart';

@JsonSerializable()
class RideStatus extends SerializableEntity {
  @override
  int? id;

  String rideId;
  RideState currentState;
  DateTime lastUpdated;
  String? message;
  Map<String, dynamic>? stateData;

  // Timeline tracking
  DateTime? requestedAt;
  DateTime? driverAssignedAt;
  DateTime? driverEnRouteAt;
  DateTime? driverArrivedAt;
  DateTime? rideStartedAt;
  DateTime? rideCompletedAt;
  DateTime? rideCancelledAt;

  // Participants
  int passengerId;
  int? driverId;

  // Location context
  LocationPoint? currentLocation;
  LocationPoint? pickupLocation;
  LocationPoint? dropoffLocation;

  // Progress tracking
  double? progressPercentage; // 0-100
  double? remainingDistance; // in meters
  int? remainingTime; // in seconds

  // Status metadata
  List<RideStatusEvent> statusHistory;
  Map<String, dynamic>? metadata;

  RideStatus({
    this.id,
    required this.rideId,
    this.currentState = RideState.requested,
    required this.lastUpdated,
    this.message,
    this.stateData,
    this.requestedAt,
    this.driverAssignedAt,
    this.driverEnRouteAt,
    this.driverArrivedAt,
    this.rideStartedAt,
    this.rideCompletedAt,
    this.rideCancelledAt,
    required this.passengerId,
    this.driverId,
    this.currentLocation,
    this.pickupLocation,
    this.dropoffLocation,
    this.progressPercentage,
    this.remainingDistance,
    this.remainingTime,
    this.statusHistory = const [],
    this.metadata,
  });

  // State checking methods
  bool get isActive => !isFinalState;
  bool get isFinalState =>
      currentState == RideState.completed ||
      currentState == RideState.cancelled ||
      currentState == RideState.noDriversAvailable;

  bool get hasDriver => driverId != null;
  bool get isInProgress => currentState == RideState.inProgress;
  bool get isCompleted => currentState == RideState.completed;
  bool get isCancelled => currentState == RideState.cancelled;

  // Duration calculations
  Duration? get waitingDuration {
    if (requestedAt == null) return null;
    final endTime = driverAssignedAt ?? DateTime.now();
    return endTime.difference(requestedAt!);
  }

  Duration? get pickupDuration {
    if (driverAssignedAt == null) return null;
    final endTime = driverArrivedAt ?? DateTime.now();
    return endTime.difference(driverAssignedAt!);
  }

  Duration? get rideDuration {
    if (rideStartedAt == null) return null;
    final endTime = rideCompletedAt ?? DateTime.now();
    return endTime.difference(rideStartedAt!);
  }

  Duration? get totalDuration {
    if (requestedAt == null) return null;
    final endTime = rideCompletedAt ?? rideCancelledAt ?? DateTime.now();
    return endTime.difference(requestedAt!);
  }

  // Status descriptions
  String get stateDescription {
    switch (currentState) {
      case RideState.requested:
        return 'Looking for a driver...';
      case RideState.negotiating:
        return 'Negotiating fare...';
      case RideState.driverAssigned:
        return 'Driver assigned';
      case RideState.driverEnRoute:
        return 'Driver is on the way';
      case RideState.arrived:
        return 'Driver has arrived';
      case RideState.inProgress:
        return 'Ride in progress';
      case RideState.completed:
        return 'Ride completed';
      case RideState.cancelled:
        return 'Ride cancelled';
      case RideState.noDriversAvailable:
        return 'No drivers available';
    }
  }

  String? get formattedRemainingTime {
    if (remainingTime == null) return null;
    final minutes = (remainingTime! / 60).round();
    if (minutes < 1) return 'Less than 1 minute';
    return '$minutes minute${minutes != 1 ? 's' : ''}';
  }

  // State transitions
  void updateState(
    RideState newState, {
    String? message,
    Map<String, dynamic>? stateData,
    LocationPoint? location,
  }) {
    final event = RideStatusEvent(
      eventId: 'event_${DateTime.now().millisecondsSinceEpoch}',
      rideId: rideId,
      previousState: currentState,
      newState: newState,
      timestamp: DateTime.now(),
      message: message,
      stateData: stateData,
    );

    // Update timestamps based on state
    final now = DateTime.now();
    switch (newState) {
      case RideState.requested:
        requestedAt ??= now;
        break;
      case RideState.driverAssigned:
        driverAssignedAt = now;
        break;
      case RideState.driverEnRoute:
        driverEnRouteAt = now;
        break;
      case RideState.arrived:
        driverArrivedAt = now;
        break;
      case RideState.inProgress:
        rideStartedAt = now;
        break;
      case RideState.completed:
        rideCompletedAt = now;
        break;
      case RideState.cancelled:
        rideCancelledAt = now;
        break;
      default:
        break;
    }

    // Update current state
    currentState = newState;
    lastUpdated = now;
    this.message = message;
    this.stateData = stateData;
    if (location != null) currentLocation = location;

    // Add to history
    final newHistory = List<RideStatusEvent>.from(statusHistory);
    newHistory.add(event);
  }

  factory RideStatus.fromJson(Map<String, dynamic> json) =>
      _$RideStatusFromJson(json);
  Map<String, dynamic> toJson() => _$RideStatusToJson(this);
}

@JsonSerializable()
class RideStatusEvent extends SerializableEntity {
  @override
  int? id;

  String eventId;
  String rideId;
  RideState previousState;
  RideState newState;
  DateTime timestamp;
  String? message;
  Map<String, dynamic>? stateData;
  int? triggeredBy; // user id who triggered the change

  RideStatusEvent({
    this.id,
    required this.eventId,
    required this.rideId,
    required this.previousState,
    required this.newState,
    required this.timestamp,
    this.message,
    this.stateData,
    this.triggeredBy,
  });

  String get description {
    return 'Ride ${newState.toString().split('.').last}${message != null ? ': $message' : ''}';
  }

  factory RideStatusEvent.fromJson(Map<String, dynamic> json) =>
      _$RideStatusEventFromJson(json);
  Map<String, dynamic> toJson() => _$RideStatusEventToJson(this);
}

enum RideState {
  requested,
  negotiating,
  driverAssigned,
  driverEnRoute,
  arrived,
  inProgress,
  completed,
  cancelled,
  noDriversAvailable,
}
