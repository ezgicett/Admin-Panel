import 'dart:convert';
import 'dart:io';

import 'package:bitirme_admin_panel/models/carousel.dart';
import 'package:bitirme_admin_panel/models/menu.dart';
import 'package:bitirme_admin_panel/models/menu_item.dart';
import 'package:bitirme_admin_panel/models/navbar_content.dart';
import 'package:bitirme_admin_panel/widgets/customized_widgets/pick_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;

class MenuScreen extends StatefulWidget {
  static const String id = 'menu-screen';

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int? selectedIndex;
  int? selectedIndex2;
  Menu? menu;
  MenuItem? menuItem;
  NavbarContent? navbarContent;
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController menuIdController = TextEditingController();
  TextEditingController menuNameController = TextEditingController();
  TextEditingController navbarLogoController = TextEditingController();
  TextEditingController navbarTitleController = TextEditingController();
  TextEditingController menuId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Choose Version of Menu",
              ),
            ),
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: DropdownButton<int>(
                      hint: const Text("Pick"),
                      value: selectedIndex,
                      items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                          .map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedIndex = newVal;
                        });
                      }),
                ),
                IconButton(
                    onPressed: () async {
                      await createMenu();
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "CREATE MENU ITEM",
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: menuIdController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Add Menu Id",
                        hintText: "Menu ID",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: menuNameController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Add Menu Name",
                        hintText: "Menu Name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  await createMenuItem();
                },
                child: const Text("Create")),
            const SizedBox(
              height: 50,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "CREATE NAVBAR CONTENT",
              ),
            ),
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: DropdownButton<int>(
                      hint: const Text("Pick Version"),
                      value: selectedIndex2,
                      items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                          .map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedIndex2 = newVal;
                        });
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: navbarLogoController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Add Logo",
                        hintText: "Logo",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: navbarTitleController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Add Title",
                        hintText: "Title",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await createNavBarContent();
                    },
                    child: const Text("Create")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  createMenu() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };
    //print("--" + selectedIndex.toString());
    menu = Menu(version: selectedIndex);

    var response = await http.post(
        Uri.parse("https://aifitness-web.herokuapp.com/navbar/addMenu"),
        headers: requestHeaders,
        body: jsonEncode(menu!.toJson()));
    var result = menuFromJson(response.body);
    menu = result;
    debugPrint(response.statusCode.toString());
    debugPrint(menu!.id.toString() + "-" + menu!.version.toString());
  }

  createMenuItem() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };
    print(int.parse(menuIdController.text));
    menuItem = MenuItem(
        menuId: int.parse(menuIdController.text),
        menuName: menuNameController.text.toString());
    var response = await http.post(
        Uri.parse("https://aifitness-web.herokuapp.com/navbar/createMenuItem"),
        headers: requestHeaders,
        body: jsonEncode(menuItem!.toJson()));
    var result = menuItemFromJson(response.body);
    menuItem = result;
    debugPrint(response.statusCode.toString());
    debugPrint(menuItem!.id.toString() + "-" + menuItem!.menuName.toString());
  }

  createNavBarContent() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };
    navbarContent = NavbarContent(
        menuVersion: selectedIndex2,
        logo: navbarLogoController.text.toString(),
        title: navbarTitleController.text.toString());
    var response = await http.post(
        Uri.parse(
            "https://aifitness-web.herokuapp.com/navbar/addNavbarContent"),
        headers: requestHeaders,
        body: jsonEncode(navbarContent!.toJson()));
    var result = navbarContentFromJson(response.body);
    navbarContent = result;
    debugPrint(response.statusCode.toString());
    debugPrint(navbarContent!.menuVersion.toString());
  }
}
