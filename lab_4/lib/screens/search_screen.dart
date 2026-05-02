import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String city) {
    if (city.trim().isEmpty) return;
    context.read<WeatherProvider>().fetchWeatherByCity(city.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Search bar ────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search city...',
                            hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6)),
                            prefixIcon: Icon(Icons.search,
                                color: Colors.white.withValues(alpha: 0.8)),
                            suffixIcon: _controller.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _controller.clear();
                                      setState(() {});
                                    },
                                    child: Icon(Icons.close,
                                        color: Colors.white
                                            .withValues(alpha: 0.8)),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                          onChanged: (_) => setState(() {}),
                          onSubmitted: _search,
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _search(_controller.text),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.search,
                            color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // ── Favorite cities ───────────────────────
                    if (provider.favoriteCities.isNotEmpty) ...[
                      _sectionHeader(
                          '⭐ Favorite Cities', provider, showClear: false),
                      ...provider.favoriteCities.map((city) =>
                          _cityTile(city, provider,
                              isFavorite: true)),
                      const SizedBox(height: 16),
                    ],

                    // ── Recent searches ───────────────────────
                    if (provider.recentSearches.isNotEmpty) ...[
                      _sectionHeader('🕐 Recent Searches', provider,
                          showClear: true),
                      ...provider.recentSearches.map((city) =>
                          _cityTile(city, provider)),
                    ],

                    // ── No data ───────────────────────────────
                    if (provider.favoriteCities.isEmpty &&
                        provider.recentSearches.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            Icon(Icons.search,
                                size: 80,
                                color:
                                    Colors.white.withValues(alpha: 0.3)),
                            const SizedBox(height: 16),
                            Text(
                              'Search for a city',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, WeatherProvider provider,
      {required bool showClear}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showClear)
            GestureDetector(
              onTap: () => provider.clearRecentSearches(),
              child: Text(
                'Clear',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cityTile(String city, WeatherProvider provider,
      {bool isFavorite = false}) {
    return GestureDetector(
      onTap: () => _search(city),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(
              isFavorite ? Icons.star : Icons.history,
              color: isFavorite
                  ? Colors.yellow
                  : Colors.white.withValues(alpha: 0.7),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                city,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16),
              ),
            ),
            // Toggle favorite
            GestureDetector(
              onTap: () {
                if (provider.isFavorite(city)) {
                  provider.removeFavoriteCity(city);
                } else {
                  provider.addFavoriteCity(city);
                }
              },
              child: Icon(
                provider.isFavorite(city)
                    ? Icons.star
                    : Icons.star_border,
                color: provider.isFavorite(city)
                    ? Colors.yellow
                    : Colors.white.withValues(alpha: 0.5),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}