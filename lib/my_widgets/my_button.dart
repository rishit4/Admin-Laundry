import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyButton extends StatelessWidget {
  final String text;
  final onTap;

  const MyButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100.h,
        height: 30.h,
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10, spreadRadius: 1, color: Colors.grey.shade300)
            ]),
        child: Center(child: Text(text, style: const TextStyle(fontSize: 15))));
  }
}
