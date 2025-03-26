import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/Modal/model.dart';
import 'package:weatherapp/Service/servi.dart';

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
      Get.snackbar('Error', 'Something Went Wrong',
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        gradient: _weather != null &&
                _weather!.description.toLowerCase().contains('rain')
            ? LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.blueGrey,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : _weather != null &&
                    _weather!.description.toLowerCase().contains('clear')
                ? LinearGradient(
                    colors: [
                      Colors.orangeAccent,
                      Colors.lightBlueAccent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.blueGrey,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Weather app",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: Weathercontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none),
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: 'Enter City',
                    filled: true,
                    fillColor: Colors.white),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Get Weather"),
            ),
            if (isloading) // Fixed variable name (isloading -> isLoading)
          Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(
            color: Colors.black,
            backgroundColor: Colors.white,
          ),
          If(_weather != null)
          
        ),
            ]
          ),
        ),
      ),
    ));
  }
}
