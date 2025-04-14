import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:o3d/o3d.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weatherapp/Modal/model.dart';
import 'package:weatherapp/Widgets/snacbars.dart';
import 'package:weatherapp/Service/servi.dart';
import 'package:intl/intl.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  O3DController o3dController = O3DController();
  final Flutter3DController controller = Flutter3DController();
  final Services weatherservice = Services();
  bool isLoading = false;
  Weather? weatherkaithal;

  @override
  void initState() {
    super.initState();
    _getKaithalWeather();
  }

  Future<void> _getKaithalWeather() async {
    setState(() {
      isLoading = true;
      weatherkaithal = null;
    });

    try {
      final weather = await weatherservice.getWeather('Kaithal');
      setState(() {
        weatherkaithal = weather;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      AppSnackbar.error('Could not fetch weather data for Kaithal: $e');
    }
  }

  String _formatTime(int timestamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(date);
  }

  List<Color> _getBackgroundColors(Weather? weather) {
    if (weather == null) {
      return [const Color(0xFF1E2A44), const Color(0xFF0F1626)];
    }

    if (weather.isDaytime()) {
      return [
        const Color(0xFFE39122),
        const Color(0xff2E3155),
        const Color(0xff000000)
      ];
    } else if (weather.isMorning()) {
      return [
        const Color(0xFFFFCDD2),
        const Color(0xFFFFCA28),
        const Color(0xFF424242)
      ];
    } else if (weather.isEvening()) {
      return [
        const Color(0xFF6A1B9A),
        const Color(0xFF1A237E),
        const Color(0xFF000000)
      ];
    } else if (weather.isNighttime()) {
      return [
        const Color(0xFF0D47A1),
        const Color(0xFF1B263B),
        const Color(0xFF000000)
      ];
    }
    return [const Color(0xFF1E2A44), const Color(0xFF0F1626)]; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getBackgroundColors(weatherkaithal),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kaithal",
                            style: GoogleFonts.montserratAlternates(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            weatherkaithal == null
                                ? "Hello, Welcome"
                                : weatherkaithal!.isDaytime()
                                    ? "Good Day 🌞"
                                    : weatherkaithal!.isEvening()
                                        ? "Good Evening 🌆"
                                        : weatherkaithal!.isNighttime()
                                            ? "Good Night 🌚"
                                            : "Nice to meet you👋",
                            style: GoogleFonts.montserratAlternates(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            onPressed: _getKaithalWeather,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isLoading)
                    Center(
                      child: Lottie.asset(
                        'lib/assets/Loading.json',
                        height: 200,
                        width: 200,
                        fit: BoxFit.fitWidth,
                        repeat: true,
                        reverse: true,
                        animate: true,
                      ),
                    )
                  else if (weatherkaithal != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (weatherkaithal!.description
                            .toLowerCase()
                            .contains('clouds'))
                          Center(
                            child: SizedBox(
                              width: 250,
                              height: 350,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  O3D(
                                    src: "lib/assets/cloud__sun_anim.glb",
                                    controller: o3dController,
                                    ar: false,
                                    autoPlay: true,
                                    autoRotate: false,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Lottie.asset(
                            weatherkaithal!.description
                                    .toLowerCase()
                                    .contains('rain')
                                ? 'lib/assets/rain.json'
                                : weatherkaithal!.description
                                        .toLowerCase()
                                        .contains('clear')
                                    ? 'lib/assets/sunny.json'
                                    : weatherkaithal!.description
                                            .toLowerCase()
                                            .contains('snow')
                                        ? 'lib/assets/snow.json'
                                        : 'lib/assets/sun.json',
                            height: 250,
                            width: 300,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(height: 5),
                        Text(
                          '${weatherkaithal!.temperature.toStringAsFixed(1)}°C',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          weatherkaithal!.description.capitalizeFirst ??
                              'Loading...',
                          style: GoogleFonts.montserratAlternates(
                              fontSize: 18, color: Colors.white70),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Shimmer.fromColors(
                            period: const Duration(milliseconds: 1500),
                            baseColor: const Color(0xFFE39122),
                            highlightColor: const Color(0xFF4A53AD),
                            child: Text(
                              "Next Days",
                              style: GoogleFonts.montserratAlternates(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.wb_sunny,
                                      size: 30, color: Colors.orangeAccent),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Sunrise',
                                          style:
                                              TextStyle(color: Colors.white70)),
                                      Text(_formatTime(weatherkaithal!.sunrise),
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.nights_stay,
                                      size: 30, color: Colors.lightBlueAccent),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Sunset',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      Text(
                                        _formatTime(weatherkaithal!.sunset),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(
                          thickness: 0.2,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Wind Section
                              Row(
                                children: [
                                  const Icon(Icons.air, color: Colors.white70),
                                  const SizedBox(
                                      width: 10), // Adjusted to give some space
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Wind',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      Text(
                                        '${weatherkaithal!.windSpeed.toStringAsFixed(1)} m/s',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Humidity Section
                              Row(
                                children: [
                                  const Icon(Icons.water_drop,
                                      color: Colors.white54),
                                  const SizedBox(
                                      width: 10), // Adjusted to give some space
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Humidity',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      Text(
                                        '${weatherkaithal!.humidity}%',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  else
                    const Text(
                      'Fetching weather data for Kaithal...',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
