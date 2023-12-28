import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../auth_services/auth_services.dart';
import '../auth_services/helper_functions.dart';
import '../boarding_screens/home_page.dart';
import '../common_widgets/colors.dart';
import '../common_widgets/my_routes.dart';
import '../common_widgets/my_snack_bar.dart';
import '../common_widgets/my_text_field.dart';
import '../common_widgets/responsive_text.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  //static const String id = "register-screen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  bool _obscureText = true;
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController fullNameTextController = TextEditingController();
  TextEditingController mobileNoTextController = TextEditingController();
  // String email = "";
  // String password = "";
  // String fullName = "";
  // String mobileNo = "";

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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(right: 25.sp, left: 25.sp),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const ResponsiveText(
                            text: "Register your account to Continue", size: 8),
                        SizedBox(height: mediaQuery.size.height * 0.2),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: fullNameTextController,
                                keyboardType: TextInputType.text,
                                decoration: textInputDecoration.copyWith(
                                  label: const ResponsiveText(
                                      text: "Full name", size: 4.5),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    fullNameTextController =
                                        val as TextEditingController;
                                    //fullName = val;
                                  });
                                },
                                validator: (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Name cannot be empty";
                                  }
                                },
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.02),
                              TextFormField(
                                //controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: textInputDecoration.copyWith(
                                  label: const ResponsiveText(
                                      text: "Contact No.", size: 4.5),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    mobileNoTextController =
                                        val as TextEditingController;
                                    //mobileNo = val;
                                  });
                                },
                                validator: (val) {
                                  if (val!.length < 10) {
                                    return "Please enter an valid Mobile Number";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.02),
                              TextFormField(
                                controller: emailTextController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: textInputDecoration.copyWith(
                                  label: const ResponsiveText(
                                      text: "E-mail", size: 4.5),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    emailTextController =
                                        val as TextEditingController;
                                    //email = val;
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
                              SizedBox(height: mediaQuery.size.height * 0.02),
                              TextFormField(
                                obscureText: _obscureText,
                                controller: passwordTextController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: textInputDecoration.copyWith(
                                    label: const ResponsiveText(
                                        text: "Password", size: 4.5),
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
                                onChanged: (val) {
                                  setState(() {
                                    passwordTextController =
                                        val as TextEditingController;
                                    //password = val;
                                  });
                                },
                                validator: (val) {
                                  if (val!.length < 8) {
                                    return "Password must contain at least 8 characters";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.06),
                        SizedBox(
                          height: 5.h,
                          width: 40.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0XFF00AEEF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            onPressed: () {
                              register();
                            },
                            child: const ResponsiveText(
                                text: "Register", size: 4.5),
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.025),
                        Text.rich(TextSpan(
                          text: "Already have an Admin account!  ",
                          style:
                              TextStyle(fontSize: 4.5.sp, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Login In",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                    fontSize: 4.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: MyPrimaryColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const LoginScreen());
                                  })
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ),
      ));
    });
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullNameTextController.text,
              emailTextController.text, passwordTextController.text)
          .then((value) async {
        if (value == true) {
          // Saving the sf state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(emailTextController.text);
          await HelperFunctions.saveUserNameSF(fullNameTextController.text);
          // ignore: use_build_context_synchronously
          nextScreenReplace(context, const HomeScreen());
        } else {
          showSnackbar(context, Colors.red, value);
          _isLoading = false;
          nextScreenReplace(context, const LoginScreen());
        }
      });
    }
  }
}
