import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/Modal/model.dart';
import 'package:weatherapp/Service/servi.dart';
import 'package:weatherapp/Widgets/weather_card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Services weatherservice = Services();
  final TextEditingController Weathercontroller = TextEditingController();
  bool isloading = false;
  Weather? _weather;

  void getweather() async {
    setState(() {
      isloading = true;
    });
    try {
      final weather = await weatherservice.getWeather(Weathercontroller.text);
      setState(() {
        _weather = weather;
        isloading = false;
      });
    } catch (e) {
      setState(() {
        isloading = false;
      });
      Get.snackbar('Error', 'Something Went Wrong',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _weather != null &&
                    _weather!.description.toLowerCase().contains('rain')
                ? [Colors.blueGrey.shade700, Colors.grey.shade900]
                : _weather != null &&
                        _weather!.description.toLowerCase().contains('clear')
                    ? [Colors.orange.shade300, Colors.blue.shade300]
                    : [Colors.blueGrey.shade400, Colors.grey.shade700],
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
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      "Weather Now",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: TextField(
                      controller: Weathercontroller,
                      decoration: InputDecoration(
                        hintText: 'Enter City Name',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 15),
                  AnimatedScale(
                    scale: isloading ? 0.95 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: getweather,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Get Weather",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (isloading)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Colors.white24,
                        strokeWidth: 2,
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