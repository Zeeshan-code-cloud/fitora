import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  AppSnackbar._();

  static void show({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
    );
  }
}