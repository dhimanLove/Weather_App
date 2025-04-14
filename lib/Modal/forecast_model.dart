

class Forecast {
  final List<ForecastItem> list;

  Forecast({required this.list});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var list = json['list'] as List;
    List<ForecastItem> forecastList = list.map((i) => ForecastItem.fromJson(i)).toList();
    return Forecast(list: forecastList);
  }
}

class ForecastItem {
  final DateTime dtTxt;
  final MainForecast main;
  final List<WeatherForecast> weather;
  final WindForecast wind;

  ForecastItem({
    required this.dtTxt,
    required this.main,
    required this.weather,
    required this.wind,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dtTxt: DateTime.parse(json['dt_txt']),
      main: MainForecast.fromJson(json['main']),
      weather: (json['weather'] as List).map((w) => WeatherForecast.fromJson(w)).toList(),
      wind: WindForecast.fromJson(json['wind']),
    );
  }
}

class MainForecast {
  final double temp;
  final double feelsLike;
  final int humidity;

  MainForecast({required this.temp, required this.feelsLike, required this.humidity});

  factory MainForecast.fromJson(Map<String, dynamic> json) {
    return MainForecast(
      temp: (json['temp'] as num).toDouble() - 273.15,
      feelsLike: (json['feels_like'] as num).toDouble() - 273.15,
      humidity: json['humidity'],
    );
  }
}

class WeatherForecast {
  final String description;
  final String icon;

  WeatherForecast({required this.description, required this.icon});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class WindForecast {
  final double speed;
  final int deg;

  WindForecast({required this.speed, required this.deg});

  factory WindForecast.fromJson(Map<String, dynamic> json) {
    return WindForecast(
      speed: (json['speed'] as num).toDouble(),
      deg: json['deg'],
    );
  }
}