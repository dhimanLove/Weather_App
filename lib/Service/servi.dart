import 'package:weatherapp/Modal/model.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class Services
{
  final String apikey = 'ea3c39ccbd60e9688b1d6df53fd4d5ee';
  Future<Weather> getWeather(String cityName) async{
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apikey');


    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }
    else
      {
        throw Exception('Failed TO LOad Data');
      }
  }
}