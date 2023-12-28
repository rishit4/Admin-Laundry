// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../common_widgets/my_text_field.dart';
import '../common_widgets/responsive_text.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  TextEditingController resetPassword = TextEditingController();

  @override
  void dispose() {
    resetPassword.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetPassword.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                  'Password reset link sent to your email, LogIn in with your new Password'),
            );
          });
    } on FirebaseException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(right: 25.h, left: 25.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const ResponsiveText(
                      text:
                          "Enter your E-mail Address to get link to reset your password",
                      size: 10),
                  SizedBox(height: mediaQuery.size.height * 0.20),
                  TextFormField(
                    controller: resetPassword,
                    keyboardType: TextInputType.emailAddress,
                    decoration: textInputDecoration.copyWith(
                      label: const ResponsiveText(text: "E-mail", size: 4.5),
                    ),
                    onChanged: (val) {
                      setState(() {
                        resetPassword = val as TextEditingController;
                      });
                    },
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                          ? null
                          : "please enter an valid Email";
                    },
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.10),
                  Padding(
                    padding: EdgeInsets.only(right: 20.h, left: 20.h),
                    child: SizedBox(
                      height: 5.h,
                      width: 40.h,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0XFF00AEEF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          onPressed: passwordReset,
                          child: const ResponsiveText(
                            text: "Get Link",
                            size: 4.5,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
