import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/weather_model.dart';
import '../utils/date_formatter.dart';
import '../utils/weather_icons.dart';
import '../config/api_config.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isOffline;
  final DateTime? lastUpdate;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    this.isOffline = false,
    this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final isNight = weather.dateTime.hour >= 18 ||
        weather.dateTime.hour < 6;
    final gradient = WeatherIcons.getGradient(
        weather.mainCondition, isNight: isNight);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Offline badge
            if (isOffline)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      lastUpdate != null
                          ? 'Cached • ${DateFormatter.formatTime(lastUpdate!)}'
                          : 'Offline',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // City & country
            Text(
              '${weather.cityName}, ${weather.country}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormatter.formatDay(weather.dateTime),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            // Weather icon
            CachedNetworkImage(
              imageUrl: ApiConfig.iconUrl(weather.icon),
              width: 120,
              height: 120,
              errorWidget: (_, __, ___) => Icon(
                WeatherIcons.getIcon(weather.mainCondition),
                color: Colors.white,
                size: 100,
              ),
            ),

            // Temperature
            Text(
              '${weather.temperature.round()}°C',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.w200,
              ),
            ),

            // Description
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Feels like ${weather.feelsLike.round()}°C',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 16),

            // Min/Max temp
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tempBadge(
                    '↑ ${weather.tempMax?.round() ?? '-'}°', Colors.orange),
                const SizedBox(width: 16),
                _tempBadge(
                    '↓ ${weather.tempMin?.round() ?? '-'}°', Colors.lightBlue),
              ],
            ),

            const SizedBox(height: 20),

            // Quick details row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _quickDetail(
                    Icons.water_drop, '${weather.humidity}%', 'Humidity'),
                _quickDetail(
                    Icons.air, '${weather.windSpeed} m/s', 'Wind'),
                _quickDetail(
                    Icons.compress, '${weather.pressure} hPa', 'Pressure'),
              ],
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _tempBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _quickDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}