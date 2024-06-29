// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

Transaction transactionFromJson(String str) =>
    Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  int id;
  int amount;
  DateTime timestamp;
  Member member;

  Transaction({
    required this.id,
    required this.amount,
    required this.timestamp,
    required this.member,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        amount: json["amount"],
        timestamp: DateTime.parse(json["timestamp"]),
        member: Member.fromJson(json["member"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "timestamp": timestamp.toIso8601String(),
        "member": member.toJson(),
      };
}

class Member {
  String username;
  String password;
  String name;
  String phoneNumber;
  String? token;
  int? tokenExpiredAt;
  dynamic? lastLogin;
  bool? premium;

  Member({
    required this.username,
    required this.password,
    required this.name,
    required this.phoneNumber,
    this.token,
    this.tokenExpiredAt,
    this.lastLogin,
    this.premium,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        username: json["username"],
        password: json["password"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        token: json["token"],
        tokenExpiredAt: json["tokenExpiredAt"],
        lastLogin: json["lastLogin"],
        premium: json["premium"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "name": name,
        "phoneNumber": phoneNumber,
        "token": token,
        "tokenExpiredAt": tokenExpiredAt,
        "lastLogin": lastLogin,
        "premium": premium,
      };
}
