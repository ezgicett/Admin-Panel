import 'dart:convert';
import 'package:bitirme_admin_panel/models/developer.dart';
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
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode:
              AutovalidateMode.always, //check for validation while typing
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    controller: username,
                    decoration: InputDecoration(
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
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter secure password'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      MinLengthValidator(6,
                          errorText: "Password should be atleast 6 characters"),
                      MaxLengthValidator(15,
                          errorText:
                              "Password should not be greater than 15 characters")
                    ])
                    //validatePassword,        //Function to check validation
                    ),
              ),
              ElevatedButton(
                onPressed: () {
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () {
                    login();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (_) => HomeScreen()));

                    // if (formkey.currentState!.validate()) {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (_) => HomeScreen()));
                    //   print("Validated");
                    // } else {
                    //   print("Not Validated");
                    // }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Text('New User? Create Account')
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    Login login = Login(
        username: username.text.toString(), password: password.text.toString());
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'accept': '*/*',
    };
    print(username.text.toString());
    print(password.text.toString());
    var response = await http.post(
        Uri.parse("https://aifitness-api.herokuapp.com/auth/login"),
        headers: requestHeaders,
        body: jsonEncode(login.toJson()));

    var result = loginFromJson(response.body);
    validate(result.data);
    print(result.data!.token.toString());
    print(response.statusCode.toString());
  }

  validate(data) {
    if (data.token.toString().length >= 20 && data.userType == "admin") {
      print("User login succesfull");
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }
}
