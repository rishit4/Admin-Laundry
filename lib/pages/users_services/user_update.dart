import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../common_widgets/my_snack_bar.dart';
import '../../../common_widgets/my_text_field.dart';
import 'users_list.dart';

class UserUpdateScreen extends StatefulWidget {
  static const String id = "UserUpdate-Screen";

  const UserUpdateScreen({Key? key}) : super(key: key);

  @override
  State<UserUpdateScreen> createState() => _InsertUserState();
}

class _InsertUserState extends State<UserUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    TextEditingController upNameController = TextEditingController();
    TextEditingController upEmailController = TextEditingController();
    TextEditingController upPhoneController = TextEditingController();
    TextEditingController upAddressController = TextEditingController();

    void clearText() {
      upNameController.clear();
      upEmailController.clear();
      upPhoneController.clear();
      upAddressController.clear();
    }

    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Update Users'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 20, right: 25.sp, left: 25.sp),
              child: Column(
                children: [
                  SizedBox(height: mediaQuery.size.height * 0.1),
                  TextFormField(
                    controller: upNameController
                      ..text = Get.arguments['userName'].toString(),
                    decoration:
                        textInputDecoration.copyWith(hintText: 'User Name'),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  TextFormField(
                    controller: upEmailController
                      ..text = Get.arguments['userEmail'].toString(),
                    decoration:
                        textInputDecoration.copyWith(hintText: 'User Email'),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  TextFormField(
                    controller: upPhoneController
                      ..text = Get.arguments['userPhone'],
                    decoration: textInputDecoration.copyWith(
                      hintText: 'User Contact No.',
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  TextFormField(
                    controller: upAddressController
                      ..text = Get.arguments['userAddress'].toString(),
                    decoration: textInputDecoration.copyWith(
                      hintText: 'User Address',
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            clearText();
                          },
                          child: const Text('Clear')),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // showDialog(
                              //     context: context,
                              //     barrierDismissible:
                              //         false, // Prevent user from dismissing the dialog
                              //     builder: (context) {
                              //       return const Center(
                              //         child: CircularProgressIndicator(),
                              //       );
                              //     });
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(Get.arguments['docId'].toString())
                                  .update({
                                'userName': upNameController.text.trim(),
                                'userEmail': upEmailController.text.trim(),
                                'userPhone': upPhoneController.text.trim(),
                                'userAddress': upAddressController.text.trim(),
                              }).then((value) => {
                                        //Navigator.pop(context),
                                        showSnackbar(
                                            context,
                                            Colors.green.shade200,
                                            'User successfully Updated'),
                                        Get.to(() => const UpdateUser())
                                      });
                            } else {
                              showSnackbar(context, Colors.red.shade300,
                                  'Something went Wrong');
                            }
                          },
                          child: const Text('Update')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
