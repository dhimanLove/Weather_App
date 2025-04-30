import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:weatherapp/Pages/onboarrding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weatherapp/Widgets/Bottomnavbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("YOUR_APP_ID");
  OneSignal.Notifications.requestPermission(true);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Mausam Dekhlo',
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser != null
            ? BottomNavBar()
            : OnboardingScreen());
  }
}
