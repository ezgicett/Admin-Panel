// To parse this JSON data, do
//
//     final navbarContent = navbarContentFromJson(jsonString);

import 'dart:convert';

NavbarContent navbarContentFromJson(String str) =>
    NavbarContent.fromJson(json.decode(str));

String navbarContentToJson(NavbarContent data) => json.encode(data.toJson());

class NavbarContent {
  NavbarContent({
    this.menuVersion,
    this.logo,
    this.title,
    this.id,
  });

  int? menuVersion;
  String? logo;
  String? title;
  int? id;

  factory NavbarContent.fromJson(Map<String, dynamic> json) => NavbarContent(
        menuVersion: json["menuVersion"],
        logo: json["logo"],
        title: json["title"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "menuVersion": menuVersion,
        "logo": logo,
        "title": title,
      };
}
