// To parse this JSON data, do
//
//     final listMember = listMemberFromJson(jsonString);

import 'dart:convert';

ListMember listMemberFromJson(String str) =>
    ListMember.fromJson(json.decode(str));

String listMemberToJson(ListMember data) => json.encode(data.toJson());

class ListMember {
  String username;
  String name;
  String phoneNumber;
  String? lastLogin;
  bool? premium;

  ListMember({
    required this.username,
    required this.name,
    required this.phoneNumber,
    this.lastLogin,
    this.premium,
  });

  factory ListMember.fromJson(Map<String, dynamic> json) => ListMember(
        username: json["username"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        lastLogin: json["lastLogin"],
        premium: json["premium"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "phoneNumber": phoneNumber,
        "lastLogin": lastLogin,
        "premium": premium,
      };
}
