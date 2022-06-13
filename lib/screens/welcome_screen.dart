import 'dart:convert';
import 'package:bitirme_admin_panel/models/welcome_page.dart';
import 'package:bitirme_admin_panel/widgets/customized_widgets/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  static List<WelcomePage> pages = [];
  WelcomePage? selectedPage;
  WelcomeScreen({Key? key, this.selectedPage}) : super(key: key);
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool flag = false;
  int selectedIndex = -1;
  TextEditingController sloganController = TextEditingController();
  bool isUpdate = false;

  @override
  Widget build(BuildContext context) {
    if (widget.selectedPage == null) {
      sloganController.text = "";
    } else {
      sloganController.text = widget.selectedPage!.slogan.toString();
      isUpdate = true;
    }
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
                        labelText: "Slogan",
                        hintText: "Slogan",
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
            const SizedBox(
              height: 50,
            ),
            PickImage(flag: flag),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () async {
                  isUpdate == false
                      ? await createWelcomePage()
                      : await updateWelcomePage();
                },
                child: isUpdate == false
                    ? const Text("Create")
                    : const Text("Update")),
          ],
        ),
      ),
    );
  }

  createWelcomePage() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };

    var response = await http.post(
      Uri.parse("https://aifitness-web.herokuapp.com/welcomepage/create"),
      headers: requestHeaders,
      body: json.encode({
        'slogan': sloganController.text.toString(),
        'welcomePageImage': PickImage(flag: true).getBase64,
      }),
    );
    sloganController.clear();
    var result = welcomePageFromJson(response.body);
    WelcomePage welcomePage = result;
  }

  updateWelcomePage() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
      //'Access-Control-Allow-Origin': "*",
    };

    var response = await http.post(
      Uri.parse(
          "https://aifitness-web.herokuapp.com/welcomepage/update?id=${widget.selectedPage!.id.toString()}"),
      headers: requestHeaders,
      body: json.encode({
        'slogan': sloganController.text.toString(),
        'welcomePageImage': "urll",
      }),
    );
    var result = welcomePageFromJson(response.body);
    WelcomePage welcomePage = result;
    debugPrint(result.id.toString());
  }

  fetchPages() async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
    };
    try {
      final response = await http.get(
          Uri.parse("https://aifitness-web.herokuapp.com/welcomepage/all"),
          headers: requestHeaders);
      WelcomeScreen.pages = new List<WelcomePage>.from(
          json.decode(response.body).map((data) => WelcomePage.fromJson(data)));
      WelcomeScreen.pages.forEach((element) {
        print(element.id);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
