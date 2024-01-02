// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import '../../../common_widgets/my_snack_bar.dart';
// import '../../../common_widgets/my_text_field.dart';
// import 'users_list.dart';
//
// class UpdateUsers extends StatefulWidget {
//   static const String id = "UserUpdate-Screen";
//
//   const UpdateUsers({Key? key}) : super(key: key);
//
//   @override
//   State<UpdateUsers> createState() => _InsertUserState();
// }
//
// class _InsertUserState extends State<UpdateUsers> {
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//     TextEditingController upNameController = TextEditingController();
//     TextEditingController upEmailController = TextEditingController();
//     TextEditingController upPhoneController = TextEditingController();
//     TextEditingController upAddressController = TextEditingController();
//
//     void clearText() {
//       upNameController.clear();
//       upEmailController.clear();
//       upPhoneController.clear();
//       upAddressController.clear();
//     }
//
//     return Form(
//         key: _formKey,
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Update Users'),
//           ),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.only(top: 20, right: 25.sp, left: 25.sp),
//               child: Column(
//                 children: [
//                   SizedBox(height: mediaQuery.size.height * 0.1),
//                   TextFormField(
//                     controller: upNameController
//                       ..text = Get.arguments['User Name'].toString(),
//                     decoration:
//                         textInputDecoration.copyWith(hintText: 'User Name'),
//                   ),
//                   SizedBox(height: mediaQuery.size.height * 0.03),
//                   TextFormField(
//                     controller: upEmailController
//                       ..text = Get.arguments['User E-mail'].toString(),
//                     decoration:
//                         textInputDecoration.copyWith(hintText: 'User Email'),
//                   ),
//                   SizedBox(height: mediaQuery.size.height * 0.03),
//                   TextFormField(
//                     controller: upPhoneController
//                       ..text = Get.arguments['User Contact-No'],
//                     decoration: textInputDecoration.copyWith(
//                       hintText: 'User Contact No.',
//                     ),
//                   ),
//                   SizedBox(height: mediaQuery.size.height * 0.03),
//                   TextFormField(
//                     controller: upAddressController
//                       ..text = Get.arguments['User Address'].toString(),
//                     decoration: textInputDecoration.copyWith(
//                       hintText: 'User Address',
//                     ),
//                   ),
//                   SizedBox(height: mediaQuery.size.height * 0.1),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                           onPressed: () {
//                             clearText();
//                           },
//                           child: const Text('Clear')),
//                       ElevatedButton(
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//                               await FirebaseFirestore.instance
//                                   .collection("users")
//                                   .doc(Get.arguments['docId'].toString())
//                                   .update({
//                                 'User Name': upNameController.text.trim(),
//                                 'User E-mail': upEmailController.text.trim(),
//                                 'User Contact-No':
//                                     upPhoneController.text.trim(),
//                                 'User Address': upAddressController.text.trim(),
//                               }).then((value) => {
//                                         showSnackbar(
//                                             context,
//                                             Colors.green.shade200,
//                                             'User successfully Updated'),
//                                         Get.to(() => const UsersList())
//                                       });
//                             } else {
//                               showSnackbar(context, Colors.red.shade300,
//                                   'Something went Wrong');
//                             }
//                           },
//                           child: const Text('Update')),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../common_widgets/my_snack_bar.dart';
import '../../../common_widgets/my_text_field.dart';
import 'users_list.dart';

class UpdateUsers extends StatefulWidget {
  static const String id = "UserUpdate-Screen";

  const UpdateUsers({Key? key}) : super(key: key);

  @override
  State<UpdateUsers> createState() => _InsertUserState();
}

class _InsertUserState extends State<UpdateUsers> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    // Check if Get.arguments is not null and has the expected keys
    Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;

    // If Get.arguments is null or doesn't contain the expected keys, set default values
    String userName = arguments?['User Name']?.toString() ?? '';
    String userEmail = arguments?['User E-mail']?.toString() ?? '';
    String userContactNo = arguments?['User Contact-No']?.toString() ?? '';
    String userAddress = arguments?['User Address']?.toString() ?? '';

    TextEditingController upNameController =
        TextEditingController(text: userName);
    TextEditingController upEmailController =
        TextEditingController(text: userEmail);
    TextEditingController upPhoneController =
        TextEditingController(text: userContactNo);
    TextEditingController upAddressController =
        TextEditingController(text: userAddress);

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
                  controller: upNameController,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'User Name'),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                TextFormField(
                  controller: upEmailController,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'User Email'),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                TextFormField(
                  controller: upPhoneController,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'User Contact No.'),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                TextFormField(
                  controller: upAddressController,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'User Address'),
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
                      child: const Text('Clear'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(arguments?['docId']?.toString() ?? '')
                              .update({
                            'User Name': upNameController.text.trim(),
                            'User E-mail': upEmailController.text.trim(),
                            'User Contact-No': upPhoneController.text.trim(),
                            'User Address': upAddressController.text.trim(),
                          }).then((value) => {
                                    showSnackbar(context, Colors.green.shade200,
                                        'User successfully Updated'),
                                    Get.to(() => const UsersList())
                                  });
                        } else {
                          showSnackbar(context, Colors.red.shade300,
                              'Something went Wrong');
                        }
                      },
                      child: const Text('Update'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
