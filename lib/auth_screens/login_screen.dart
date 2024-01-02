// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../auth_services/auth_services.dart';
import '../auth_services/database_services.dart';
import '../auth_services/helper_functions.dart';
import '../boarding_screens/home_page.dart';
import '../common_widgets/colors.dart';
import '../common_widgets/my_routes.dart';
import '../common_widgets/my_snack_bar.dart';
import '../common_widgets/my_text_field.dart';
import '../common_widgets/responsive_text.dart';
import 'resetpass_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(right: 25.sp, left: 25.sp),
            child: Form(
              key: formKey,
              child: Column(children: [
                const ResponsiveText(text: "Admin Panel", size: 16),
                SizedBox(height: mediaQuery.size.height * 0.01),
                const ResponsiveText(
                    text: "Welcome to the Admin Panel", size: 8),
                SizedBox(height: mediaQuery.size.height * 0.2),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.sp),
                  child: Column(children: [
                    TextFormField(
                      controller: emailTextController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: textInputDecoration.copyWith(
                          label:
                              const ResponsiveText(text: "E-mail", size: 4.5)),
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                            ? null
                            : "please enter an valid Email";
                      },
                      onChanged: (val) {
                        setState(() {
                          emailTextController.text = val;
                        });
                      },
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    TextFormField(
                      obscureText: _obscureText,
                      controller: passwordTextController,
                      keyboardType: TextInputType.text,
                      decoration: textInputDecoration.copyWith(
                          label:
                              const ResponsiveText(text: "Password", size: 4.5),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0XFF2E3192)),
                          )),
                      validator: (val) {
                        if (val!.length < 8) {
                          return "Password must contain at least 8 characters";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          passwordTextController.text = val;
                        });
                      },
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            nextScreen(context, const ResetPassScreen());
                          },
                          child: const ResponsiveText(
                              text: "Forgot Password ?", size: 4.5),
                        )),
                  ]),
                ),
                SizedBox(height: mediaQuery.size.height * 0.10),
                SizedBox(
                  height: 5.h,
                  width: 40.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0XFF00AEEF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: () async {
                      login();
                    },
                    child: const ResponsiveText(text: "Login", size: 4.5),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.025),
                Text.rich(TextSpan(
                  text: "Not an Admin? Click here to  ",
                  style: TextStyle(fontSize: 4.5.sp, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Register",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            fontSize: 4.5.sp,
                            fontWeight: FontWeight.w500,
                            color: MyPrimaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            nextScreen(context, const RegisterScreen());
                          })
                  ],
                )),
              ]),
            ),
          ),
        ),
      ));
    });
  }

  login() async {
    if (formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierColor: Colors.grey,
          barrierDismissible: false, // Prevent user from dismissing the dialog
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      await authService
          .loginWithUserNameandPassword(
              emailTextController.text, passwordTextController.text)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(emailTextController.text);
          // Saving the values to our sf
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(emailTextController.text);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]["Full Name"]);
          Navigator.pop(context);
          nextScreenReplace(context, const HomeScreen());
        } else {
          showSnackbar(context, Colors.red, value);
          nextScreenReplace(context, const RegisterScreen());
        }
      });
    }
  }
}
