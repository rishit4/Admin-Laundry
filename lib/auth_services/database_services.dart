import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // Reference for our Collections
  final CollectionReference adminCollection =
      FirebaseFirestore.instance.collection("Admin");
  // final CollectionReference userCollection =
  //     FirebaseFirestore.instance.collection("User");

  // Saving the UserData
  Future savingUserdata(String fullName, String email, String password) async {
    return await adminCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "password": password,
      //"userData": 'userData',
      //"bio": 'Empty Bio...',
      "uid": uid,
    });
  }

  // Getting UserData
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await adminCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}
