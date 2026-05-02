import 'package:flutter_test/flutter_test.dart';
import 'package:lab_4/models/weather_model.dart';
import 'package:lab_4/models/forecast_model.dart';
import 'package:lab_4/models/hourly_weather_model.dart';
import 'package:lab_4/utils/weather_icons.dart';
import 'package:lab_4/utils/date_formatter.dart';
import 'package:flutter/material.dart';

void main() {
  // ── WeatherModel tests ────────────────────────────────
  group('WeatherModel', () {
    final sampleJson = {
      'name': 'Ho Chi Minh City',
      'sys': {'country': 'VN'},
      'main': {
        'temp': 34.0,
        'feels_like': 41.0,
        'humidity': 60,
        'pressure': 1006,
        'temp_min': 30.0,
        'temp_max': 36.0,
      },
      'wind': {'speed': 3.76},
      'weather': [
        {
          'description': 'overcast clouds',
          'icon': '04d',
          'main': 'Clouds',
        }
      ],
      'dt': 1746172800,
      'visibility': 10000,
      'clouds': {'all': 90},
    };

    test('fromJson parses correctly', () {
      final weather = WeatherModel.fromJson(sampleJson);
      expect(weather.cityName, 'Ho Chi Minh City');
      expect(weather.country, 'VN');
      expect(weather.temperature, 34.0);
      expect(weather.feelsLike, 41.0);
      expect(weather.humidity, 60);
      expect(weather.windSpeed, 3.76);
      expect(weather.pressure, 1006);
      expect(weather.description, 'overcast clouds');
      expect(weather.icon, '04d');
      expect(weather.mainCondition, 'Clouds');
    });

    test('toJson converts back correctly', () {
      final weather = WeatherModel.fromJson(sampleJson);
      final json = weather.toJson();
      expect(json['name'], 'Ho Chi Minh City');
      expect(json['main']['temp'], 34.0);
      expect(json['main']['humidity'], 60);
    });

    test('temperature is double', () {
      final weather = WeatherModel.fromJson(sampleJson);
      expect(weather.temperature, isA<double>());
    });

    test('visibility parsed correctly', () {
      final weather = WeatherModel.fromJson(sampleJson);
      expect(weather.visibility, 10000);
    });

    test('cloudiness parsed correctly', () {
      final weather = WeatherModel.fromJson(sampleJson);
      expect(weather.cloudiness, 90);
    });
  });

  // ── ForecastModel tests ───────────────────────────────
  group('ForecastModel', () {
    final sampleJson = {
      'dt': 1746172800,
      'main': {
        'temp': 32.0,
        'temp_min': 28.0,
        'temp_max': 35.0,
        'humidity': 65,
      },
      'weather': [
        {
          'description': 'light rain',
          'icon': '10d',
          'main': 'Rain',
        }
      ],
      'wind': {'speed': 4.5},
    };

    test('fromJson parses correctly', () {
      final forecast = ForecastModel.fromJson(sampleJson);
      expect(forecast.temperature, 32.0);
      expect(forecast.tempMin, 28.0);
      expect(forecast.tempMax, 35.0);
      expect(forecast.humidity, 65);
      expect(forecast.windSpeed, 4.5);
      expect(forecast.description, 'light rain');
      expect(forecast.mainCondition, 'Rain');
    });
  });

  // ── HourlyWeatherModel tests ──────────────────────────
  group('HourlyWeatherModel', () {
    final sampleJson = {
      'dt': 1746172800,
      'main': {
        'temp': 31.0,
        'humidity': 70,
      },
      'weather': [
        {
          'description': 'scattered clouds',
          'icon': '03d',
        }
      ],
      'wind': {'speed': 2.5},
    };

    test('fromJson parses correctly', () {
      final hourly = HourlyWeatherModel.fromJson(sampleJson);
      expect(hourly.temperature, 31.0);
      expect(hourly.humidity, 70);
      expect(hourly.windSpeed, 2.5);
      expect(hourly.icon, '03d');
    });
  });

  // ── WeatherIcons tests ────────────────────────────────
  group('WeatherIcons', () {
    test('getIcon returns correct icon for clear', () {
      expect(WeatherIcons.getIcon('Clear'), Icons.wb_sunny);
    });

    test('getIcon returns correct icon for rain', () {
      expect(WeatherIcons.getIcon('Rain'), Icons.grain);
    });

    test('getIcon returns correct icon for clouds', () {
      expect(WeatherIcons.getIcon('Clouds'), Icons.cloud);
    });

    test('getIcon returns default for unknown', () {
      expect(WeatherIcons.getIcon('Unknown'), Icons.wb_cloudy);
    });

    test('getGradient returns 2 colors', () {
      final gradient = WeatherIcons.getGradient('Clear');
      expect(gradient.length, 2);
    });

    test('getGradient night mode returns dark colors', () {
      final gradient = WeatherIcons.getGradient('Clear', isNight: true);
      expect(gradient[0], const Color(0xFF2D3748));
    });

    test('getPrimaryColor returns correct color for clear', () {
      final color = WeatherIcons.getPrimaryColor('Clear');
      expect(color, const Color(0xFFFDB813));
    });
  });

  // ── DateFormatter tests ───────────────────────────────
  group('DateFormatter', () {
    final testDate = DateTime(2026, 5, 2, 15, 30);

    test('formatDay returns correct format', () {
      final result = DateFormatter.formatDay(testDate);
      expect(result, isNotEmpty);
      expect(result, contains('May'));
    });

    test('formatHour returns correct format', () {
      final result = DateFormatter.formatHour(testDate);
      expect(result, '15:30');
    });

    test('formatShortDay returns day abbreviation', () {
      final result = DateFormatter.formatShortDay(testDate);
      expect(result, isNotEmpty);
      expect(result.length, lessThanOrEqualTo(3));
    });

    test('formatDate returns month and day', () {
      final result = DateFormatter.formatDate(testDate);
      expect(result, contains('May'));
      expect(result, contains('2'));
    });
  });
}