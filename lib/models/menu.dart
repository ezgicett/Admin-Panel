// To parse this JSON data, do
//
//     final menu = menuFromJson(jsonString);

import 'dart:convert';

Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

String menuToJson(Menu data) => json.encode(data.toJson());

class Menu {
  Menu({this.version, this.id});

  int? version;
  int? id;

  factory Menu.fromJson(Map<String, dynamic> json) =>
      Menu(version: json["version"], id: json["id"]);

  Map<String, dynamic> toJson() => {
        "version": version,
      };
}
