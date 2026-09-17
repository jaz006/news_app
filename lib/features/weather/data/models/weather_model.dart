class WeatherModel {
  final String cityName;
  final String country;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final String main; // Clear
  final String description; // clear sky
  final String icon; // 01d
  final int dt;
  final int sunrise;
  final int sunset;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.main,
    required this.description,
    required this.icon,
    required this.dt,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weatherList = json['weather'] as List<dynamic>;
    final weatherData = weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>
        : <String, dynamic>{};

    final mainData = json['main'] as Map<String, dynamic>? ?? {};
    final windData = json['wind'] as Map<String, dynamic>? ?? {};
    final sysData = json['sys'] as Map<String, dynamic>? ?? {};

    return WeatherModel(
      cityName: json['name'] ?? '',
      country: sysData['country'] ?? '',
      temp: (mainData['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (mainData['feels_like'] as num?)?.toDouble() ?? 0.0,
      tempMin: (mainData['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (mainData['temp_max'] as num?)?.toDouble() ?? 0.0,
      pressure: (mainData['pressure'] as num?)?.toInt() ?? 0,
      humidity: (mainData['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (windData['speed'] as num?)?.toDouble() ?? 0.0,
      main: weatherData['main'] ?? '',
      description: weatherData['description'] ?? '',
      icon: weatherData['icon'] ?? '01d',
      dt: json['dt'] ?? 0,
      sunrise: sysData['sunrise'] ?? 0,
      sunset: sysData['sunset'] ?? 0,
    );
  }

  
  double get tempInFahrenheit => (temp * 9 / 5) + 32;
}