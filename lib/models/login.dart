// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    this.data,
    this.responseDate,
    this.messages,
    this.success,
    this.username,
    this.password,
  });

  Data? data;
  DateTime? responseDate;
  dynamic? messages;
  bool? success;
  String? password;
  String? username;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
      data: Data.fromJson(json["data"]),
      responseDate: DateTime.parse(json["responseDate"]),
      messages: json["messages"],
      success: json["success"],
      username: json["username"],
      password: json["password"]);

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}

class Data {
  Data({
    this.token,
    this.username,
    this.userType,
  });

  String? token;
  String? username;
  String? userType;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        username: json["username"],
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "username": username,
        "userType": userType,
      };
}
