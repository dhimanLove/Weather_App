import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InfoScreen extends StatelessWidget {
  final String cityName;

  const InfoScreen({
    super.key,
    required this.cityName,
  });

  DateTime calculateSunsetTime(String city) {
    final now = DateTime.now().toUtc();
    final baseSunsetHour = 18; // Approximate sunset hour (6 PM local time)
    Map<String, double> cityOffsets = {
      'New York': -4.0,    // UTC-4 (EDT)
      'London': 1.0,       // UTC+1 (BST on April 30, 2025)
      'Tokyo': 9.0,        // UTC+9
      'Sydney': 10.0,      // UTC+10
      'Kolkata': 5.5,      // UTC+5:30
      'Mumbai': 5.5,       // UTC+5:30
      'Delhi': 5.5,        // UTC+5:30
    };
    double offset = cityOffsets[city] ?? 0.0;
    return DateTime(now.year, now.month, now.day, baseSunsetHour)
        .toUtc()
        .add(Duration(hours: offset.toInt(), minutes: (offset % 1 * 60).toInt()));
  }

  String formatSunsetTime(DateTime sunset) {
    try {
      return DateFormat('h:mm a').format(sunset.toLocal());
    } catch (e) {
      return 'N/A';
    }
  }

  String getTimeUntilSunset(DateTime sunset) {
    try {
      final now = DateTime.now().toUtc();
      final diff = sunset.difference(now);
      if (diff.isNegative) return 'Sunset has passed';
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      return hours > 0 ? '$hours hr $minutes min left' : '$minutes min left';
    } catch (e) {
      return 'Error calculating time';
    }
  }

  List<MapEntry<String, DateTime>> getOtherCitiesSunset() {
    return [
      MapEntry('New York', calculateSunsetTime('New York')),
      MapEntry('London', calculateSunsetTime('London')),
      MapEntry('Tokyo', calculateSunsetTime('Tokyo')),
      MapEntry('Sydney', calculateSunsetTime('Sydney')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentSunset = calculateSunsetTime(cityName);
    final isSunsetValid = currentSunset.isAfter(DateTime.now().toUtc());
    final backgroundOpacity = isSunsetValid ? 0.2 : 0.1;

    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[400]!, Colors.blue[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.08, vertical: Get.height * 0.05),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Tooltip(
                      message: 'Go back',
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 26),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white70, size: 26),
                      onPressed: () {
                        Get.snackbar('Refresh', 'Sunset times recalculated!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.blueAccent.withOpacity(0.8),
                            colorText: Colors.white);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Custom Sunset Animation
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CustomPaint(
                    painter: SunsetPainter(sunset: currentSunset),
                    child: Center(
                      child: !isSunsetValid
                          ? const CircularProgressIndicator(
                        color: Colors.orangeAccent,
                      )
                          : const SizedBox(),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Sunset Glow",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        blurRadius: 15,
                        color: Colors.orangeAccent,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Current City Sunset Info
                Text(
                  isSunsetValid ? '${formatSunsetTime(currentSunset)} in $cityName' : 'Calculating sunset...',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isSunsetValid ? getTimeUntilSunset(currentSunset) : 'Estimating time...',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),

                Divider(color: Colors.white24),
                const SizedBox(height: 20),

                // Other Major Cities
                Text(
                  "Global Sunset Times",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: Colors.orange[200],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                ...getOtherCitiesSunset().map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "${entry.key}: ${formatSunsetTime(entry.value)}",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Sunset Animation
class SunsetPainter extends CustomPainter {
  final DateTime sunset;

  SunsetPainter({required this.sunset});

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now().toUtc();
    final diff = sunset.difference(now);
    double progress = diff.inMinutes / (12 * 60); // Normalize to 12-hour window
    progress = progress.clamp(0.0, 1.0);

    final paintSky = Paint()..color = Colors.blue[900]!.withOpacity(0.8);
    final paintSun = Paint()..color = Colors.orange[400]!;
    final paintHorizon = Paint()..color = Colors.orange[200]!.withOpacity(0.6);

    // Draw sky
    canvas.drawRect(Offset.zero & size, paintSky);

    // Draw horizon
    final horizonHeight = size.height * 0.7;
    canvas.drawRect(
      Rect.fromLTWH(0, horizonHeight, size.width, size.height - horizonHeight),
      paintHorizon,
    );

    // Draw sun
    final sunRadius = size.width * 0.15;
    final sunY = horizonHeight - (progress * (horizonHeight - sunRadius));
    canvas.drawCircle(Offset(size.width * 0.5, sunY), sunRadius, paintSun);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}