import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void error(String message, {String title = 'Error'}) {
    try {
      Get.showSnackbar(GetSnackBar(
        title: title,
        message: message,
        backgroundColor: const Color.fromARGB(255, 207, 62, 62),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP, // Change to TOP
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        mainButton: TextButton(
          onPressed: () {
            if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
          },
          child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
        ),
      ));
    } catch (e) {
      // Handle potential errors, such as GetX not being initialized.
      debugPrint('Error showing error snackbar: $e');
      // Optionally, show a simple fallback alert dialog or log the error.
      Get.dialog(
        AlertDialog(
          title: const Text('Snackbar Error'),
          content: Text('Failed to show snackbar. $message'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static void success(String message, {String title = 'Success'}) {
    try {
      Get.showSnackbar(GetSnackBar(
        title: title,
        message: message,
        backgroundColor: const Color(0xBB5CCD5F),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP, 
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        mainButton: TextButton(
          onPressed: () {
            if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
          },
          child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
        ),
      ));
    } catch (e) {
      debugPrint('Error showing success snackbar: $e');
      Get.dialog(
        AlertDialog(
          title: const Text('Snackbar Error'),
          content: Text('Failed to show snackbar. $message'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static void warning(String message, {String title = 'Warning'}) {
    try {
      Get.showSnackbar(GetSnackBar(
        title: title,
        message: message,
        backgroundColor: const Color(0xFFFF9800),
        icon: const Icon(Icons.warning_amber, color: Colors.black),
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP, // Change to TOP
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        mainButton: TextButton(
          onPressed: () {
            if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
          },
          child: const Text('Dismiss', style: TextStyle(color: Colors.black)),
        ),
      ));
    } catch (e) {
      debugPrint('Error showing warning snackbar: $e');
      Get.dialog(
        AlertDialog(
          title: const Text('Snackbar Error'),
          content: Text('Failed to show snackbar. $message'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static void info(String message, {String title = 'Info'}) {
    try {
      Get.showSnackbar(GetSnackBar(
        title: title,
        message: message,
        backgroundColor: const Color(0xFF2196F3),
        icon: const Icon(Icons.info_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP, // Change to TOP
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        mainButton: TextButton(
          onPressed: () {
            if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
          },
          child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
        ),
      ));
    } catch (e) {
      debugPrint('Error showing info snackbar: $e');
      Get.dialog(
        AlertDialog(
          title: const Text('Snackbar Error'),
          content: Text('Failed to show snackbar. $message'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}