import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:math' as math;

part 'location_point.g.dart';

@JsonSerializable()
class LocationPoint extends SerializableEntity {
  @override
  int? id;

  double latitude;
  double longitude;
  String? address;
  String? name;
  String? placeId;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  DateTime? timestamp;
  LocationType? locationType;
  Map<String, dynamic>? metadata;

  LocationPoint({
    this.id,
    required this.latitude,
    required this.longitude,
    this.address,
    this.name,
    this.placeId,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.timestamp,
    this.locationType,
    this.metadata,
  });

  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    if (address != null && address!.isNotEmpty) return address!;
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  String get shortAddress {
    if (name != null && name!.isNotEmpty) return name!;
    if (address != null) {
      final parts = address!.split(',');
      if (parts.length > 2) {
        return '${parts[0]}, ${parts[1]}';
      }
      return address!;
    }
    return displayName;
  }

  // Calculate distance to another point using Haversine formula
  double distanceTo(LocationPoint other) {
    const double earthRadius = 6371; // km
    double dLat = _toRadians(other.latitude - latitude);
    double dLng = _toRadians(other.longitude - longitude);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(latitude)) *
            math.cos(_toRadians(other.latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  // Calculate bearing to another point
  double bearingTo(LocationPoint other) {
    double dLng = _toRadians(other.longitude - longitude);
    double lat1 = _toRadians(latitude);
    double lat2 = _toRadians(other.latitude);

    double y = math.sin(dLng) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

    double bearing = math.atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  // Check if point is within a bounding box
  bool isWithinBounds(LocationPoint southwest, LocationPoint northeast) {
    return latitude >= southwest.latitude &&
        latitude <= northeast.latitude &&
        longitude >= southwest.longitude &&
        longitude <= northeast.longitude;
  }

  // Create GeoJSON point
  Map<String, dynamic> toGeoJson() {
    return {
      'type': 'Point',
      'coordinates': [longitude, latitude],
    };
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  double _toDegrees(double radians) {
    return radians * (180 / math.pi);
  }

  factory LocationPoint.fromJson(Map<String, dynamic> json) =>
      _$LocationPointFromJson(json);
  Map<String, dynamic> toJson() => _$LocationPointToJson(this);
}

enum LocationType {
  home,
  work,
  airport,
  hotel,
  restaurant,
  hospital,
  school,
  mall,
  other,
}
