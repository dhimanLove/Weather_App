class Weather {
  final String cityName;
  final String country;
  final double lat;
  final double lon;
  final double temperature;
  final double feelsLike;
  final String description;
  final int humidity;
  final double windSpeed;
  final double uvi;
  final int sunrise;
  final int sunset;
  final double visibility;

  Weather({
    required this.cityName,
    required this.country,
    required this.lat,
    required this.lon,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.uvi,
    required this.sunrise,
    required this.sunset,
    required this.visibility,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final coord = json['coord'];
    final sys = json['sys'];
    final main = json['main'];
    final wind = json['wind'];
    final weatherList = json['weather'];
    final double uviValue = json['current']?['uvi']?.toDouble() ?? 0.0;

    return Weather(
      cityName: json['name'],
      country: sys['country'],
      lat: (coord['lat'] as num).toDouble(),
      lon: (coord['lon'] as num).toDouble(),
      temperature: (main['temp'] as num).toDouble() - 273.15,
      feelsLike: double.parse(((main['feels_like'] as num).toDouble() - 273.15).toStringAsFixed(1)),
      description: weatherList[0]['description'],
      humidity: (main['humidity'] as num).toInt(),
      windSpeed: (wind['speed'] as num).toDouble(),
      uvi: uviValue,
      sunrise: (sys['sunrise'] as num).toInt(),
      sunset: (sys['sunset'] as num).toInt(),
      visibility: (json['visibility'] as num).toDouble() / 1000,
    );
  }

  bool isDaytime() {
    int now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    return now >= sunrise && now < sunset;
  }

  bool isMorning() {
    int now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final morningStart = sunrise - (2 * 3600);
    return now >= morningStart && now < sunrise;
  }

  bool isEvening() {
    int now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final eveningStart = sunset;
    final eveningEnd = sunset + (2 * 3600);
    return now >= eveningStart && now < eveningEnd;
  }

  bool isNighttime() {
    int now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final morningStart = sunrise - (2 * 3600);
    final eveningEnd = sunset + (2 * 3600);
    return now < morningStart || now >= eveningEnd;
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

  factory Geocoding.fromJson(Map<String, dynamic> json) {
    return Geocoding(
      name: json['name'],
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      country: json['country'],
    );
  }
}
