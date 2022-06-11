import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:bitirme_admin_panel/models/welcome_page.dart';
import 'package:bitirme_admin_panel/widgets/customized_widgets/pick_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;

class NavbarScreen extends StatefulWidget {
  static const String id = 'navbar-screen';

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  bool flag = false;
  Color? color;
  int selectedIndex = -1;
  TextEditingController sloganController = TextEditingController();
  bool isUpdate = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: sloganController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Menu Version",
                        hintText: "Menu Version",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                    ),
                    iconSize: 25,
                    color: Colors.green,
                    splashColor: Colors.purple,
                    onPressed: () {
                      createMenu();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: sloganController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Menu Name",
                        hintText: "Menu Name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                    ),
                    iconSize: 25,
                    color: Colors.green,
                    splashColor: Colors.purple,
                    onPressed: () {
                      fetchMenus();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  createMenu() async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
      'Content-type': 'application/json',
    };

    var response = await http.post(
      Uri.parse("https://aifitness-web.herokuapp.com/navbar/addMenu"),
      headers: requestHeaders,
      body: json.encode({'version': 0}),
    );
    //var result = json.decode(response.body);
    //print(result);
  }

  fetchMenus() async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
    };

    var response = await http.get(
      Uri.parse("https://aifitness-web.herokuapp.com/navbar/getallmenus"),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS"
      },
    );
    print(response.statusCode.toString());
  }
}
