// To parse this JSON data, do
//
//     final welcomePage = welcomePageFromJson(jsonString);

import 'dart:convert';

WelcomePage welcomePageFromJson(String str) =>
    WelcomePage.fromJson(json.decode(str));

String welcomePageToJson(WelcomePage data) => json.encode(data.toJson());

class WelcomePage {
  WelcomePage({
    this.welcomePageImage,
    this.slogan,
    this.id,
  });

  String? welcomePageImage;
  String? slogan;
  int? id;

  factory WelcomePage.fromJson(Map<String, dynamic> json) => WelcomePage(
        welcomePageImage: json["welcomePageImage"],
        slogan: json["slogan"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "welcomePageImage": welcomePageImage,
        "slogan": slogan,
      };
}
