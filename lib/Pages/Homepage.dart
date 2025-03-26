import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
      Get.snackbar('Error', '$e',
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
            colors: _weather != null
                ? _weather!.description.toLowerCase().contains('rain')
                    ? [Colors.blueGrey.shade300, Colors.grey.shade900]
                    : _weather!.description.toLowerCase().contains('snow')
                        ? [Colors.blueGrey.shade400, Colors.grey.shade500]
                        : _weather!.description.toLowerCase().contains('clear')
                            ? [ Colors.blue.shade300 ,Colors.orange.shade300,]
                            : _weather!.description
                                        .toLowerCase()
                                        .contains('few clouds') ||
                                    _weather!.description
                                        .toLowerCase()
                                        .contains('partial clouds')
                                ? [Colors.blue.shade300, Colors.grey.shade700]
                                : _weather!.description
                                        .toLowerCase()
                                        .contains('clouds')
                                    ? [
                                        Colors.blue.shade500,
                                        Colors.grey.shade700
                                      ]
                                    : [
                                        Colors.blueGrey.shade400,
                                        Colors.grey.shade700
                                      ]
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
                    duration: const Duration(milliseconds: 600),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 600),
                      builder: (context, opacity, child) {
                        return Opacity(
                          opacity: opacity,
                          child: Transform.translate(
                            offset: Offset(0, (1 - opacity) * 20),
                            child: child,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Lottie.asset('lib/assets/sun.json',
                          //                               height: 50, width: 50, fit: BoxFit.contain),
                          Text(
                            "Weather Now",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  offset: const Offset(1, 3),
                                  blurRadius: 7,
                                ),
                              ],
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  AnimatedContainer(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    duration: const Duration(milliseconds: 300),
                    child: TextField(
                      enableIMEPersonalizedLearning: true,
                      controller: Weathercontroller,
                      cursorColor: Colors.blueGrey,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter City Name',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        filled: true,
                        suffixIcon: Weathercontroller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  Weathercontroller.clear();
                                  setState(() {
                                    _weather = null;
                                  }); // Reset UI
                                },
                              )
                            : null,
                        fillColor: Colors.white.withOpacity(0.9),
                        prefixIcon: isloading
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blueGrey),
                                ),
                              )
                            : Icon(Icons.search, color: Colors.blueGrey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 14),
                      onSubmitted: (value) => getweather(),
                    ),
                  ),
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
                  SizedBox(
                    height: 50,
                  ),
                  if (_weather == null && !isloading)
                    AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Lottie.asset(
                          'lib/assets/Loading.json',
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                        )),
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
