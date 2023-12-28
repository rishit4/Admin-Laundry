import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../auth_screens/login_screen.dart';
import '../auth_services/helper_functions.dart';
import '../common_widgets/my_routes.dart';
import '../pages/admin_pages/garments_list_page.dart';
import '../pages/sub_pages_garments/garments_services/update_products.dart';
import '../pages/sub_pages_records/records.dart';
import '../pages/sub_pages_garments/kids_wear.dart';
import '../pages/sub_pages_garments/mens_wear.dart';
import '../pages/sub_pages_garments/others.dart';
import '../pages/sub_pages_garments/womens_wear.dart';
import '../pages/admin_pages/user_list_page.dart';
import '../pages/sub_pages_users/insert_user.dart';

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
      case UserListPage.id:
        setState(() {
          _selectedScreen = const UserListPage();
        });
        break;
      case GarmentsListPage.id:
        setState(() {
          _selectedScreen = const GarmentsListPage();
        });
        break;
      case InsertUser.id:
        setState(() {
          _selectedScreen = const InsertUser();
        });
        break;
      case MensWear.id:
        setState(() {
          _selectedScreen = const MensWear();
        });
        break;
      case WomensWear.id:
        setState(() {
          _selectedScreen = const WomensWear();
        });
        break;
      case KidsWear.id:
        setState(() {
          _selectedScreen = const KidsWear();
        });
        break;
      case OthersWear.id:
        setState(() {
          _selectedScreen = const OthersWear();
        });
        break;
      case UpdateProductsPage.id:
        setState(() {
          _selectedScreen = const UpdateProductsPage();
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
          //// first lists for Config users
          AdminMenuItem(
              title: 'User Lists',
              icon: Icons.list_alt,
              //route: UserListPage.id,
              children: [
                AdminMenuItem(
                  title: 'Insert User',
                  icon: Icons.person_add_outlined,
                  route: InsertUser.id,
                ),
              ]),
          //// second lists for Garments OR Products
          AdminMenuItem(
              title: 'Garments Lists',
              icon: Icons.style,
              //route: GarmentsListPage.id,
              children: [
                AdminMenuItem(
                  title: 'Mens wear',
                  icon: Icons.male,
                  route: MensWear.id,
                ),
                AdminMenuItem(
                  title: 'Womens wear',
                  icon: Icons.female,
                  route: WomensWear.id,
                ),
                AdminMenuItem(
                  title: 'Kids wear',
                  icon: Icons.child_care,
                  route: KidsWear.id,
                ),
                AdminMenuItem(
                  title: 'Others',
                  icon: Icons.swap_horiz,
                  route: OthersWear.id,
                ),
              ]),
          //// third lists for adding products
          AdminMenuItem(
            title: 'ProductsPage',
            icon: Icons.shopping_cart,
            route: UpdateProductsPage.id,
          ),
          //// fourth lists for order of users
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
