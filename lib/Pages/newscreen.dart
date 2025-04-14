import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Weather weather = Weather();
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}