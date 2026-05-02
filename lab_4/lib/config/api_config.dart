class ApiConfig {
  
  static const String apiKey = 'c825535e38b1a5179cb625e51e63e9a3';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Endpoints
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';

  // Build URL
  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    params['appid'] = apiKey;
    params['units'] = 'metric'; // Celsius
    final uri = Uri.parse('$baseUrl$endpoint')
        .replace(queryParameters: params.map(
          (k, v) => MapEntry(k, v.toString()),
        ));
    return uri.toString();
  }

  // Icon URL
  static String iconUrl(String iconCode) =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';
}