import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BottomLink extends StatelessWidget {
  const BottomLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });
  final String text;
  final String linkText;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: kRegularTextStyle,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: kLinkTextStyle,
          ),
        ),
      ],
    );
  }
}
