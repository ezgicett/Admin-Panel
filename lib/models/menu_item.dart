// To parse this JSON data, do
//
//     final menuItem = menuItemFromJson(jsonString);

import 'dart:convert';

MenuItem menuItemFromJson(String str) => MenuItem.fromJson(json.decode(str));

String menuItemToJson(MenuItem data) => json.encode(data.toJson());

class MenuItem {
  MenuItem({
    this.menuName,
    this.menuId,
    this.id,
  });

  String? menuName;
  int? menuId;
  int? id;

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        menuName: json["menuName"],
        menuId: json["menuId"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "menuName": menuName,
        "menuId": menuId,
      };
}
