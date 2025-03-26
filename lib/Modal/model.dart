class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;
  final int visibility;

  Weather({
    required this.country,
    required this.visibility,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.cityName,
    required this.temperature,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      country: json['sys']['country'],
      visibility: json['visibility'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      cityName: json['name'],
      temperature: json['main']['temp'] - 273.15,
      description: json['weather'][0]['description'],
    );
  }

  bool isDaytime() {
    int currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    return currentTime >= sunrise && currentTime < sunset;
  }
}
