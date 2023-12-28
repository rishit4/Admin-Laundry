import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../common_widgets/my_snack_bar.dart';

class MensWear extends StatelessWidget {
  static const String id = "Mens_wear";

  const MensWear({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Products'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("products").snapshots(),
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
                    final product = snapshot.data!.docs[index]['product'];
                    final quantity =
                        snapshot.data!.docs[index]['quantity'].toString();
                    final image = snapshot.data!.docs[index]['image'];
                    return Padding(
                      padding:
                          EdgeInsets.only(top: 10, right: 25.sp, left: 25.sp),
                      child: Card(
                        color: Colors.grey.shade100,
                        child: ListTile(
                          leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.network(image)),
                          title: Text(product),
                          subtitle: Text(quantity),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // arguments: {
                                  //   'product': product,
                                  //   'quantity': quantity,
                                  //   //'image': image,
                                  // });
                                },
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("products")
                                      .doc(docId)
                                      .delete();
                                  showSnackbar(context, Colors.red.shade300,
                                      'Products are removed Successfully');
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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
        ));
  }
}
