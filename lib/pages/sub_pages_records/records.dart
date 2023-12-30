import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:panel_admin/pages/sub_pages_records/update_records.dart';
import 'package:sizer/sizer.dart';
import '../../common_widgets/my_snack_bar.dart';
import '../../common_widgets/my_text_field.dart';

class RecordsPage extends StatefulWidget {
  static const String id = 'Orders-Page';

  const RecordsPage({Key? key}) : super(key: key);

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  late Stream<List<MultiSelectItem<String>>> usersStream;
  late Stream<List<MultiSelectItem<String>>> productsStream;
  List<String> selectedUsers = [];
  List<String> selectedProducts = [];
  TextEditingController otherItemsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usersStream = getUsersStream();
    productsStream = getProductsStream();
  }

  Stream<List<MultiSelectItem<String>>> getUsersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((user) {
        return MultiSelectItem<String>(
          user['userName'],
          user['userName'],
        );
      }).toList();
    });
  }

  Stream<List<MultiSelectItem<String>>> getProductsStream() {
    return FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((product) {
        return MultiSelectItem<String>(
          product['product'],
          product['product'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(right: 20.sp, left: 20.sp, top: 10.sp),
        child: Column(
          children: [
            StreamBuilder<List<MultiSelectItem<String>>>(
              stream: usersStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                List<MultiSelectItem<String>> usersItems = snapshot.data!;
                return MultiSelectDialogField(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.grey.shade200,
                  buttonText: const Text('Select Users'),
                  title: const Text('Select Users'),
                  items: usersItems,
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    setState(() {
                      selectedUsers = values;
                    });
                  },
                );
              },
            ),
            SizedBox(height: mediaQuery.size.height * 0.03),
            StreamBuilder<List<MultiSelectItem<String>>>(
              stream: productsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                List<MultiSelectItem<String>> productsItems = snapshot.data!;
                return MultiSelectDialogField(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.grey.shade200,
                  buttonText: const Text('Select Products'),
                  title: const Text('Select Products'),
                  items: productsItems,
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    setState(() {
                      selectedProducts = values;
                    });
                  },
                );
              },
            ),
            SizedBox(height: mediaQuery.size.height * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormField(
                  controller: otherItemsController,
                  keyboardType: TextInputType.text,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Other Items',
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                ElevatedButton(
                  onPressed: () {
                    saveToRecordPage(
                      selectedUsers,
                      selectedProducts,
                      otherItemsController.text,
                    );
                    setState(() {
                      selectedUsers.clear();
                      selectedProducts.clear();
                      otherItemsController.clear();
                    });
                  },
                  child: const Text('Save to Record Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const RecordScreen());
                  },
                  child: const Text('Record List'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveToRecordPage(
    List<String> selectedUsers,
    List<String> selectedProducts,
    String otherItems,
  ) async {
    if (selectedProducts.isNotEmpty) {
      await FirebaseFirestore.instance.collection('records').add({
        'userName': selectedUsers,
        'otherItems': otherItems,
        'selectedValues': selectedProducts,
        'timestamp': FieldValue.serverTimestamp(),
      });
      showSnackbar(context, Colors.blue.shade300, 'Data saved to Record');
      Get.to(() => const RecordScreen());
    } else {
      showSnackbar(context, Colors.red.shade300, 'Select at least 1 Product');
    }
  }
}
