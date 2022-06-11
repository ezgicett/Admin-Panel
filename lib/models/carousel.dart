// To parse this JSON data, do
//
//     final carousel = carouselFromJson(jsonString);

import 'dart:convert';

Carousel carouselFromJson(String str) => Carousel.fromJson(json.decode(str));

String carouselToJson(Carousel data) => json.encode(data.toJson());

class Carousel {
  Carousel(
      {this.carouselIndex,
      this.leftSideImage,
      this.rightSideTitle,
      this.rightSideText,
      this.id});

  int? carouselIndex;
  String? leftSideImage;
  String? rightSideTitle;
  String? rightSideText;
  int? id;

  factory Carousel.fromJson(Map<String, dynamic> json) => Carousel(
      carouselIndex: json["carouselIndex"],
      leftSideImage: json["leftSideImage"],
      rightSideTitle: json["rightSideTitle"],
      rightSideText: json["rightSideText"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "carouselIndex": carouselIndex,
        "leftSideImage": leftSideImage,
        "rightSideTitle": rightSideTitle,
        "rightSideText": rightSideText,
      };
}
