import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DetailedRecords extends StatelessWidget {
  const DetailedRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed List of Orders'),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>>? combinedData = snapshot.data;

            return ListView.builder(
              itemCount: combinedData!.length,
              itemBuilder: (context, index) {
                final data = combinedData[index];
                return Padding(
                  padding:
                      EdgeInsets.only(right: 20.sp, left: 20.sp, top: 5.sp),
                  child: Card(
                    color: Colors.grey.shade100,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Name:  ${data['userName'].toString()}'),
                          Text('Email:  ${data['userEmail'].toString()}'),
                          Text('Contact No.:  ${data['userPhone'].toString()}'),
                          Text('Products:  ${data['otherItems'].toString()}'),
                          Text('Order:  ${data['selectedValues'].toString()}'),
                        ]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    // Sample data from two collections
    QuerySnapshot collection1 =
        await FirebaseFirestore.instance.collection('users').get();

    QuerySnapshot collection2 =
        await FirebaseFirestore.instance.collection('records').get();

    // Combine data from both collections
    List<Map<String, dynamic>> combinedData = [];

    collection1.docs.forEach((doc) {
      combinedData.add(doc.data() as Map<String, dynamic>);
    });

    collection2.docs.forEach((doc) {
      combinedData.add(doc.data() as Map<String, dynamic>);
    });

    return combinedData;
  }
}
