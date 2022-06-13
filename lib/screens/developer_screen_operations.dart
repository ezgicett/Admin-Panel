import 'dart:convert';
import 'package:bitirme_admin_panel/models/developer.dart';
import 'package:bitirme_admin_panel/screens/home_screen.dart';
import 'package:bitirme_admin_panel/screens/utils.dart';
import 'package:bitirme_admin_panel/screens/welcome_screen.dart';
import 'package:bitirme_admin_panel/widgets/scrollable_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDevelopers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Developer>>(
        future: fetchDevelopers(),
        builder: (contex, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: <Widget>[
                        ScrollableWidget(child: buildDataTable(snapshot.data!)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          //print("Data buluanmadı ${snapshot.error.toString()}");
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget buildDataTable(List<Developer> listDeveloper) {
    final columns = [
      'Id',
      'Name',
      'Specialized Field',
      //'Image',
      'Gmail',
      'Linkedin',
      'Tweeter',
      '-'
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: getColumns(columns),
        rows: getRows(listDeveloper),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      final isAge = column == columns[2];

      return DataColumn(
        label: Container(
            width: 100,
            child: Column(
              children: [
                Expanded(child: Text(column)),
              ],
            )),
        numeric: isAge,
      );
    }).toList();
  }

  List<DataRow> getRows(List<Developer> developers) =>
      developers.map((Developer developer) {
        //print(page.createSocialMediaRequests![0].link);
        int listLength = (developer.createSocialMediaRequests?.length ?? 0);
        Icon deleteIcon = Icon(Icons.delete);
        final cells = [
          developer.id,
          developer.developerName,
          developer.developerSpecializedField,
          //developer.developerImage,
          listLength > 0
              ? (developer.createSocialMediaRequests?[0].link ?? "")
              : "",
          listLength > 1
              ? (developer.createSocialMediaRequests?[1].link ?? "")
              : "",
          listLength > 2
              ? (developer.createSocialMediaRequests?[2].link ?? "")
              : "",
          deleteIcon
        ];

        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            final showEditIcon = index == 1 ||
                index == 2 ||
                index == 3 ||
                index == 4 ||
                index == 5;
            if (cell.runtimeType == Icon) {
              return DataCell(Icon(Icons.delete), onTap: () {
                deleteDeveloper(developer);
              });
            } else {
              return DataCell(
                Container(
                    width: 100,
                    child: Column(
                      children: [
                        Expanded(child: Text('$cell')),
                      ],
                    )),
                showEditIcon: showEditIcon,
                onTap: () {
                  switch (index) {
                    case 1:
                      editName(developer);
                      break;
                    case 2:
                      editField(developer);
                      break;
                    case 3:
                      editGmail(developer);
                      break;
                    case 4:
                      editLastName(developer);
                      break;
                    case 5:
                      editLastName(developer);
                      break;
                  }
                },
              );
            }
          }),
        );
      }).toList();

  Future editName(Developer developer) async {
    final name = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Name"),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'Enter name'),
        ),
        actions: [
          TextButton(
              onPressed: () {
                updateName(developer, nameController.text);
              },
              child: const Text('SUBMIT')),
        ],
      ),
    );
  }

  Future editField(Developer developer) async {
    final name = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update Field"),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'Enter field'),
        ),
        actions: [
          TextButton(
              onPressed: () {
                updateSpecializedField(developer, nameController.text);
              },
              child: Text('SUBMIT')),
        ],
      ),
    );
  }

  Future editGmail(Developer developer) async {
    final name = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Social Media"),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'Enter link'),
        ),
        actions: [
          TextButton(
              onPressed: () {
                updateGmail(developer, nameController.text);
              },
              child: const Text('SUBMIT')),
        ],
      ),
    );
  }

  Future editLastName(Developer selectedPage) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(
              selectedScreen: WelcomeScreen(),
            )));
  }

  updateName(Developer developer, String name) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };
    Developer dev = Developer(
        developerName: name,
        developerImage: developer.developerImage,
        developerSpecializedField: developer.developerSpecializedField,
        createSocialMediaRequests: developer.createSocialMediaRequests);
    var response = await http.post(
      Uri.parse(
          "https://aifitness-web.herokuapp.com/developer/updateDeveloperName?developerId=${developer.id.toString()}"),
      headers: requestHeaders,
      body: json.encode(dev),
    );
    if (response.statusCode == 200) {
      print("Updated Successfully");
      nameController.clear();
      setState(() {
        fetchDevelopers();
      });
      Navigator.of(context).pop();
    }
  }

  updateGmail(Developer developer, String name) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };
    final index = developer.createSocialMediaRequests!
        .indexWhere((element) => element.socialMedia == "LINKEDIN");

    var response = await http.post(
      Uri.parse(
          "https://aifitness-web.herokuapp.com/developer/updateSocialMedia"),
      headers: requestHeaders,
      body: json.encode({
        "id": developer.createSocialMediaRequests![index].developerId,
        "link": name,
      }),
    );
    if (response.statusCode == 200) {
      print("Updated Successfully");
      nameController.clear();
      Navigator.of(context).pop();
    }
  }

  updateSpecializedField(Developer developer, String field) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };
    Developer dev = Developer(
        developerName: developer.developerName,
        developerImage: developer.developerImage,
        developerSpecializedField: field,
        createSocialMediaRequests: developer.createSocialMediaRequests);
    var response = await http.post(
      Uri.parse(
          "https://aifitness-web.herokuapp.com/developer/updateDeveloperSpecializedField?developerId=${developer.id.toString()}"),
      headers: requestHeaders,
      body: json.encode(dev),
    );
    if (response.statusCode == 200) {
      print("Updated Successfully");
      nameController.clear();
      setState(() {
        fetchDevelopers();
      });
      Navigator.of(context).pop();
    }
  }

  Future<List<Developer>> fetchDevelopers() async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
    };
    List<Developer> _listDeveloper = [];
    final response = await http.get(
        Uri.parse("https://aifitness-web.herokuapp.com/developer/getall"),
        headers: requestHeaders);

    _listDeveloper = List<Developer>.from(
        json.decode(response.body).map((data) => Developer.fromJson(data)));

    return _listDeveloper;
  }

  deleteDeveloper(Developer developer) async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
    };
    final http.Response response = await http.post(
      Uri.parse(
          "https://aifitness-web.herokuapp.com/developer/deleteDeveloper?developerId=${developer.id.toString()}"),
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      print("Deleted");
      setState(() {
        fetchDevelopers();
      });
    } else {
      throw Exception('Failed to delete page.');
    }
  }
}
