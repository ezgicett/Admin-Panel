import 'dart:convert';
import 'dart:io';

import 'package:bitirme_admin_panel/models/developer.dart';
import 'package:bitirme_admin_panel/widgets/customized_widgets/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:http/http.dart' as http;

class DeveloperScreen extends StatefulWidget {
  static const String id = 'developer-screen';

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  File? image;
  bool flag = false;
  String url = "sdad.png";

  TextEditingController nameController = TextEditingController();
  TextEditingController specializedFieldController = TextEditingController();
  TextEditingController gmailController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController tweeterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Name and Surname",
                          hintText: "Name and Surname",
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
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: specializedFieldController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Specialized Field",
                          hintText: "Specialized Field",
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
            ),
            const SizedBox(
              height: 50,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Add Developer Image",
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            PickImage(flag: flag),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: gmailController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Add Gmail",
                          hintText: "Add Gmail",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue))),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: linkedinController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Add Linkedin",
                          hintText: "Add Linkedin",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue))),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: tweeterController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Add Twitter",
                          hintText: "Add Twitter",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue))),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await createDeveloper();
                },
                child: const Text("Create")),
          ],
        ),
      ),
    );
  }

  createDeveloper() async {
    List<CreateSocialMediaRequest> listOfSocialMediaAccounts = [
      CreateSocialMediaRequest(
        link: linkedinController.text.toString(),
        developerId: 17,
        socialMedia: "LINKEDIN",
      ),
      CreateSocialMediaRequest(
        link: gmailController.text.toString(),
        developerId: 17,
        socialMedia: "GMAIL",
      ),
      CreateSocialMediaRequest(
        link: tweeterController.text.toString(),
        developerId: 17,
        socialMedia: "TWEETER",
      ),
    ];
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };
    print(PickImage(flag: true).getBase64.length);
    Developer developer = Developer(
        developerName: nameController.text.toString(),
        developerImage: PickImage(flag: true).getBase64,
        developerSpecializedField: specializedFieldController.text.toString(),
        createSocialMediaRequests: listOfSocialMediaAccounts); // [
    //   CreateSocialMediaRequest(
    //     link: "",
    //     developerId: 17,
    //     socialMedia: "LINKEDIN",
    //   )
    // ]);

    var response = await http.post(
        Uri.parse("https://aifitness-web.herokuapp.com/developer/addDeveloper"),
        headers: requestHeaders,
        body: jsonEncode(developer.toJson()));

    debugPrint(response.statusCode.toString());
    //var result = developerFromJson(response.body);
    //Developer developer = result;
    //debugPrint(result.developerSpecializedField);

    // Map<String, dynamic> jsonReuests = {
    //   'link': "https://www.linkedin.com/in/ezgicetinkayaa/",
    //   'developerId': 0,
    //   'socialMedia': "LINKEDIN",
    // };
  }
}
