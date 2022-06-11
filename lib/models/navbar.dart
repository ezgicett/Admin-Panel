// To parse this JSON data, do
//
//     final navbar = navbarFromJson(jsonString);

import 'dart:convert';

Navbar navbarFromJson(String str) => Navbar.fromJson(json.decode(str));

String navbarToJson(Navbar data) => json.encode(data.toJson());

class Navbar {
  Navbar({
    this.navbarContentId,
    this.menuId,
    this.id,
  });

  int? navbarContentId;
  int? menuId;
  int? id;

  factory Navbar.fromJson(Map<String, dynamic> json) => Navbar(
        navbarContentId: json["navbarContentId"],
        menuId: json["menuId"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "navbarContentId": navbarContentId,
        "menuId": menuId,
      };
}
