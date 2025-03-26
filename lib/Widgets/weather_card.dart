import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/Modal/model.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  String formattime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset(
                weather.description.contains('rain')
                    ? 'lib/assets\rain.json'
                    : weather.description.contains('clear')
                        ? 'lib/assets/sunny.json'
                        : 'lib/assets/cloudy.json',
                height: 150,
                width: 150,
              ),
              Text(
                weather.cityName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${weather.temperature.toStringAsFixed(1)}°C',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                weather.description,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Humidity: ${weather.humidity.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Wind Speed: ${weather.windSpeed.toStringAsFixed(1)} km/h',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                      Text(
                        'Sunrise:',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(formattime(weather.sunrise),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Wind Speed: ${weather.windSpeed.toStringAsFixed(1)} km/h',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
