import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_model.dart';
import '../utils/date_formatter.dart';
import '../config/api_config.dart';

class DailyForecastCard extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const DailyForecastCard({super.key, required this.forecasts});

  List<ForecastModel> _getDailyForecasts() {
    final Map<String, ForecastModel> daily = {};
    for (final f in forecasts) {
      final key = DateFormatter.formatDate(f.dateTime);
      if (!daily.containsKey(key)) {
        daily[key] = f;
      }
    }
    return daily.values.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final daily = _getDailyForecasts();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today,
                  color: Colors.white.withValues(alpha: 0.8), size: 16),
              const SizedBox(width: 6),
              Text(
                '5-DAY FORECAST',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...daily.map((f) => _buildDayRow(f)),
        ],
      ),
    );
  }

  Widget _buildDayRow(ForecastModel f) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Day name
          SizedBox(
            width: 80,
            child: Text(
              DateFormatter.formatShortDay(f.dateTime),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Icon
          CachedNetworkImage(
            imageUrl: ApiConfig.iconUrl(f.icon),
            width: 32,
            height: 32,
            errorWidget: (_, __, ___) =>
                const Icon(Icons.wb_cloudy, color: Colors.white, size: 32),
          ),
          // Description
          Expanded(
            child: Text(
              f.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ),
          // Temp min/max
          Text(
            '${f.tempMin.round()}° / ${f.tempMax.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}