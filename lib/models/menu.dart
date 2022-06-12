// To parse this JSON data, do
//
//     final menu = menuFromJson(jsonString);

import 'dart:convert';

Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

String menuToJson(Menu data) => json.encode(data.toJson());

class Menu {
    Menu({
        this.id,
        this.version,
        this.menuItems,
    });

    int? id;
    int? version;
    List<MenuuItem>? menuItems;

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        version: json["version"],
        menuItems: List<MenuuItem>.from(json["menuItems"].map((x) => MenuuItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "menuItems": List<dynamic>.from(menuItems!.map((x) => x.toJson())),
    };
}

class MenuuItem {
    MenuuItem({
        this.id,
        this.menuName,
    });

    int? id;
    String? menuName;

    factory MenuuItem.fromJson(Map<String, dynamic> json) => MenuuItem(
        id: json["id"],
        menuName: json["menuName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "menuName": menuName,
    };
}
