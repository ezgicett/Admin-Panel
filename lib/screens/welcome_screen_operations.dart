import 'dart:convert';
import 'dart:html';
import 'dart:io';

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

class WelcomeScreenOperations extends StatefulWidget {
  static const String id = 'welcome-screen-operations';
  static List<WelcomePage> allPages = [];

  @override
  State<WelcomeScreenOperations> createState() =>
      _WelcomeScreenOperationsState();
}

class _WelcomeScreenOperationsState extends State<WelcomeScreenOperations> {
  XFile? _image;
  String? imageUrl;
  bool flag = false;
  Color? color;
  int selectedIndex = -1;
  late List<WelcomePage> list =
      WelcomeScreenOperations.allPages; //WelcomeScreen.pages;
  TextEditingController sloganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPages();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPages(),
        builder: (contex, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: <Widget>[
                        ScrollableWidget(child: buildDataTable()),
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
    final columns = ['Id', 'Slogan', 'Image', '-'];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(list),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      final isAge = column == columns[2];

      return DataColumn(
        label: Container(width: 50, child: Expanded(child: Text(column))),
        //label: Text(column),
        numeric: isAge,
      );
    }).toList();
  }

  List<DataRow> getRows(List<WelcomePage> users) =>
      users.map((WelcomePage page) {
        Icon deleteIcon = Icon(Icons.delete);
        int length = 20;
        final cells = [page.id, page.slogan, page.welcomePageImage, deleteIcon];
        return DataRow(
          //Container(width: 100, child: Expanded(child: Text('$cell'))),
          cells: Utils.modelBuilder(cells, (index, cell) {
            final showEditIcon = index == 1 || index == 3;
            if (cell.runtimeType == Icon) {
              return DataCell(Icon(Icons.delete), onTap: () {
                deletePage(page);
              });
            } else {
              return DataCell(
                Text('$cell'),
                showEditIcon: showEditIcon,
                onTap: () {
                  switch (index) {
                    case 3:
                      editLastName(page);
                      break;
                    case 1:
                      editFirstName(page);
                      break;
                  }
                },
              );
            }
          }),
        );
      }).toList();

  Future editFirstName(WelcomePage page) async {
    final firstName = await showTextDialog(
      context,
      slogan: 'Change Id',
      slogan_value: page.id.toString(),
    );
  }

  Future editLastName(WelcomePage selectedPage) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(
              selectedScreen: WelcomeScreen(
                selectedPage: selectedPage,
              ),
            )));
    // Navigator.of(context).pushNamed(WelcomeScreen.id);
    //Navigator.push(context, );
  }

  Future<List<WelcomePage>> fetchPages() async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
    };
    try {
      final response = await http.get(
          Uri.parse("https://aifitness-web.herokuapp.com/welcomepage/all"),
          headers: requestHeaders);
      WelcomeScreenOperations.allPages = List<WelcomePage>.from(
          json.decode(response.body).map((data) => WelcomePage.fromJson(data)));
      WelcomeScreenOperations.allPages.forEach((element) {
        //print(element.id);
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    return WelcomeScreenOperations.allPages;
  }

  deletePage(WelcomePage selectedPage) async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
    };
    final http.Response response = await http.post(
      Uri.parse(
          "https://aifitness-web.herokuapp.com/welcomepage/delete?id=${selectedPage.id.toString()}"),
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      //return WelcomePage.fromJson(jsonDecode(response.body));
      //var result = welcomePageFromJson(response.body);
      setState(() {
        fetchPages();
      });
      print("Deleted");
    } else {
      throw Exception('Failed to delete page.');
    }
  }
}
