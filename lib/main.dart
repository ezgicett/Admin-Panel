import 'package:bitirme_admin_panel/screens/carousel_screen.dart';
import 'package:bitirme_admin_panel/screens/carousel_screen_operations.dart';
import 'package:bitirme_admin_panel/screens/dashboard_screen.dart';
import 'package:bitirme_admin_panel/screens/developer_screen.dart';
import 'package:bitirme_admin_panel/screens/developer_screen_operations.dart';
import 'package:bitirme_admin_panel/screens/home_screen.dart';
import 'package:bitirme_admin_panel/screens/login_screen.dart';
import 'package:bitirme_admin_panel/screens/navbar_screen.dart';
import 'package:bitirme_admin_panel/screens/welcome_screen.dart';
import 'package:bitirme_admin_panel/screens/welcome_screen_operations.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        DeveloperScreen.id: (context) => DeveloperScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        CarouselScreen.id: (context) => CarouselScreen(),
        WelcomeScreenOperations.id: (context) => WelcomeScreenOperations(),
        DeveloperScreenOperations.id: (context) => DeveloperScreenOperations(),
        CarouselScreenOperations.id: (context) => CarouselScreenOperations(),
        NavbarScreen.id: (context) => NavbarScreen()
      },
    );
  }
}
