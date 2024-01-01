import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panel_admin/firebase_options.dart';
import 'package:panel_admin/pages/admin_pages/intro_page.dart';
import 'package:sizer/sizer.dart';
import 'auth_screens/login_screen.dart';
import 'auth_services/helper_functions.dart';
import 'boarding_screens/home_page.dart';
import 'pages/admin_pages/products.dart';
import 'pages/admin_pages/records.dart';
import 'pages/users_services/user_update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Builder(builder: (BuildContext context) {
        return GetMaterialApp(
          title: 'Admin Panel',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: _isSignedIn ? const HomeScreen() : const LoginScreen(),
          ////
          //initialRoute: _isSignedIn ? HomeScreen.id : LoginScreen.id,
          routes: {
            HomeScreen.id: (context) => const HomeScreen(),
            UserListPage.id: (context) => const UserListPage(),
            UserUpdateScreen.id: (context) => const UserUpdateScreen(),
            RecordsPage.id: (context) => const RecordsPage(),
            Products.id: (context) => const Products(),
          },
        );
      });
    });
  }
}
