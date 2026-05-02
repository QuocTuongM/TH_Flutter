import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':       return Icons.wb_sunny;
      case 'clouds':      return Icons.cloud;
      case 'rain':        return Icons.grain;
      case 'drizzle':     return Icons.grain;
      case 'thunderstorm':return Icons.flash_on;
      case 'snow':        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':        return Icons.foggy;
      default:            return Icons.wb_cloudy;
    }
  }

  static List<Color> getGradient(String condition, {bool isNight = false}) {
    if (isNight) {
      return [const Color(0xFF2D3748), const Color(0xFF1A202C)];
    }
    switch (condition.toLowerCase()) {
      case 'clear':
        return [const Color(0xFF4A90E2), const Color(0xFF87CEEB)];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF4A5568), const Color(0xFF718096)];
      case 'thunderstorm':
        return [const Color(0xFF2D3748), const Color(0xFF4A5568)];
      case 'snow':
        return [const Color(0xFFB0C4DE), const Color(0xFFE0EAF5)];
      case 'clouds':
        return [const Color(0xFFA0AEC0), const Color(0xFFCBD5E0)];
      default:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
    }
  }

  static Color getPrimaryColor(String condition, {bool isNight = false}) {
    if (isNight) return const Color(0xFF2D3748);
    switch (condition.toLowerCase()) {
      case 'clear':       return const Color(0xFFFDB813);
      case 'rain':
      case 'drizzle':     return const Color(0xFF4A5568);
      case 'clouds':      return const Color(0xFFA0AEC0);
      default:            return const Color(0xFF667EEA);
    }
  }
}