import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/hourly_weather_model.dart';
import '../config/api_config.dart';

class WeatherService {
  // ── Current weather by city ───────────────────────────
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {'q': cityName},
      );
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // ── Current weather by coordinates ───────────────────
  Future<WeatherModel> getCurrentWeatherByCoordinates(
      double lat, double lon) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {'lat': lat.toString(), 'lon': lon.toString()},
      );
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // ── 5-day forecast by city ────────────────────────────
  Future<List<ForecastModel>> getForecast(String cityName) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.forecast,
        {'q': cityName},
      );
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['list'];
        return list.map((e) => ForecastModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load forecast: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // ── Hourly forecast ───────────────────────────────────
  Future<List<HourlyWeatherModel>> getHourlyForecast(
      String cityName) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.forecast,
        {'q': cityName, 'cnt': '8'}, // 8 x 3h = 24h
      );
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['list'];
        return list
            .map((e) => HourlyWeatherModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load hourly: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // ── Forecast by coordinates ───────────────────────────
  Future<List<ForecastModel>> getForecastByCoordinates(
      double lat, double lon) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.forecast,
        {'lat': lat.toString(), 'lon': lon.toString()},
      );
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['list'];
        return list.map((e) => ForecastModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load forecast: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}