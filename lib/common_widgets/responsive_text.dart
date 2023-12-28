import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final double size;

  const ResponsiveText({super.key, required this.text, required this.size});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: TextStyle(fontSize: size.sp),
      maxLines: 1,
    );
  }
}
