import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Returns the user's country name, or null if it can't be determined
  /// within a reasonable time.
  Future<String?> getCountry() async {
    final position = await _determinePosition();
    if (position == null) return null;

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 8));
      if (placemarks.isEmpty) {
        debugPrint('LocationService: placemarks list is empty');
        return null;
      }
      return placemarks.first.country;
    } catch (e) {
      debugPrint('LocationService: geocoding error (getCountry): $e');
      return null;
    }
  }

  /// Returns the ISO country code (e.g. "DE", "US"), or null if it can't
  /// be determined within a reasonable time.
  Future<String?> getCountryCode() async {
    final position = await _determinePosition();
    if (position == null) {
      debugPrint('LocationService: position is null, cannot resolve country code');
      return null;
    }

    debugPrint('LocationService: position = ${position.latitude}, ${position.longitude}');

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 8));
      if (placemarks.isEmpty) {
        debugPrint('LocationService: placemarks list is empty');
        return null;
      }
      debugPrint('LocationService: isoCountryCode = ${placemarks.first.isoCountryCode}');
      return placemarks.first.isoCountryCode;
    } catch (e) {
      debugPrint('LocationService: geocoding error (getCountryCode): $e');
      return null;
    }
  }

  Future<Position?> _determinePosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint('LocationService: serviceEnabled = $serviceEnabled');
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      debugPrint('LocationService: initial permission = $permission');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint('LocationService: permission after request = $permission');
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('LocationService: permission denied forever');
        return null;
      }

      // Hard timeout so a stuck GPS fix never hangs the UI.
      // try/catch (instead of .timeout(onTimeout:)) avoids a type
      // mismatch: getCurrentPosition() is Future<Position> (non-null),
      // while getLastKnownPosition() is Future<Position?>.
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
          ),
        ).timeout(const Duration(seconds: 10));
      } on TimeoutException {
        debugPrint('LocationService: getCurrentPosition timed out, trying last known position');
        position = await Geolocator.getLastKnownPosition();
      }

      debugPrint('LocationService: getCurrentPosition result = $position');
      return position;
    } catch (e) {
      debugPrint('LocationService: _determinePosition error: $e');
      return null;
    }
  }
}