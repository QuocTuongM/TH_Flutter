import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/hourly_weather_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;
  final ConnectivityService _connectivityService;

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  List<HourlyWeatherModel> _hourly = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
  bool _isOffline = false;
  DateTime? _lastUpdate;
  List<String> _favoriteCities = [];
  List<String> _recentSearches = [];

  // Getters
  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  List<HourlyWeatherModel> get hourly => _hourly;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;
  DateTime? get lastUpdate => _lastUpdate;
  List<String> get favoriteCities => _favoriteCities;
  List<String> get recentSearches => _recentSearches;

  WeatherProvider(
    this._weatherService,
    this._locationService,
    this._storageService,
    this._connectivityService,
  ) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _favoriteCities = await _storageService.getFavoriteCities();
    _recentSearches = await _storageService.getRecentSearches();
    notifyListeners();
  }

  // ── Fetch by city ─────────────────────────────────────
  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        await _loadCachedWeather();
        _isOffline = true;
        notifyListeners();
        return;
      }

      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await _weatherService.getForecast(cityName);
      _hourly = await _weatherService.getHourlyForecast(cityName);

      await _storageService.saveWeatherData(_currentWeather!);
      _lastUpdate = DateTime.now();
      _isOffline = false;
      _state = WeatherState.loaded;
      _errorMessage = '';

      // Lưu recent search
      await _addRecentSearch(cityName);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = WeatherState.error;

      // Load cache khi lỗi
      await _loadCachedWeather();
    }

    notifyListeners();
  }

  // ── Fetch by location ─────────────────────────────────
  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        await _loadCachedWeather();
        _isOffline = true;
        notifyListeners();
        return;
      }

      // Thử lấy location, nếu lỗi dùng HCM mặc định
      try {
        final position = await _locationService.getCurrentLocation();
        _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
          position.latitude,
          position.longitude,
        );
      } catch (_) {
        // Fallback: Ho Chi Minh City
        _currentWeather = await _weatherService.getCurrentWeatherByCity(
          'Ho Chi Minh City',
        );
      }

      final cityName = _currentWeather!.cityName;
      _forecast = await _weatherService.getForecast(cityName);
      _hourly = await _weatherService.getHourlyForecast(cityName);

      await _storageService.saveWeatherData(_currentWeather!);
      _lastUpdate = DateTime.now();
      _isOffline = false;
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = WeatherState.error;
      await _loadCachedWeather();
    }

    notifyListeners();
  }

  // ── Load cache ────────────────────────────────────────
  Future<void> _loadCachedWeather() async {
    final cached = await _storageService.getCachedWeather();
    if (cached != null) {
      _currentWeather = cached;
      _lastUpdate = await _storageService.getLastUpdate();
      _state = WeatherState.loaded;
      _isOffline = true;
    }
  }

  // ── Refresh ───────────────────────────────────────────
  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }

  // ── Favorite cities ───────────────────────────────────
  Future<void> addFavoriteCity(String city) async {
    if (_favoriteCities.length >= 5) return;
    if (!_favoriteCities.contains(city)) {
      _favoriteCities.add(city);
      await _storageService.saveFavoriteCities(_favoriteCities);
      notifyListeners();
    }
  }

  Future<void> removeFavoriteCity(String city) async {
    _favoriteCities.remove(city);
    await _storageService.saveFavoriteCities(_favoriteCities);
    notifyListeners();
  }

  bool isFavorite(String city) => _favoriteCities.contains(city);

  // ── Recent searches ───────────────────────────────────
  Future<void> _addRecentSearch(String city) async {
    _recentSearches.remove(city);
    _recentSearches.insert(0, city);
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.sublist(0, 10);
    }
    await _storageService.saveRecentSearches(_recentSearches);
  }

  Future<void> clearRecentSearches() async {
    _recentSearches = [];
    await _storageService.saveRecentSearches(_recentSearches);
    notifyListeners();
  }
}
