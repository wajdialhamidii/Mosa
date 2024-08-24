import 'package:consultation_app/utils/constants.dart';
import 'package:flutter/material.dart';

class LoadingProgressIndicator extends StatelessWidget {
  const LoadingProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: kMainColor,
      ),
    );
  }

  static void showProgressIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => const LoadingProgressIndicator(),
    );
  }
}
