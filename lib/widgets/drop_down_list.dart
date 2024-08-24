import 'package:flutter/material.dart';

import '../utils/constants.dart';

class DropDownList extends StatelessWidget {
  const DropDownList({
    super.key,
    this.items,
    required this.hint,
    required this.validator,
    required this.onChange,
  });
  final void Function(String?)? onChange;
  final List<DropdownMenuItem<String>>? items;
  final String hint;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownButtonFormField<String>(
        value: null,
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
        items: items,
        onChanged: onChange,
        validator: validator,
      ),
    );
  }
}
