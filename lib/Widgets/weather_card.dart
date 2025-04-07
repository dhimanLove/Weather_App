import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/Modal/model.dart';
import 'package:get/get.dart';

class WeatherCard extends StatefulWidget {
  final Weather weather;
  final VoidCallback? onRefresh;

  const WeatherCard({
    super.key,
    required this.weather,
    this.onRefresh,
  });

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(date);
  }

  bool isDayTime() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now > widget.weather.sunrise && now < widget.weather.sunset;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.76,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F1A3A), Color(0xFF2E2A5A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.weather.cityName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh,
                      color: Colors.white54, size: 20),
                  onPressed: widget.onRefresh,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Lottie.asset(
                  widget.weather.description.toLowerCase().contains('rain')
                      ? 'lib/assets/rain.json'
                      : widget.weather.description
                              .toLowerCase()
                              .contains('clear')
                          ? 'lib/assets/sunny.json'
                          : widget.weather.description
                                  .toLowerCase()
                                  .contains('snow')
                              ? 'lib/assets/snow.json'
                              : widget.weather.description
                                      .toLowerCase()
                                      .contains('clouds')
                                  ? 'lib/assets/cloudy.json'
                                  : 'lib/assets/sun.json',
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.weather.temperature.toStringAsFixed(0)}°',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Feels like ${(widget.weather.temperature - 2).toStringAsFixed(0)}°',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    Text(
                      widget.weather.description.capitalizeFirst ?? '',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white60),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.2), thickness: 0.6),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.air, color: Colors.white70, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.weather.windSpeed.toStringAsFixed(0)} km/h',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    const Text('Wind',
                        style: TextStyle(fontSize: 10, color: Colors.white54)),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.water_drop,
                        color: Colors.white70, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.weather.humidity}%',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    const Text('Humidity',
                        style: TextStyle(fontSize: 10, color: Colors.white54)),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.cloud, color: Colors.white70, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.weather.humidity}%',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    const Text('Rain',
                        style: TextStyle(fontSize: 10, color: Colors.white54)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.white.withOpacity(0.2), thickness: 0.6),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.wb_sunny,
                        color: Colors.orangeAccent, size: 20),
                    const SizedBox(height: 4),
                    const Text('Sunrise',
                        style: TextStyle(fontSize: 10, color: Colors.white54)),
                    Text(formatTime(widget.weather.sunrise),
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.nights_stay,
                        color: Colors.lightBlueAccent, size: 20),
                    const SizedBox(height: 4),
                    const Text('Sunset',
                        style: TextStyle(fontSize: 10, color: Colors.white54)),
                    Text(formatTime(widget.weather.sunset),
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                Column(
                  children: [
                    Icon(isDayTime() ? Icons.wb_sunny : Icons.nightlight_round,
                        color: Colors.amberAccent, size: 20),
                    const SizedBox(height: 4),
                    Text(isDayTime() ? 'Daytime' : 'Night',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white70)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.2), thickness: 0.6),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Hourly Forecast',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  for (var i = 12; i < 19; i++)
                    Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${i} PM',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white70)),
                          const SizedBox(height: 4),
                          Lottie.asset(
                              'lib/assets/${i % 2 == 0 ? "cloudy.json" : "rain.json"}',
                              height: 30,
                              width: 30),
                          const SizedBox(height: 4),
                          Text('${30 - (i - 12)}°',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
