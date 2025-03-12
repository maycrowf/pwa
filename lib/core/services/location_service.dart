import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  StreamSubscription<Position>? _locationSubscription;

  Future<void> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }
  }

  Future<void> startLocationUpdates(
    Function(double, double, double) onLocationUpdate,
  ) async {
    await requestPermission();

    _locationSubscription?.cancel();

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: _locationSettings,
    ).distinct(_equals).listen(
      (Position position) {
        onLocationUpdate(
          position.latitude,
          position.longitude,
          position.heading,
        );
      },
    );
  }

  static const _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  static bool _equals(prev, next) {
    return prev.latitude == next.latitude && prev.longitude == next.longitude;
  }

  void cancel() => _locationSubscription?.cancel();
}
