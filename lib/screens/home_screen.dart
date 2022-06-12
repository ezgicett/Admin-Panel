import 'package:bitirme_admin_panel/models/navbar.dart';
import 'package:bitirme_admin_panel/screens/carousel_screen.dart';
import 'package:bitirme_admin_panel/screens/carousel_screen_operations.dart';
import 'package:bitirme_admin_panel/screens/dashboard_screen.dart';
import 'package:bitirme_admin_panel/screens/developer_screen.dart';
import 'package:bitirme_admin_panel/screens/developer_screen_operations.dart';
import 'package:bitirme_admin_panel/screens/login_screen.dart';
import 'package:bitirme_admin_panel/screens/navbar_screen.dart';
import 'package:bitirme_admin_panel/screens/welcome_screen_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'welcome_screen.dart';

//import 'package:flutter_admin_scaffold/src/menu_item.dart' as MenuItem;

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  Widget? selectedScreen = DashboardScreen();

  //HomeScreen({this.selectedScreen});
  HomeScreen({Key? key, this.selectedScreen}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  currentScreen(item) {
    switch (item.route) {
      case DashboardScreen.id:
        setState(() {
          widget.selectedScreen = DashboardScreen();
        });
        break;

      case DeveloperScreen.id:
        setState(() {
          widget.selectedScreen = DeveloperScreen();
        });
        break;
      case WelcomeScreen.id:
        setState(() {
          widget.selectedScreen = WelcomeScreen();
        });
        break;
      case CarouselScreen.id:
        setState(() {
          widget.selectedScreen = CarouselScreen();
        });
        break;
      case WelcomeScreenOperations.id:
        setState(() {
          widget.selectedScreen = WelcomeScreenOperations();
        });
        break;
      case DeveloperScreenOperations.id:
        setState(() {
          widget.selectedScreen = DeveloperScreenOperations();
        });
        break;
      case CarouselScreenOperations.id:
        setState(() {
          widget.selectedScreen = CarouselScreenOperations();
        });
        break;
      case NavbarScreen.id:
        setState(() {
          widget.selectedScreen = NavbarScreen();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
          child: Text("Admin Panel"),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashboardScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Developer Screen',
            route: DeveloperScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Welcome Screen',
            route: WelcomeScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Carousel Screen',
            route: CarouselScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Welcome Operations Screen',
            route: WelcomeScreenOperations.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Developer Operations Screen',
            route: DeveloperScreenOperations.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Carousel Operations Screen',
            route: CarouselScreenOperations.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'NavBar Screen',
            route: NavbarScreen.id,
            icon: Icons.dashboard,
          ),
        ],
        selectedRoute: HomeScreen.id,
        onSelected: (item) {
          currentScreen(item);
        },
      ),
      body: SingleChildScrollView(
        child: widget.selectedScreen,
      ),
    );
  }
}
