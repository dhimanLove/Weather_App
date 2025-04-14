import 'package:weatherapp/Modal/forecast_model.dart';
import 'package:weatherapp/Modal/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Services {
  final String apikeyServices = 'ea3c39ccbd60e9688b1d6df53fd4d5ee';

  Future<Weather> getWeather(String cityName) async {
    final Uri urlGetWeatherServices = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apikeyServices');

    final http.Response responseGetWeatherServices =
        await http.get(urlGetWeatherServices);
    if (responseGetWeatherServices.statusCode == 200) {
      return Weather.fromJson(jsonDecode(responseGetWeatherServices.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Geocoding> getCoordinates(String cityName) async {
    final Uri urlGetCoordinatesServices = Uri.parse(
        'https://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=1&appid=$apikeyServices');

    final http.Response responseGetCoordinatesServices =
        await http.get(urlGetCoordinatesServices);
    if (responseGetCoordinatesServices.statusCode == 200) {
      List<dynamic> dataGetCoordinatesServices =
          jsonDecode(responseGetCoordinatesServices.body);
      if (dataGetCoordinatesServices.isNotEmpty) {
        return Geocoding.fromJson(dataGetCoordinatesServices[0]);
      } else {
        throw Exception('Location not found');
      }
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }

  Future<Forecast> getForecast(double lat, double lon) async {
    final Uri urlGetForecastServices = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apikeyServices');

    final http.Response responseGetForecastServices =
        await http.get(urlGetForecastServices);
    if (responseGetForecastServices.statusCode == 200) {
      return Forecast.fromJson(jsonDecode(responseGetForecastServices.body));
    } else {
      throw Exception('Failed to fetch forecast data');
    }
  }
}
