import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:math' as math;

import '../rides/location_point.dart';

part 'driver_location.g.dart';

@JsonSerializable()
class DriverLocation extends SerializableEntity {
  @override
  int? id;

  int driverId;
  double latitude;
  double longitude;
  double? altitude;
  double? heading; // 0-360 degrees
  double? speed; // meters per second
  double? accuracy; // meters
  bool isAvailable;
  bool isOnline;
  DateTime timestamp;
  String? currentRideId;
  LocationSource source;
  LocationStatus status;
  Map<String, dynamic>? metadata;

  // Battery and device info
  int? batteryLevel; // 0-100 percentage
  bool? isCharging;
  String? deviceId;
  String? appVersion;

  // Network info
  String? networkType; // '4G', '5G', 'WiFi'
  int? signalStrength; // 0-100 percentage

  DriverLocation({
    this.id,
    required this.driverId,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.heading,
    this.speed,
    this.accuracy,
    this.isAvailable = false,
    this.isOnline = false,
    required this.timestamp,
    this.currentRideId,
    this.source = LocationSource.gps,
    this.status = LocationStatus.active,
    this.metadata,
    this.batteryLevel,
    this.isCharging,
    this.deviceId,
    this.appVersion,
    this.networkType,
    this.signalStrength,
  });

  // Calculate distance to another location
  double distanceTo(double otherLat, double otherLng) {
    const double earthRadius = 6371000; // meters
    double dLat = _toRadians(otherLat - latitude);
    double dLng = _toRadians(otherLng - longitude);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(latitude)) *
            math.cos(_toRadians(otherLat)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  // Calculate bearing to another location
  double bearingTo(double otherLat, double otherLng) {
    double dLng = _toRadians(otherLng - longitude);
    double lat1 = _toRadians(latitude);
    double lat2 = _toRadians(otherLat);

    double y = math.sin(dLng) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

    double bearing = math.atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  // Check if location is stale
  bool get isStale {
    return DateTime.now().difference(timestamp).inMinutes > 2;
  }

  // Check if driver is actively moving
  bool get isMoving {
    return speed != null && speed! > 1.0; // Moving if speed > 1 m/s
  }

  // Get formatted speed
  String get formattedSpeed {
    if (speed == null) return 'Unknown';
    final kmh = (speed! * 3.6).round();
    return '$kmh km/h';
  }

  // Get location quality assessment
  LocationQuality get quality {
    if (accuracy == null) return LocationQuality.unknown;
    if (accuracy! <= 10) return LocationQuality.high;
    if (accuracy! <= 50) return LocationQuality.medium;
    if (accuracy! <= 100) return LocationQuality.low;
    return LocationQuality.poor;
  }

  // Check if driver is in a specific area (bounding box)
  bool isInArea(double swLat, double swLng, double neLat, double neLng) {
    return latitude >= swLat &&
        latitude <= neLat &&
        longitude >= swLng &&
        longitude <= neLng;
  }

  // Create GeoJSON point for mapping
  Map<String, dynamic> toGeoJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      },
      'properties': {
        'driverId': driverId,
        'isAvailable': isAvailable,
        'isOnline': isOnline,
        'timestamp': timestamp.toIso8601String(),
        'heading': heading,
        'speed': speed,
        'accuracy': accuracy,
        'quality': quality.toString(),
      },
    };
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  double _toDegrees(double radians) {
    return radians * (180 / math.pi);
  }

  factory DriverLocation.fromJson(Map<String, dynamic> json) =>
      _$DriverLocationFromJson(json);
  Map<String, dynamic> toJson() => _$DriverLocationToJson(this);
}

@JsonSerializable()
class LocationHistory extends SerializableEntity {
  @override
  int? id;

  int driverId;
  List<DriverLocation> locations;
  DateTime startTime;
  DateTime endTime;
  double totalDistance; // meters
  double averageSpeed; // m/s
  Duration totalDuration;
  int locationCount;

  LocationHistory({
    this.id,
    required this.driverId,
    this.locations = const [],
    required this.startTime,
    required this.endTime,
    this.totalDistance = 0.0,
    this.averageSpeed = 0.0,
    required this.totalDuration,
    this.locationCount = 0,
  });

  // Calculate statistics from locations
  void calculateStatistics() {
    if (locations.isEmpty) return;

    locationCount = locations.length;
    totalDistance = 0.0;

    for (int i = 1; i < locations.length; i++) {
      totalDistance += locations[i - 1].distanceTo(
        locations[i].latitude,
        locations[i].longitude,
      );
    }

    final durationInSeconds = totalDuration.inSeconds;
    averageSpeed =
        durationInSeconds > 0 ? totalDistance / durationInSeconds : 0.0;
  }

  factory LocationHistory.fromJson(Map<String, dynamic> json) =>
      _$LocationHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$LocationHistoryToJson(this);
}

@JsonSerializable()
class GeofenceArea extends SerializableEntity {
  @override
  int? id;

  String areaId;
  String name;
  String? description;
  GeofenceType type;
  List<LocationPoint> boundary; // Polygon vertices
  double? radius; // For circular geofences
  LocationPoint? center; // For circular geofences
  bool isActive;
  Map<String, dynamic>? rules;
  DateTime createdAt;
  DateTime? updatedAt;

  GeofenceArea({
    this.id,
    required this.areaId,
    required this.name,
    this.description,
    required this.type,
    this.boundary = const [],
    this.radius,
    this.center,
    this.isActive = true,
    this.rules,
    required this.createdAt,
    this.updatedAt,
  });

  // Check if a point is inside the geofence
  bool contains(double latitude, double longitude) {
    if (type == GeofenceType.circle) {
      if (center == null || radius == null) return false;
      final distance = center!.distanceTo(LocationPoint(
        latitude: latitude,
        longitude: longitude,
      ));
      return distance <= radius! / 1000; // Convert to km
    } else {
      // Polygon containment using ray casting algorithm
      return _pointInPolygon(latitude, longitude, boundary);
    }
  }

  bool _pointInPolygon(double lat, double lng, List<LocationPoint> polygon) {
    if (polygon.length < 3) return false;

    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      if (((polygon[i].latitude > lat) != (polygon[j].latitude > lat)) &&
          (lng <
              (polygon[j].longitude - polygon[i].longitude) *
                      (lat - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        inside = !inside;
      }
      j = i;
    }

    return inside;
  }

  factory GeofenceArea.fromJson(Map<String, dynamic> json) =>
      _$GeofenceAreaFromJson(json);
  Map<String, dynamic> toJson() => _$GeofenceAreaToJson(this);
}

enum LocationSource {
  gps,
  network,
  passive,
  fused,
  manual,
}

enum LocationStatus {
  active,
  inactive,
  expired,
  invalid,
}

enum LocationQuality {
  high,
  medium,
  low,
  poor,
  unknown,
}

enum GeofenceType {
  polygon,
  circle,
}
