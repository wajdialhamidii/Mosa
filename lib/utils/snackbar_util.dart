import 'package:flutter/material.dart';

class SnackbarUtil {
  static void showSnackbar(
      BuildContext context, String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
