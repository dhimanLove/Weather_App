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

  String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.7),
            Colors.white.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
            child: Text(weather.cityName),
          ),
          const SizedBox(height: 15),
          Lottie.asset(
            weather.description.toLowerCase().contains('rain')
                ? 'lib/assets/rain.json'
                : weather.description.toLowerCase().contains('clear')
                    ? 'lib/assets/sunny.json'
                    : 'lib/assets/cloudy.json',
            height: 120,
            width: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.2),
                  Colors.blue.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '${weather.temperature.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            weather.description.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.water_drop_outlined, color: Colors.blue, size: 24),
                        const SizedBox(height: 5),
                        Text(
                          'Humidity',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '${weather.humidity}%',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.air_outlined, color: Colors.grey, size: 24),
                        const SizedBox(height: 5),
                        Text(
                          'Wind',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '${weather.windSpeed.toStringAsFixed(1)} km/h',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.wb_sunny_outlined, color: Colors.orange, size: 24),
                        const SizedBox(height: 5),
                        Text(
                          'Sunrise',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          formatTime(weather.sunrise),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.nights_stay_outlined, color: Colors.blueGrey, size: 24),
                        const SizedBox(height: 5),
                        Text(
                          'Sunset',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          formatTime(weather.sunset),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}