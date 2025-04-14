import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/Modal/model.dart';

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
  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(date);
  }

  bool _isDayTime() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now > widget.weather.sunrise && now < widget.weather.sunset;
  }

  List<Color> _getBackgroundColors(Weather weather) {
    if (weather.isDaytime()) {
      return [
        const Color(0xFFFF9800),
        const Color(0xFF2E3155),
      ];
    } else if (weather.isMorning()) {
      return [
        const Color(0xFFFFCDD2),
        const Color(0xFFFFCA28),
      ];
    } else if (weather.isEvening()) {
      return [
        const Color(0xFF6A1B9A),
        const Color(0xFF1A237E),
      ];
    } else if (weather.isNighttime()) {
      return [
        const Color(0xFF0D47A1),
        const Color(0xFF1B263B),
      ];
    }
    return [const Color(0xFF1E2A44), const Color(0xFF0F1626)]; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.92,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: _getBackgroundColors(widget.weather),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location and refresh button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.weather.cityName,
                    style: GoogleFonts.montserratAlternates(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: widget.onRefresh,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Temperature and animation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.weather.temperature.toStringAsFixed(0)}',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 0.9,
                          ),
                        ),
                        Text(
                          '°C',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        widget.weather.description.capitalizeFirst ?? '',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Lottie.asset(
                widget.weather.description.toLowerCase().contains('rain')
                    ? 'lib/assets/rain.json'
                    : widget.weather.description.toLowerCase().contains('clear')
                        ? 'lib/assets/sunny.json'
                        : widget.weather.description.toLowerCase().contains('snow')
                            ? 'lib/assets/snow.json'
                            : widget.weather.description.toLowerCase().contains('clouds')
                                ? 'lib/assets/cloudy.json'
                                : 'lib/assets/sun.json',
                height: 110,
                width: 110,
                fit: BoxFit.contain,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Weather details in a card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Wind and Humidity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Wind detail
                    Column(
                      children: [
                        const Icon(Icons.air, color: Colors.white70, size: 22),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.weather.windSpeed.toStringAsFixed(0)} km/h',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Wind',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    
                    // Humidity detail
                    Column(
                      children: [
                        const Icon(Icons.water_drop, color: Colors.white70, size: 22),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.weather.humidity}%',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Humidity',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 18),
                const Divider(color: Colors.white30, height: 1),
                const SizedBox(height: 18),
                
                // Sunrise, Sunset, and Day/Night status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Sunrise detail
                    Column(
                      children: [
                        const Icon(Icons.wb_sunny, color: Colors.orangeAccent, size: 22),
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(widget.weather.sunrise),
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sunrise',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    
                    // Sunset detail
                    Column(
                      children: [
                        const Icon(Icons.nights_stay, color: Colors.lightBlueAccent, size: 22),
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(widget.weather.sunset),
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sunset',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    
                    // Day/Night status
                    Column(
                      children: [
                        Icon(
                          _isDayTime() ? Icons.wb_sunny : Icons.nightlight_round,
                          color: Colors.amberAccent,
                          size: 22
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isDayTime() ? 'Day' : 'Night',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 12,
                            color: Colors.white60,
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