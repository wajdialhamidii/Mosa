import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.controller,
    required this.hint,
    this.isEmail = false,
    this.isPassword = false,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
  });
  final TextEditingController controller;
  final String hint;
  final bool isEmail;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        cursorColor: kBlackColor,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        obscureText: isPassword ? true : false,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: kWhiteColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: kGreyShade400Color),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: kRedColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: kRedColor),
          ),
          fillColor: kGreyShade200Color,
          filled: true,
          hintText: hint,
          hintStyle: const TextStyle(
            color: kGreyColor,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
