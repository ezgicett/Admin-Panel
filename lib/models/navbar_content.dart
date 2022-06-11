// To parse this JSON data, do
//
//     final navbarContent = navbarContentFromJson(jsonString);

import 'dart:convert';

NavbarContent navbarContentFromJson(String str) => NavbarContent.fromJson(json.decode(str));

String navbarContentToJson(NavbarContent data) => json.encode(data.toJson());

class NavbarContent {
    NavbarContent({
        this.menuVersion,
        this.logo,
        this.title,
    });

    int? menuVersion;
    String? logo;
    String? title;

    factory NavbarContent.fromJson(Map<String, dynamic> json) => NavbarContent(
        menuVersion: json["menuVersion"],
        logo: json["logo"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "menuVersion": menuVersion,
        "logo": logo,
        "title": title,
    };
}
