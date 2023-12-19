// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

List<Event> eventFromJson(String str) =>
    List<Event>.from(json.decode(str).map((x) => Event.fromJson(x)));

String eventToJson(List<Event> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Event {
  String model;
  int pk;
  Fields fields;

  Event({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
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
  String name;
  DateTime date;
  String description;
  String photo;
  String featuredBook;

  Fields({
    required this.name,
    required this.date,
    required this.description,
    required this.photo,
    required this.featuredBook,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        date: DateTime.parse(json["date"]),
        description: json["description"],
        photo: json["photo"],
        featuredBook: json["featured_book"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date.toIso8601String(),
        "description": description,
        "photo": photo,
        "featured_book": featuredBook,
      };
}
