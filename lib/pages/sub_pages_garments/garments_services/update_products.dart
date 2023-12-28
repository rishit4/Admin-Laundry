import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panel_admin/common_widgets/my_snack_bar.dart';
import 'package:panel_admin/pages/sub_pages_garments/mens_wear.dart';
import 'package:sizer/sizer.dart';
import '../../../common_widgets/my_text_field.dart';
import '../../../common_widgets/responsive_text.dart';

class UpdateProductsPage extends StatefulWidget {
  static const String id = 'UpdateProductsPage';
  const UpdateProductsPage({super.key});

  @override
  State<UpdateProductsPage> createState() => _UpdateProductsPageState();
}

class _UpdateProductsPageState extends State<UpdateProductsPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController productController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  String imageUrl = '';
  File? _selectImage;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 5.sp, right: 30.sp, left: 30.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: mediaQuery.size.height * 0.05),
            const ResponsiveText(text: 'Add and Update Products', size: 8),
            SizedBox(height: mediaQuery.size.height * 0.15),
            TextFormField(
              controller: productController,
              keyboardType: TextInputType.text,
              decoration:
                  textInputDecoration.copyWith(hintText: 'Product type'),
              validator: (val) {
                if (val!.isNotEmpty) {
                  return null;
                } else {
                  return "This field cannot be empty";
                }
              },
              onChanged: (val) {
                setState(() {
                  productController = val as TextEditingController;
                  //fullName = val;
                });
              },
            ),
            SizedBox(height: mediaQuery.size.height * 0.03),
            TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.emailAddress,
              decoration: textInputDecoration.copyWith(hintText: 'Quantity'),
            ),
            SizedBox(height: mediaQuery.size.height * 0.03),
            Padding(
              padding: EdgeInsets.only(
                  right: 15.sp, left: 15.sp, top: 4.sp, bottom: 5.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 100.sp,
                        height: 100.sp,
                        child: _selectImage != null
                            ? Image.file(_selectImage!)
                            : const Text('Please Select Image'),
                        // child: ,
                      ),
                      TextButton(
                        onPressed: () {
                          _imagePick();
                        },
                        child: const Text('Upload'),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            clearProductDetails();
                          },
                          child: const Text('Clear')),
                      TextButton(
                          onPressed: () {
                            addProduct();
                          },
                          child: const Text('Add Product')),
                      TextButton(
                          onPressed: () {
                            Get.to(() => const MensWear());
                          },
                          child: const Text('Products List'))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//// function for pick image
  Future<void> _imagePick() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectImage = File(returnedImage.path);
      imageUrl = ''; // Clear the imageUrl before setting the new URL
    });
  }

////function for clear details
  void clearProductDetails() {
    setState(() {
      productController.clear();
      quantityController.clear();
      _selectImage = null;
      imageUrl = '';
    });
  }

//// function for adding products
  addProduct() async {
    if (productController.text.isEmpty) {
      showSnackbar(context, Colors.yellow.shade400, 'Please add Products');
      return;
    }
    var product = productController.text.trim();
    var quantity = quantityController.text.trim();
    //// Check if an image is selected
    if (_selectImage == null) {
      showSnackbar(context, Colors.yellow.shade400, 'Please Select an Image');
      return;
    }
//// Show loading indicator
    showDialog(
        context: context,
        barrierDismissible: false, // Prevent user from dismissing the dialog
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    CollectionReference reference =
        FirebaseFirestore.instance.collection('products');

    try {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance
          .ref()
          .child('product_images/$uniqueFileName.jpg');
//// Upload the image
      await referenceRoot.putFile(_selectImage!);
      String url = await referenceRoot.getDownloadURL();
      setState(() {
        imageUrl = url;
      });
      print('********************');
      print(product);
      print(quantity);
      print(imageUrl);

      await reference.add({
        'product': product,
        'quantity': quantity,
        'image': imageUrl,
      }).then((value) => {
            showSnackbar(context, Colors.blue.shade300,
                'Products are successfully Added'),
            Get.to(() => const MensWear()),
          });
    } catch (e) {
      showSnackbar(context, Colors.red.shade300, 'Something went Wrong, $e');
      print('error $e');
    }
  }
}
