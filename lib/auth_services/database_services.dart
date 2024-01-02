import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // Reference for our Collections
  final CollectionReference adminCollection =
      FirebaseFirestore.instance.collection("Admin");

  // Saving the UserData
  Future savingUserdata(String fullName, String email, String password) async {
    return await adminCollection.doc(uid).set({
      "Full Name": fullName,
      "E-mail": email,
      "Password": password,
      "Unique Id": uid,
      'Created At': DateTime.now(),
    });
  }

  // Getting UserData
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await adminCollection.where("E-mail", isEqualTo: email).get();
    return snapshot;
  }
}
