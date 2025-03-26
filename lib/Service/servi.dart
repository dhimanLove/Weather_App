import 'package:weatherapp/Modal/model.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:weatherapp/utils/env.dart';

class Services
{
  final String apikey = Env.Apikey;
  Future<Weather> getWeather(String cityName) async{
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apikey');


    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }
    else
      {
        throw Exception('Failed to Load Data');
      }
  }
}