// To parse this JSON data, do
//
//     final developer = developerFromJson(jsonString);

import 'dart:convert';

Developer developerFromJson(String str) => Developer.fromJson(json.decode(str));

String developerToJson(Developer data) => json.encode(data.toJson());

class Developer {
  Developer({
    this.developerName,
    this.developerImage,
    this.developerSpecializedField,
    this.createSocialMediaRequests,
    this.id,
  });

  String? developerName;
  String? developerImage;
  String? developerSpecializedField;
  List<CreateSocialMediaRequest>? createSocialMediaRequests;
  int? id;

  factory Developer.fromJson(Map<String, dynamic> json) => Developer(
        developerName: json["developerName"],
        developerImage: json["developerImage"],
        developerSpecializedField: json["developerSpecializedField"],
        id: json["id"],
        createSocialMediaRequests: List<CreateSocialMediaRequest>.from(
            json["createSocialMediaRequests"]
                .map((x) => CreateSocialMediaRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "developerName": developerName,
        "developerImage": developerImage,
        "developerSpecializedField": developerSpecializedField,
        "createSocialMediaRequests": List<dynamic>.from(
            createSocialMediaRequests!.map((x) => x.toJson())),
      };
}

class CreateSocialMediaRequest {
  CreateSocialMediaRequest({
    this.link,
    this.developerId,
    this.socialMedia,
  });

  String? link;
  int? developerId;
  String? socialMedia;

  factory CreateSocialMediaRequest.fromJson(Map<String, dynamic> json) =>
      CreateSocialMediaRequest(
        link: json["link"],
        developerId: json["developerId"],
        socialMedia: json["socialMedia"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "developerId": developerId,
        "socialMedia": socialMedia,
      };
}
