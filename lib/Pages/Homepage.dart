import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:o3d/o3d.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weatherapp/Modal/model.dart';
import 'package:weatherapp/Pages/Sunset.dart';
import 'package:weatherapp/Widgets/snacbars.dart';
import 'package:weatherapp/Service/servi.dart';
import 'package:intl/intl.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:geolocator/geolocator.dart'; // For location services

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
  Weather? weather;
  String locationName = 'Kaithal';

  String getFeelsLikeText(Weather? weather) {
    final feels = weather?.feelsLike;
    if (feels == null) return '';

    if (feels < 10) {
      return 'Freezing, feels like ${feels.toStringAsFixed(1)}°C';
    } else if (feels < 20) {
      return 'Getting colder, feels like ${feels.toStringAsFixed(1)}°C';
    } else if (feels < 30) {
      return 'Quite warm, feels like ${feels.toStringAsFixed(1)}°C';
    } else if (feels < 40) {
      return 'Hot, feels like ${feels.toStringAsFixed(1)}°C';
    } else if (feels < 50) {
      return 'Extreme heat, feels like ${feels.toStringAsFixed(1)}°C';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _getLocationWeather();
  }

  Future<void> _checkAndRequestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppSnackbar.error('Location permissions are denied');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      AppSnackbar.error(
        'Location permissions are permanently denied, using Kaithal as fallback',
      );
      return;
    }
  }

  Future<void> _getLocationWeather() async {
    setState(() {
      isLoading = true;
      weather = null;
    });

    try {
      await _checkAndRequestPermissions();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      final weatherData = await weatherservice.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      setState(() {
        weather = weatherData;
        isLoading = false;
        locationName = weatherData.cityName;
      });
    } catch (e) {
      AppSnackbar.error(
        'Location or weather error: $e, using Kaithal as fallback',
      );
      try {
        final kaithalWeather = await weatherservice.getWeather('Kaithal');
        setState(() {
          weather = kaithalWeather;
          isLoading = false;
          locationName = 'Kaithal';
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        AppSnackbar.error('Could not fetch weather data for Kaithal: $e');
      }
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
        const Color(0xff000000),
      ];
    } else if (weather.isMorning()) {
      return [
        const Color(0xFFFFCDD2),
        const Color(0xFFFFCA28),
        const Color(0xFF424242),
      ];
    } else if (weather.isEvening()) {
      return [
        const Color(0xFF6A1B9A),
        const Color(0xFF1A237E),
        const Color(0xFF000000),
      ];
    } else if (weather.isNighttime()) {
      return [
        const Color(0xFF0D47A1),
        const Color(0xFF1B263B),
        const Color(0xFF000000),
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
            colors: _getBackgroundColors(weather),
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
                            locationName,
                            style: GoogleFonts.montserratAlternates(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            weather == null
                                ? "Hello, Welcome"
                                : weather!.isDaytime()
                                ? "Good Day 🌞"
                                : weather!.isEvening()
                                ? "Good Evening 🌆"
                                : weather!.isNighttime()
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
                          border: Border.all(width: 1, color: Colors.white),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            onPressed: _getLocationWeather,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isLoading)
                    Center(
                      child: Lottie.asset(
                        'lib/assets/load.json',
                        height: 200,
                        width: 200,
                        repeat: true,
                        reverse: true,
                        animate: true,
                      ),
                    )
                  else if (weather != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (weather!.description.toLowerCase().contains(
                          'clouds',
                        ))
                          Center(
                            child: SizedBox(
                              width: 200,
                              height: 250,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Lottie.asset('lib/assets/cloudy.json'),
                                ],
                              ),
                            ),
                          )
                        else
                          Lottie.asset(
                            weather!.description.toLowerCase().contains('rain')
                                ? 'lib/assets/rain.json'
                                : weather!.description.toLowerCase().contains(
                                  'clear',
                                )
                                ? 'lib/assets/sunny.json'
                                : weather!.description.toLowerCase().contains(
                                  'snow',
                                )
                                ? 'lib/assets/snow.json'
                                : 'lib/assets/sun.json',
                            height: 250,
                            width: 300,
                            fit: BoxFit.cover,
                          ),
                        Text(
                          '${weather!.temperature.toStringAsFixed(1)}°C',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          weather!.description.capitalizeFirst ?? 'Loading...',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          getFeelsLikeText(weather),
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
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
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.wb_sunny,
                                    size: 30,
                                    color: Colors.orangeAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sunrise',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        _formatTime(weather!.sunrise),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      
                                    },
                                    icon: const Icon(
                                      Icons.wb_sunny,
                                      size: 30,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sunset',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        _formatTime(weather!.sunset),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.air,
                                    size: 30,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Wind',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${weather!.windSpeed.toStringAsFixed(1)} m/s',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.foggy,
                                    size: 30,
                                    color: Color(0xFF8ADAFF),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Humidity',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${weather!.humidity}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 30,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Visibility',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${weather!.visibility}m',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: Color(0xFFe9cc33),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Country',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        weather!.country,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
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
                    )
                  else
                    const Text(
                      'Fetching weather data...',
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
