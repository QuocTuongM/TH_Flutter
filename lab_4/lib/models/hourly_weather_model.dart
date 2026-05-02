class HourlyWeatherModel {
  final DateTime dateTime;
  final double temperature;
  final String icon;
  final String description;
  final int humidity;
  final double windSpeed;

  HourlyWeatherModel({
    required this.dateTime,
    required this.temperature,
    required this.icon,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}