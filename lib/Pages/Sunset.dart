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
    const baseSunsetHour = 18; // Approximate sunset hour (6 PM local time)
    final cityOffsets = {
      'New York': -4.0, // UTC-4 (EDT)
      'London': 1.0, // UTC+1 (BST on May 1, 2025)
      'Tokyo': 9.0, // UTC+9
      'Sydney': 10.0, // UTC+10
      'Kolkata': 5.5, // UTC+5:30
      'Mumbai': 5.5, // UTC+5:30
      'Delhi': 5.5, // UTC+5:30
    };
    final offset = cityOffsets[city] ?? 0.0;
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

    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade300, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.06,
              vertical: Get.height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header with Back and Refresh Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 28,
                      ),
                      tooltip: 'Go back',
                      onPressed: () => Get.back(),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 28,
                      ),
                      tooltip: 'Refresh',
                      onPressed: () {
                        Get.snackbar(
                          'Refreshed',
                          'Sunset times updated!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue.shade700,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.04),

                // Sunset Icon Animation
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: Icon(
                    isSunsetValid ? Icons.wb_sunny : Icons.nightlight_round,
                    size: 100,
                    color: Colors.orange.shade200.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: Get.height * 0.02),

                // Title
                Text(
                  'Sunset Glow',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.orange.shade300.withOpacity(0.5),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.015),

                // Current City Sunset Info
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white.withOpacity(0.15),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_city,
                              color: Colors.orange.shade200,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cityName,
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isSunsetValid
                              ? formatSunsetTime(currentSunset)
                              : 'Calculating...',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isSunsetValid
                              ? getTimeUntilSunset(currentSunset)
                              : 'Estimating...',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.03),

                // Divider
                Divider(
                  color: Colors.white.withOpacity(0.3),
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(height: Get.height * 0.02),

                // Global Sunset Times
                Text(
                  'Global Sunset Times',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade200,
                  ),
                ),
                SizedBox(height: Get.height * 0.015),

                // List of Other Cities
                ...getOtherCitiesSunset().map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.public,
                        color: Colors.orange.shade200,
                        size: 24,
                      ),
                      title: Text(
                        entry.key,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Text(
                        formatSunsetTime(entry.value),
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                      tileColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: Get.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}