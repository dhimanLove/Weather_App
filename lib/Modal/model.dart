// lib/Modal/model.dart

class Weather {
  final String cityName;
  final String country;
  final double lat;
  final double lon;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final double uvi; 
  final int sunrise;
  final int sunset;
  final int visibility;

  Weather({
    required this.uvi,
    required this.lat,
    required this.lon,
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

  factory Weather.fromJson(Map<String, dynamic> jsonWeather) {
    final Map<String, dynamic> coordWeather = jsonWeather['coord'];
    final Map<String, dynamic> sysWeather = jsonWeather['sys'];
    final Map<String, dynamic> mainWeather = jsonWeather['main'];
    final Map<String, dynamic> windWeather = jsonWeather['wind'];
    final List<dynamic> weatherListWeather = jsonWeather['weather'];
    final double uviValue = jsonWeather['current']?['uvi'] ?? 0.0; // Fallback to 0 if UVI is missing

    return Weather(
      uvi: uviValue,
      lat: coordWeather['lat'].toDouble(),
      lon: coordWeather['lon'].toDouble(),
      country: sysWeather['country'],
      visibility: jsonWeather['visibility'],
      humidity: mainWeather['humidity'],
      windSpeed: windWeather['speed'].toDouble(),
      sunrise: sysWeather['sunrise'],
      sunset: sysWeather['sunset'],
      cityName: jsonWeather['name'],
      temperature: (mainWeather['temp'] as num).toDouble() - 273.15, // Kelvin to Celsius
      description: weatherListWeather[0]['description'],
    );
  }
bool isDaytime() {
  int currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  return currentTime >= sunrise && currentTime < sunset;
}

bool isMorning() {
  int currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  final morningStart = sunrise - (2 * 3600); // 2 hours before sunrise
  return currentTime >= morningStart && currentTime < sunrise;
}

bool isEvening() {
  int currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  final eveningStart = sunset;                  //  Evening starts at sunset
  final eveningEnd = sunset + (2 * 3600);       //  Ends 2 hours after sunset
  return currentTime >= eveningStart && currentTime < eveningEnd;
}


bool isNighttime() {
  int currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  final morningStart = sunrise - (2 * 3600);
  final eveningEnd = sunset + (2 * 3600);
  return currentTime < morningStart || currentTime >= eveningEnd;
}

}

class Geocoding {
  final String name;
  final double lat;
  final double lon;
  final String country;

  Geocoding({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
  });

  factory Geocoding.fromJson(Map<String, dynamic> jsonGeocoding) {
    return Geocoding(
      name: jsonGeocoding['name'],
      lat: (jsonGeocoding['lat'] as num).toDouble(),
      lon: (jsonGeocoding['lon'] as num).toDouble(),
      country: jsonGeocoding['country'],
    );
  }
}