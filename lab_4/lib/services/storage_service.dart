import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _weatherKey      = 'cached_weather';
  static const String _lastUpdateKey   = 'last_update';
  static const String _favCitiesKey    = 'favorite_cities';
  static const String _recentSearchKey = 'recent_searches';
  static const String _tempUnitKey     = 'temp_unit';
  static const String _windUnitKey     = 'wind_unit';
  static const String _timeFormatKey   = 'time_format';

  // ── Weather cache ─────────────────────────────────────
  Future<void> saveWeatherData(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, jsonEncode(weather.toJson()));
    await prefs.setInt(
        _lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<WeatherModel?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_weatherKey);
    if (raw != null) {
      return WeatherModel.fromJson(jsonDecode(raw));
    }
    return null;
  }

  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    if (lastUpdate == null) return false;
    final diff = DateTime.now().millisecondsSinceEpoch - lastUpdate;
    return diff < 30 * 60 * 1000; // 30 phút
  }

  Future<DateTime?> getLastUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    if (lastUpdate == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(lastUpdate);
  }

  // ── Favorite cities ───────────────────────────────────
  Future<void> saveFavoriteCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favCitiesKey, cities);
  }

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favCitiesKey) ?? [];
  }

  // ── Recent searches ───────────────────────────────────
  Future<void> saveRecentSearches(List<String> searches) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchKey, searches);
  }

  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentSearchKey) ?? [];
  }

  // ── Settings ──────────────────────────────────────────
  Future<void> saveTempUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tempUnitKey, unit);
  }

  Future<String> getTempUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tempUnitKey) ?? 'celsius';
  }

  Future<void> saveWindUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_windUnitKey, unit);
  }

  Future<String> getWindUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_windUnitKey) ?? 'kmh';
  }

  Future<void> saveTimeFormat(String format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timeFormatKey, format);
  }

  Future<String> getTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_timeFormatKey) ?? '24h';
  }
}