import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:bitirme_admin_panel/models/developer.dart';
import 'package:bitirme_admin_panel/models/welcome_page.dart';
import 'package:bitirme_admin_panel/screens/home_screen.dart';
import 'package:bitirme_admin_panel/screens/utils.dart';
import 'package:bitirme_admin_panel/screens/welcome_screen.dart';
import 'package:bitirme_admin_panel/widgets/scrollable_widget.dart';
import 'package:bitirme_admin_panel/widgets/text_dialog_widget.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;

class DeveloperScreenOperations extends StatefulWidget {
  static const String id = 'developer-screen-operations';

  @override
  State<DeveloperScreenOperations> createState() =>
      _DeveloperScreenOperationsState();
}

class _DeveloperScreenOperationsState extends State<DeveloperScreenOperations> {
  XFile? _image;
  String? imageUrl;
  bool flag = false;
  Color? color;
  int selectedIndex = -1;
  List<Developer> list = [];

  TextEditingController sloganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDevelopers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchDevelopers(),
        builder: (contex, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: <Widget>[
                        //ScrollableWidget(child: buildDataTable()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget buildDataTable() {
    final columns = [
      'Id',
      'Name',
      'Specialized Field',
      'Image',
      'Gmail',
      'Linkedin',
      'Tweeter',
      '#',
      '-'
    ];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(list),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      final isAge = column == columns[2];

      return DataColumn(
        label: Text(column),
        numeric: isAge,
      );
    }).toList();
  }

  List<DataRow> getRows(List<Developer> users) => users.map((Developer page) {
        Icon deleteIcon = Icon(Icons.delete);
        final cells = [
          page.id,
          page.developerName,
          page.developerSpecializedField,
          page.developerImage,
          page.createSocialMediaRequests![0],
          page.createSocialMediaRequests![1],
          page.createSocialMediaRequests![2],
          "#",
          deleteIcon
        ];

        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            final showEditIcon = index == 0 || index == 3;
            if (cell.runtimeType == Icon) {
              return DataCell(Icon(Icons.delete), onTap: () {});
            } else {
              return DataCell(
                Text('$cell'),
                showEditIcon: showEditIcon,
                onTap: () {
                  switch (index) {
                    case 0:
                      editFirstName(page);
                      break;
                    case 3:
                      editLastName(page);
                      break;
                  }
                },
              );
            }
          }),
        );
      }).toList();

  Future editFirstName(Developer page) async {
    // final firstName = await showTextDialog(
    //   context,
    //   slogan: 'Change Id',
    //   slogan_value: page.id.toString(),
    // );
  }

  Future editLastName(Developer selectedPage) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(
              selectedScreen: WelcomeScreen(),
            )));
    // Navigator.of(context).pushNamed(WelcomeScreen.id);
    //Navigator.push(context, );
  }

  Future<List<Developer>> fetchDevelopers() async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
    };
    try {
      final response = await http.get(
          Uri.parse("https://aifitness-web.herokuapp.com/developer/getall"),
          headers: requestHeaders);
      //print(response.);

      // list = List<Developer>.from(
      //     response.body.map((data) => Developer.fromJson(data)));

      // var data1 = json.encode(response.body);
      // list = List<Developer>.from(
      //     json.decode(data1).map((data) => Developer.fromJson(data)));
      // for (var i = 0; i < list.length; i++) {
      //   print(list.length);
      // }

      //  _createSo(){
      //     CreateSocialMediaRequest createReq = CreateSocialMediaRequest(
      //     link: "",
      //     developerId: 17,
      //     socialMedia: "LINKEDIN",
      //     );
      //   }
      // list = json
      //     .decode(response.body)
      //     .map((data) => Developer.fromJson(data ?? ' '))
      //     .toList();

      // var jsonData = developerFromJson(response.body) as List<Developer>;
      // Developer dev = Developer(
      //     developerName: jsonData[0].developerName,
      //     developerImage: "a",
      //     developerSpecializedField: jsonData[0].developerSpecializedField,
      //     createSocialMediaRequests: jsonData[0].createSocialMediaRequests);
      // list.add(dev);

    } catch (e) {
      debugPrint(e.toString());
    }

    return list;
  }
}
