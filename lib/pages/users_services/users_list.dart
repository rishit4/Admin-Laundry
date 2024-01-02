// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../common_widgets/my_snack_bar.dart';
import 'user_update.dart';

class UsersList extends StatelessWidget {
  static const String id = 'Update_User';

  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Users'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Data found!'));
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final docId = snapshot.data!.docs[index].id;
                  final userName = snapshot.data!.docs[index]['User Name'];
                  final userEmail = snapshot.data!.docs[index]['User E-mail'];
                  final userPhone =
                      snapshot.data!.docs[index]['User Contact-No'];
                  final userAddress =
                      snapshot.data!.docs[index]['User Address'];
                  return Padding(
                    padding:
                        EdgeInsets.only(top: 10, right: 25.sp, left: 25.sp),
                    child: Card(
                      color: Colors.grey.shade100,
                      child: ListTile(
                        title: Text(userName),
                        subtitle: Text(userEmail),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.to(() => const UserUpdateScreen(),
                                    arguments: {
                                      'docId': docId,
                                      'User Name': userName,
                                      'User E-mail': userEmail,
                                      'User Contact-No': userPhone,
                                      'User Address': userAddress,
                                    });
                              },
                              icon: const Icon(Icons.edit, color: Colors.blue),
                            ),
                            IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(docId)
                                    .delete();
                                showSnackbar(context, Colors.red.shade300,
                                    'User removed Successfully');
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
