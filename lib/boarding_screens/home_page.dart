import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../auth_screens/login_screen.dart';
import '../auth_services/helper_functions.dart';
import '../common_widgets/my_routes.dart';
import '../pages/admin_pages/products.dart';
import '../pages/admin_pages/records.dart';
import '../pages/admin_pages/intro_page.dart';
import '../pages/admin_pages/users.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  Widget _selectedScreen = const UserListPage();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  currentScreen(item) {
    switch (item.route) {
      case Users.id:
        setState(() {
          _selectedScreen = const Users();
        });
        break;
      case UserListPage.id:
        setState(() {
          _selectedScreen = const UserListPage();
        });
        break;
      case Products.id:
        setState(() {
          _selectedScreen = const Products();
        });
        break;
      case RecordsPage.id:
        setState(() {
          _selectedScreen = const RecordsPage();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future signOut() async {
      try {
        await HelperFunctions.saveUserLoggedInStatus(false);
        await HelperFunctions.saveUserNameSF("");
        await HelperFunctions.saveUserEmailSF("");
        await firebaseAuth.signOut();
        // ignore: use_build_context_synchronously
        nextScreenReplace(context, const LoginScreen());
      } catch (e) {
        return null;
      }
    }

    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton.outlined(
              onPressed: signOut, icon: const Icon(Icons.logout)),
        ],
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Insert User',
            icon: Icons.person_add_outlined,
            route: Users.id,
          ),
          AdminMenuItem(
            title: 'ProductsPage',
            icon: Icons.shopping_cart,
            route: Products.id,
          ),
          AdminMenuItem(
            title: 'Records',
            icon: Icons.receipt_long_outlined,
            route: RecordsPage.id,
          ),
        ],
        selectedRoute: HomeScreen.id,
        onSelected: (item) {
          currentScreen(item);
        },
      ),
      body: SingleChildScrollView(child: _selectedScreen),
    );
  }
}
