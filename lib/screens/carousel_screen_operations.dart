import 'dart:convert';

import 'package:bitirme_admin_panel/models/carousel.dart';
import 'package:bitirme_admin_panel/screens/carousel_screen.dart';
import 'package:bitirme_admin_panel/screens/home_screen.dart';
import 'package:bitirme_admin_panel/screens/utils.dart';
import 'package:bitirme_admin_panel/widgets/scrollable_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarouselScreenOperations extends StatefulWidget {
  static const String id = 'carousel-screen-operations';

  @override
  State<CarouselScreenOperations> createState() =>
      _CarouselScreenOperationsState();
}

class _CarouselScreenOperationsState extends State<CarouselScreenOperations> {
  late List<Carousel> screen;

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
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget buildDataTable() {
    final columns = ['Id', 'Index', 'Image', 'Title', 'Text', '-', ' '];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(screen),
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

  List<DataRow> getRows(List<Carousel> listOfScreens) =>
      listOfScreens.map((Carousel screen) {
        Icon deleteIcon = Icon(Icons.delete);

        final cells = [
          screen.id,
          screen.carouselIndex,
          screen.leftSideImage,
          screen.rightSideTitle,
          screen.rightSideText,
          "",
          deleteIcon
        ];
        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            final showEditIcon = index == 5;
            if (cell.runtimeType == Icon) {
              return DataCell(Icon(Icons.delete), onTap: () {
                deletePage(screen);
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
                //Text('$cell'),
                showEditIcon: showEditIcon,
                onTap: () {
                  switch (index) {
                    case 5:
                      editCarousel(screen);
                      break;
                  }
                },
              );
            }
          }),
        );
      }).toList();

  Future editCarousel(Carousel selectedPage) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(
              selectedScreen: CarouselScreen(
                selectedCarousel: selectedPage,
              ),
            )));
  }

  Future<List<Carousel>> fetchPages() async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
    };
    try {
      final response = await http.get(
          Uri.parse(
              "https://aifitness-web.herokuapp.com/carousel/allcarousels"),
          headers: requestHeaders);
      screen = List<Carousel>.from(
          json.decode(response.body).map((data) => Carousel.fromJson(data)));
    } catch (e) {
      debugPrint(e.toString());
    }

    return screen;
  }

  deletePage(Carousel selectedPage) async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
    };
    final http.Response response = await http.post(
      Uri.parse(
          "https://aifitness-web.herokuapp.com/carousel/delete?id=${selectedPage.id.toString()}"),
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      setState(() {
        fetchPages();
      });
      print("Deleted");
    } else {
      throw Exception('Failed to delete page.');
    }
  }
}
