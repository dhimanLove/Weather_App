
class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;

  Weather({
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
        humidity: json['main']['humidity'],
        windSpeed: json['wind'],
        sunrise: json['sys']['sunrise'],
        sunset: json['sys']['sunset'],
        cityName: json['name'],
        temperature: json['main']['temp'] - 273.15,
        description: json['weather']['description']);
  }
}
