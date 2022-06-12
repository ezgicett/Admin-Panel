import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:bitirme_admin_panel/models/menu.dart';
import 'package:bitirme_admin_panel/models/navbar_content.dart';
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
  TextEditingController menuName = TextEditingController();
  TextEditingController version = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController versionNavbar = TextEditingController();

  bool isUpdate = false;
  // Initial Selected Value
  Menu? dropdownvalue;
  Menu? dropdownvalueNavbar;

  List<Menu> menus = [];
  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

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
                    controller: version,
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
            Align(
              alignment: Alignment.topLeft,
              child: DropdownButton<Menu>(
                hint: Text('Choose Menu'),
                value: dropdownvalue,
                icon: Icon(Icons.check_circle_outline),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.blue[300],
                ),
                onChanged: (Menu? newValue) {
                  setState(() {
                    dropdownvalue = newValue;
                  });
                },
                items: menus.map<DropdownMenuItem<Menu>>((Menu value) {
                  return DropdownMenuItem<Menu>(
                    value: value,
                    child: Text("Id: " +
                        value.id.toString() +
                        ' ' +
                        "Version: " +
                        value.version.toString()),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: menuName,
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
                      createMenuItem();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: versionNavbar,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Menu Version",
                        hintText: "Menu Version",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                ),
                Expanded(
                  child: Container(),
                  flex: 1,
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Menu Title",
                        hintText: "Menu Title",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                ),
                Expanded(
                  child: Container(),
                  flex: 1,
                )
              ],
            ),
            PickImage(flag: false),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await createNavbarContent();
                },
                child: const Text("Create Navbar Content")),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                DropdownButton<Menu>(
                  hint: Text('Choose Menu'),
                  value: dropdownvalueNavbar,
                  icon: Icon(Icons.check_circle_outline),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.blue[300],
                  ),
                  onChanged: (Menu? newValue) {
                    setState(() {
                      dropdownvalueNavbar = newValue;
                    });
                  },
                  items: menus.map<DropdownMenuItem<Menu>>((Menu value) {
                    //var ids = value.menuItems!.first.id ?? '';
                    return DropdownMenuItem<Menu>(
                      value: value,
                      child: Text("Id: " +
                              value.id.toString() +
                              ' ' +
                              "Version: " +
                              value.version.toString() +
                              ' '
                          //ids.toString()
                          // ' ' +
                          // value.menuItems!.first.menuName.toString(),
                          ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await createNavbarContent();
                },
                child: const Text("Create Navbar")),
            const SizedBox(
              height: 30,
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
      body: json.encode({'version': int.parse(version.text)}),
    );
    setState(() {
      fetchMenus();
    });
    //var result = json.decode(response.body);
    //print(result);
  }

  createMenuItem() async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
      'Content-type': 'application/json',
    };

    var response = await http.post(
      Uri.parse("https://aifitness-web.herokuapp.com/navbar/createMenuItem"),
      headers: requestHeaders,
      body: json
          .encode(MenuuItem(id: dropdownvalue!.id, menuName: menuName.text)),
    );
    print(menuName.text);
    //var result = json.decode(response.body);
    print(response.statusCode.toString());
  }

  createNavbarContent() async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
      'Content-type': 'application/json',
    };

    var response = await http.post(
      Uri.parse("https://aifitness-web.herokuapp.com/navbar/addNavbarContent"),
      headers: requestHeaders,
      body: json.encode(
        NavbarContent(
          menuVersion: int.parse(versionNavbar.text),
          logo: PickImage(flag: true).getBase64,
          title: title.text.toString(),
        ),
      ),
    );
    //var result = json.decode(response.body);
    print(response.statusCode.toString());
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

    setState(() {
      menus = List<Menu>.from(
          json.decode(response.body).map((data) => Menu.fromJson(data)));
    });
  }
}
