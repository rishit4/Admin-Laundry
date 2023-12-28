import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../update_user.dart';

signUpUser(
  String userName,
  String userEmail,
  String userPassword,
  String userPhone,
  String userAddress,
) async {
  User? userId = FirebaseAuth.instance.currentUser;
  try {
    FirebaseFirestore.instance.collection("users").doc(userId!.uid).set({
      'userName': userName,
      'userEmail': userEmail,
      'userPassword': userPassword,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'Created At': DateTime.now(),
      'userId': userId.uid,
    }).then((value) => {
          Get.to(() => const UpdateUser()),
        });
  } on FirebaseAuthException catch (e) {
    print('FIREBASE AUTH ERROR $e');
  }
}
