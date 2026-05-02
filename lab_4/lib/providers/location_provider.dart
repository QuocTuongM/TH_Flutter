import 'package:flutter/material.dart';
import '../services/location_service.dart';

enum LocationState { initial, loading, loaded, error }

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;

  double? _latitude;
  double? _longitude;
  String _cityName = '';
  LocationState _state = LocationState.initial;
  String _errorMessage = '';

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String get cityName => _cityName;
  LocationState get state => _state;
  String get errorMessage => _errorMessage;

  LocationProvider(this._locationService);

  Future<void> getCurrentLocation() async {
    _state = LocationState.loading;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      _latitude = position.latitude;
      _longitude = position.longitude;
      _cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );
      _state = LocationState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = LocationState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    notifyListeners();
  }
}