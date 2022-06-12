// To parse this JSON data, do
//
//     final developer = developerFromJson(jsonString);

import 'dart:convert';

Developer developerFromJson(String str) => Developer.fromJson(json.decode(str));

String developerToJson(Developer data) => json.encode(data.toJson());

class Developer {
  Developer({
    this.id,
    this.developerName,
    this.developerSpecializedField,
    this.developerImage,
    this.createSocialMediaRequests,
  });

  String? developerName;
  String? developerImage;
  String? developerSpecializedField;
  List<CreateSocialMediaRequest>? createSocialMediaRequests;
  int? id;

  factory Developer.fromJson(Map<String, dynamic> json) {
    print(json["socialMedia"].toString());
    print(json["socialMedia"][0].toString());

    return Developer(
      id: json["id"],
      developerName: json["developerName"],
      developerSpecializedField: json["developerSpecializedField"],
      developerImage: json["developerImage"],
      createSocialMediaRequests: List<CreateSocialMediaRequest>.from(
          json["socialMedia"]
              .map((x) => CreateSocialMediaRequest.fromJson(x))
              .toList()),
    );
  }

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
    this.id,
    this.link,
    this.developerId,
    this.socialMedia,
    this.developerSpecializedField,
    this.socialMediaImageLink,
  });

  int? id;
  String? link;
  int? developerId;
  String? socialMedia;
  int? developerSpecializedField;
  String? socialMediaImageLink;

  factory CreateSocialMediaRequest.fromJson(Map<String, dynamic> json) =>
      CreateSocialMediaRequest(
        id: json["id"],
        link: json["link"],
        developerSpecializedField: json["developerSpecializedField"],
        socialMediaImageLink: json["socialMediaImageLink"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "developerId": developerId,
        "socialMedia": socialMedia,
      };
}
