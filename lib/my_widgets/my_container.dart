import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyContainer extends StatelessWidget {
  final String text;

  //final IconData icon;
  final String imagePath;

  //double size;

  const MyContainer({
    Key? key,
    required this.text,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 31, spreadRadius: 1, color: Colors.grey.shade300)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath),
          SizedBox(height: mediaQuery.size.height * 0.5),
          Text(
            text,
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
