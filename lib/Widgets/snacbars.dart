import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void error(String message, {String title = 'Error'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color.fromARGB(255, 207, 62, 62),
      colorText: Colors.white,
      icon: const Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: Icon(Icons.error_outline, color: Colors.white, size: 28),
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      mainButton: TextButton(
        onPressed: () {
          if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
        },
        child: const Text(
          'Dismiss',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static void success(String message, {String title = 'Success'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xBB5CCD5F),
      colorText: Colors.white,
      icon: const Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      mainButton: TextButton(
        onPressed: () {
          if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
        },
        child: const Text(
          'Dismiss',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static void warning(String message, {String title = 'Warning'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFFFF9800),
      colorText: Colors.black,
      icon: const Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: Icon(Icons.warning_amber, color: Colors.black, size: 28),
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      mainButton: TextButton(
        onPressed: () {
          if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
        },
        child: const Text(
          'Dismiss',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static void info(String message, {String title = 'Info'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFF2196F3),
      colorText: Colors.white,
      icon: const Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: Icon(Icons.info_outline, color: Colors.white, size: 28),
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      mainButton: TextButton(
        onPressed: () {
          if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
        },
        child: const Text(
          'Dismiss',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}