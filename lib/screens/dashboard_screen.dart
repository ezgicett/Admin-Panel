import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String id = 'dashboard-screen';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Dashboard Screen",
        style: TextStyle(fontSize: 30, color: Colors.blue),
      ),
    );
  }
}
