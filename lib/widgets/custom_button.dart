import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
  });
  final String title;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: kWhiteColor,
        backgroundColor: kMainColor,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'ibmFont',
            fontSize: 20.0,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }
}
