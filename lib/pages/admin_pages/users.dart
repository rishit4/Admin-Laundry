// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../common_widgets/my_snack_bar.dart';
import '../../common_widgets/my_text_field.dart';
import '../../common_widgets/responsive_text.dart';
import '../users_services/signup_services.dart';
import '../users_services/users_list.dart';

class Users extends StatefulWidget {
  static const String id = 'Insert_User';

  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _InsertUserState();
}

class _InsertUserState extends State<Users> {
  final _formKey = GlobalKey<FormState>();
  User? currentUser = FirebaseAuth.instance.currentUser;

  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    void clearText() {
      setState(() {
        userNameController.clear();
        userEmailController.clear();
        userPasswordController.clear();
        userPhoneController.clear();
        userAddressController.clear();
      });
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 5.sp, right: 30.sp, left: 30.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: mediaQuery.size.height * 0.05),
            const ResponsiveText(text: 'Add and Update Users', size: 8),
            SizedBox(height: mediaQuery.size.height * 0.15),
            TextFormField(
              controller: userNameController,
              keyboardType: TextInputType.text,
              decoration: textInputDecoration.copyWith(
                label: const ResponsiveText(text: 'Full name', size: 4.5),
              ),
              validator: (val) {
                if (val!.isNotEmpty) {
                  return null;
                } else {
                  return "Name cannot be empty";
                }
              },
              onChanged: (val) {
                setState(() {
                  userNameController = val as TextEditingController;
                  //fullName = val;
                });
              },
            ),
            SizedBox(height: mediaQuery.size.height * 0.03),
            TextFormField(
              controller: userEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: textInputDecoration.copyWith(
                label: const ResponsiveText(text: 'E-mail', size: 4.5),
              ),
              validator: (val) {
                return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                    ? null
                    : "please enter an valid Email";
              },
              onChanged: (val) {
                setState(() {
                  userEmailController = val as TextEditingController;
                  //fullName = val;
                });
              },
            ),
            SizedBox(height: mediaQuery.size.height * 0.03),
            TextFormField(
              controller: userPasswordController,
              keyboardType: TextInputType.text,
              decoration: textInputDecoration.copyWith(
                label: const ResponsiveText(text: 'Password', size: 4.5),
              ),
              validator: (val) {
                if (val!.length < 8) {
                  return "Password must contain at least 8 characters";
                } else {
                  return null;
                }
              },
              onChanged: (val) {
                setState(() {
                  userPasswordController = val as TextEditingController;
                  //fullName = val;
                });
              },
            ),
            SizedBox(height: mediaQuery.size.height * 0.03),
            TextFormField(
              controller: userPhoneController,
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(
                label: const ResponsiveText(text: 'Contact No.', size: 4.5),
              ),
              validator: (val) {
                if (val!.length < 10) {
                  return "Please enter an valid Mobile Number";
                } else {
                  return null;
                }
              },
              onChanged: (val) {
                setState(() {
                  userPhoneController = val as TextEditingController;
                  //fullName = val;
                });
              },
            ),
            SizedBox(height: mediaQuery.size.height * 0.03),
            TextFormField(
              controller: userAddressController,
              keyboardType: TextInputType.text,
              decoration: textInputDecoration.copyWith(
                label: const ResponsiveText(text: 'Address', size: 4.5),
              ),
              validator: (val) {
                if (val!.isNotEmpty) {
                  return null;
                } else {
                  return "This filed cannot be empty";
                }
              },
              onChanged: (val) {
                setState(() {
                  userAddressController = val as TextEditingController;
                  //fullName = val;
                });
              },
            ),
            SizedBox(height: mediaQuery.size.height * 0.03),
            Padding(
              padding: EdgeInsets.only(right: 15.sp, left: 15.sp, top: 4.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await addUsers();
                        clearText();
                      },
                      child: const Text('Add User')),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => const UpdateUser());
                      },
                      child: const Text('Users List'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//// function for add users
  addUsers() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false, // Prevent user from dismissing the dialog
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      var userName = userNameController.text.trim();
      var userEmail = userEmailController.text.trim();
      var userPassword = userPasswordController.text.trim();
      var userPhone = userPhoneController.text.trim();
      var userAddress = userAddressController.text.trim();

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userEmail, password: userPassword)
          .then((value) => {
                Navigator.pop(context),
                showSnackbar(
                    context, Colors.green.shade200, 'User successfully Added'),
                signUpUser(
                  userName,
                  userEmail,
                  userPassword,
                  userPhone,
                  userAddress,
                ),
                Get.to(() => const UpdateUser())
              });
    } else {
      showSnackbar(context, Colors.red.shade300, 'Something went Wrong');
    }
  }
}
