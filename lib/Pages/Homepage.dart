import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/Modal/model.dart';
import 'package:weatherapp/Widgets/snacbars.dart';
import 'package:weatherapp/Service/servi.dart';
import 'package:weatherapp/Widgets/weather_card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Services weatherservice = Services();
  final TextEditingController weatherController = TextEditingController();
  bool isLoading = false;
  Weather? _weather;

  void getWeather() async {
    setState(() {
      isLoading = true;
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
     AppSnackbar.error('Something went wrong''$e');
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
                                  _weather = null;
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
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  if (_weather == null && !isLoading)
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: Lottie.asset(
                        'lib/assets/Loading.json',
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  if (_weather != null)
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: WeatherCard(weather: _weather!),
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