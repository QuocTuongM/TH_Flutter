import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_icons.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import 'search_screen.dart';
import 'forecast_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => provider.refreshWeather(),
            color: Colors.white,
            backgroundColor: const Color(0xFF4A90E2),
            child: _buildBody(provider),
          ),
          // FAB Search
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SearchScreen()),
              ),
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              child:
                  const Icon(Icons.search, color: Color(0xFF4A90E2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(WeatherProvider provider) {
    // Loading
    if (provider.state == WeatherState.loading) {
      return const LoadingShimmer();
    }

    // Error no cache
    if (provider.state == WeatherState.error &&
        provider.currentWeather == null) {
      return ErrorWidgetCustom(
        message: provider.errorMessage,
        onRetry: () => provider.fetchWeatherByLocation(),
      );
    }

    // No data
    if (provider.currentWeather == null) {
      return _buildNoData(provider);
    }

    final weather = provider.currentWeather!;
    final isNight =
        weather.dateTime.hour >= 18 || weather.dateTime.hour < 6;
    final gradient =
        WeatherIcons.getGradient(weather.mainCondition, isNight: isNight);

    return Container(
      // ✅ Bọc toàn bộ trong gradient
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // ── Current weather ──────────────────────────
            CurrentWeatherCard(
              weather: weather,
              isOffline: provider.isOffline,
              lastUpdate: provider.lastUpdate,
            ),

            const SizedBox(height: 16),

            // ── Hourly forecast ──────────────────────────
            if (provider.hourly.isNotEmpty)
              HourlyForecastList(forecasts: provider.hourly),

            const SizedBox(height: 16),

            // ── Daily forecast ───────────────────────────
            if (provider.forecast.isNotEmpty)
              DailyForecastCard(forecasts: provider.forecast),

            const SizedBox(height: 16),

            // ── Weather details ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'WEATHER DETAILS',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // ✅ Dùng Column + Row thay GridView
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: WeatherDetailItem(
                              icon: Icons.water_drop,
                              label: 'Humidity',
                              value: '${weather.humidity}%',
                              color: Colors.lightBlue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: WeatherDetailItem(
                              icon: Icons.air,
                              label: 'Wind Speed',
                              value: '${weather.windSpeed} m/s',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: WeatherDetailItem(
                              icon: Icons.compress,
                              label: 'Pressure',
                              value: '${weather.pressure} hPa',
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: WeatherDetailItem(
                              icon: Icons.visibility,
                              label: 'Visibility',
                              value: weather.visibility != null
                                  ? '${(weather.visibility! / 1000).toStringAsFixed(1)} km'
                                  : 'N/A',
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: WeatherDetailItem(
                              icon: Icons.cloud,
                              label: 'Cloudiness',
                              value: '${weather.cloudiness ?? 0}%',
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: WeatherDetailItem(
                              icon: Icons.thermostat,
                              label: 'Feels Like',
                              value: '${weather.feelsLike.round()}°C',
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Action buttons ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      icon: Icons.calendar_month,
                      label: '5-Day Forecast',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ForecastScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsScreen()),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Favorite button ──────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: GestureDetector(
                onTap: () {
                  if (provider.isFavorite(weather.cityName)) {
                    provider.removeFavoriteCity(weather.cityName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${weather.cityName} removed from favorites'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  } else {
                    provider.addFavoriteCity(weather.cityName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${weather.cityName} added to favorites ⭐'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        provider.isFavorite(weather.cityName)
                            ? Icons.star
                            : Icons.star_border,
                        color: provider.isFavorite(weather.cityName)
                            ? Colors.yellow
                            : Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        provider.isFavorite(weather.cityName)
                            ? 'Remove from Favorites'
                            : 'Add to Favorites',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoData(WeatherProvider provider) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny_outlined,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                'No weather data',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => provider.fetchWeatherByLocation(),
                icon: const Icon(Icons.location_on),
                label: const Text('Get My Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4A90E2),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}