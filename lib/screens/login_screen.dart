import 'dart:convert';
import 'package:bitirme_admin_panel/models/login.dart';
import 'package:bitirme_admin_panel/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "Password should be atleast 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            child: Form(
              autovalidateMode:
                  AutovalidateMode.always, //check for validation while typing
              key: formkey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                        controller: username,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            hintText: 'Enter valid username'),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          //EmailValidator(errorText: "Enter valid email id"),
                        ])),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Enter secure password'),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          MinLengthValidator(6,
                              errorText:
                                  "Password should be atleast 6 characters"),
                          MaxLengthValidator(15,
                              errorText:
                                  "Password should not be greater than 15 characters")
                        ])),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 30,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      onPressed: () async {
                        //login();
                        bool value = await login();
                        print(value);
                        if (value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => HomeScreen()));
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Login Failed'),
                              content:
                                  const Text('Username or Password s Wrong!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Okey'),
                                  child: const Text('Okey'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> login() async {
    Login login = Login(
        username: username.text.toString(), password: password.text.toString());
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };

    var response = await http.post(
        Uri.parse("https://aifitness-api.herokuapp.com/auth/login"),
        headers: requestHeaders,
        body: jsonEncode(login));
    if (response.statusCode == 200) {
      var result = loginFromJson(response.body);

      if (result.data!.token.toString().length >= 20 &&
          result.data!.userType == "admin") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
