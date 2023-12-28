import 'package:flutter/material.dart';
import 'colors.dart';

final textInputDecoration = InputDecoration(
  labelStyle:
      const TextStyle(color: MyDarkBlueColor, fontWeight: FontWeight.w400),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.grey, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color(0XFF00AEEF), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.red, width: 2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color(0XFF00AEEF), width: 2),
  ),
);