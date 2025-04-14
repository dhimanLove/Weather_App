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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.weather.isDaytime()
              ? [const Color(0xFFE39122), Color(0xff2E3155), Color(0xff000000)]
              : widget.weather.isMorning()
                  ? [Color(0xFFFFCDD2), Color(0xFFFFCA28), Color(0xFF424242)]
                  : widget.weather.isEvening()
                      ? [
                          Color(0xFF6A1B9A),
                          Color(0xFF1A237E),
                          Color(0xFF000000)
                        ]
                      : [
                          Color(0xFF0D47A1),
                          Color(0xFF1B263B),
                          Color(0xFF000000)
                        ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Added const
        child: Column(
          children: [
            Padding(
              // Added Padding for better spacing
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
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
            ),
            const SizedBox(height: 10),
            Padding(
              // Added Padding for better spacing
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
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
                        widget.weather.description.capitalizeFirst ?? '',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.2), thickness: 0.6),
            const SizedBox(height: 12),
            Padding(
              // Added Padding for better spacing
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
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
                          style:
                              TextStyle(fontSize: 10, color: Colors.white54)),
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
                          style:
                              TextStyle(fontSize: 10, color: Colors.white54)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.white.withOpacity(0.2), thickness: 0.6),
            const SizedBox(height: 10),
            Padding(
              // Added Padding for better spacing
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.wb_sunny,
                          color: Colors.orangeAccent, size: 20),
                      const SizedBox(height: 4),
                      const Text('Sunrise',
                          style:
                              TextStyle(fontSize: 10, color: Colors.white54)),
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
                          style:
                              TextStyle(fontSize: 10, color: Colors.white54)),
                      Text(formatTime(widget.weather.sunset),
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                          isDayTime() ? Icons.wb_sunny : Icons.nightlight_round,
                          color: Colors.amberAccent,
                          size: 20),
                      const SizedBox(height: 4),
                      Text(isDayTime() ? 'Daytime' : 'Night',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.2), thickness: 0.6),
            const SizedBox(height: 10),
            const Padding(
              // Added Padding for better spacing
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Hourly Forecast',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                // Changed ListView to ListView.builder
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 7, // Displaying 7 hours for example
                itemBuilder: (context, index) {
                  final hour = DateTime.now().hour + index + 1;
                  final formattedHour =
                      DateFormat('ha').format(DateTime(0, 1, 1, hour % 24));
                  final isCloudy = index % 2 == 0;
                  final temperature = 30 - index;
                  return Container(
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
                        Text(formattedHour,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white70)),
                        const SizedBox(height: 4),
                        Lottie.asset(
                            'lib/assets/${isCloudy ? "cloudy.json" : "rain.json"}',
                            height: 30,
                            width: 30),
                        const SizedBox(height: 4),
                        Text('${temperature}°',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
