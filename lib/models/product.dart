// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Book> welcomeFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String welcomeToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  String model;
  int pk;
  Fields fields;

  Book({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  DateTime dateAdded;
  String name;
  String author;
  String description;
  String status;
  int amount;

  Fields({
    required this.user,
    required this.dateAdded,
    required this.name,
    required this.author,
    required this.description,
    required this.status,
    required this.amount,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        dateAdded: DateTime.parse(json["date_added"]),
        name: json["name"],
        author: json["author"],
        description: json["description"],
        status: json["status"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "name": name,
        "author": author,
        "description": description,
        "status": status,
        "amount": amount,
      };
}
