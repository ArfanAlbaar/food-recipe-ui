// To parse this JSON data, do
//
//     final makanan = makananFromJson(jsonString);

import 'dart:convert';

Makanan makananFromJson(String str) => Makanan.fromJson(json.decode(str));

String makananToJson(Makanan data) => json.encode(data.toJson());

class Makanan {
  int? id;
  String recipeName;
  String ingredients;
  String instructions;
  String category;
  bool favorite;
  String imgLink;

  Makanan({
    this.id,
    required this.recipeName,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.favorite,
    required this.imgLink,
  });

  factory Makanan.fromJson(Map<String, dynamic> json) => Makanan(
        id: json["id"],
        recipeName: json["recipeName"],
        ingredients: json["ingredients"],
        instructions: json["instructions"],
        category: json["category"],
        favorite: json["favorite"],
        imgLink: json["imgLink"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "recipeName": recipeName,
        "ingredients": ingredients,
        "instructions": instructions,
        "category": category,
        "favorite": favorite,
        "imgLink": imgLink,
      };
}
