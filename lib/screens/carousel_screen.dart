import 'dart:convert';
import 'dart:io';

import 'package:bitirme_admin_panel/models/carousel.dart';
import 'package:bitirme_admin_panel/widgets/customized_widgets/pick_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;

class CarouselScreen extends StatefulWidget {
  static const String id = 'carousel-screen';

  Carousel? selectedCarousel;
  CarouselScreen({Key? key, this.selectedCarousel}) : super(key: key);
  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  XFile? _image;
  String? imageUrl;
  bool flag = false;
  int? selectedIndex;
  bool isUpdate = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.selectedCarousel == null) {
      titleController.text = "";
      textController.text = "";
    } else {
      titleController.text = widget.selectedCarousel!.rightSideTitle.toString();
      textController.text = widget.selectedCarousel!.rightSideText.toString();
      selectedIndex = widget.selectedCarousel!.carouselIndex;
      isUpdate = true;
    }
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
                "Choose Carousel Page Index",
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: DropdownButton<int>(
                  hint: const Text("Pick"),
                  value: selectedIndex,
                  items:
                      <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
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
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Right Side Title",
                        hintText: "Right Side Title",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                    ),
                    iconSize: 25,
                    color: Colors.green,
                    splashColor: Colors.purple,
                    onPressed: () {},
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
                    controller: textController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Right Side Text",
                        hintText: "Right Side Text",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                    ),
                    iconSize: 25,
                    color: Colors.green,
                    splashColor: Colors.purple,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            PickImage(flag: flag),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  await createPage();
                },
                child: const Text("Create")),
          ],
        ),
      ),
    );
  }

  createPage() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };

    Carousel page = Carousel(
      carouselIndex: selectedIndex,
      leftSideImage: "aa", //PickImage(flag: true).getBase64,
      rightSideTitle: titleController.text.toString(),
      rightSideText: textController.text.toString(),
    );

    var response = await http.post(
        Uri.parse("https://aifitness-web.herokuapp.com/carousel/create"),
        headers: requestHeaders,
        body: jsonEncode(page.toJson()));

    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
  }
}
