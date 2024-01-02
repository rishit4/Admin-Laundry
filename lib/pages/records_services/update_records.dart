import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panel_admin/pages/records_services/combin_data.dart';
import 'package:sizer/sizer.dart';
import '../../common_widgets/my_snack_bar.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Records'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                    final userName =
                        snapshot.data!.docs[index]['User Name'].toString();
                    final userEmail =
                        snapshot.data!.docs[index]['User E-mail'].toString();
                    return Padding(
                      padding:
                          EdgeInsets.only(top: 10, right: 25.sp, left: 25.sp),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const DetailedRecords());
                        },
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
                                    // arguments: {
                                    //   'selectedValues': selectedValues,
                                    //   'otherItems': otherItems,
                                    //   //'image': image,
                                    // });
                                  },
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(docId)
                                        .delete();
                                    showSnackbar(context, Colors.red.shade300,
                                        'Data removed Successfully ');
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
