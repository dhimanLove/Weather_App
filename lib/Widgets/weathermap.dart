import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/Modal/model.dart';
import 'package:weatherapp/Widgets/snacbars.dart';
import 'package:weatherapp/Service/servi.dart';
import 'package:weatherapp/Widgets/weather_card.dart'; // Import the WeatherCard widget

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final Services weatherservice = Services();
  final TextEditingController weatherController = TextEditingController();
  bool isLoading = false;
  Weather? _weather;

  void getWeather() async {
    if (weatherController.text.isEmpty) {
      AppSnackbar.warning('Please enter a city name.');
      return;
    }

    setState(() {
      isLoading = true;
      _weather = null; // Clear previous weather data
    });
    try {
      final weather = await weatherservice.getWeather(weatherController.text);
      setState(() {
        _weather = weather;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      AppSnackbar.error('Could not fetch weather data for "${weatherController.text}": $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E2A44),
              Color(0xFF0F1626),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Search Bar
                  TextField(
                    controller: weatherController,
                    cursorColor: Colors.white,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Search City',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      suffixIcon: weatherController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          weatherController.clear();
                          setState(() {
                            _weather = null; // Clear displayed weather on clear
                          });
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (value) => getWeather(),
                  ),
                  const SizedBox(height: 20),
                  if (isLoading)
                    Lottie.asset(
                      'lib/assets/Loading.json',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      repeat: true,
                      reverse: true,
                      animate: true,
                    )
                  else if (_weather != null)
                    WeatherCard( // Display the WeatherCard as a widget here
                      weather: _weather!,
                      onRefresh: getWeather,
                    )
                  else
                    Column(
                      children: [
                        Lottie.asset(
                          'lib/assets/search.json',
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                          repeat: false,
                          reverse: false,
                          animate: true,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Enter a city to see the weather',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
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