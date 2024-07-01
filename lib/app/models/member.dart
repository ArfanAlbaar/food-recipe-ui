// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';

Member memberFromJson(String str) => Member.fromJson(json.decode(str));

String memberToJson(Member data) => json.encode(data.toJson());

class Member {
  String username;
  String name;
  String phoneNumber;
  dynamic premium;

  Member({
    required this.username,
    required this.name,
    required this.phoneNumber,
    required this.premium,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        username: json["username"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        premium: json["premium"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "phoneNumber": phoneNumber,
        "premium": premium,
      };
}
