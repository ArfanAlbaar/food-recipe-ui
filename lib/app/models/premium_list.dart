// To parse this JSON data, do
//
//     final premium = premiumFromJson(jsonString);

import 'dart:convert';

PremiumList premiumFromJson(String str) =>
    PremiumList.fromJson(json.decode(str));

String premiumToJson(PremiumList data) => json.encode(data.toJson());

class PremiumList {
  int id;
  String premiumName;

  PremiumList({
    required this.id,
    required this.premiumName,
  });

  factory PremiumList.fromJson(Map<String, dynamic> json) => PremiumList(
        id: json["id"],
        premiumName: json["premiumName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "premiumName": premiumName,
      };
}
