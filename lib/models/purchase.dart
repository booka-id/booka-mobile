// To parse this JSON data, do
//
//     final purchase = purchaseFromJson(jsonString);

import 'dart:convert';

List<Purchase> purchaseFromJson(String str) => List<Purchase>.from(json.decode(str).map((x) => Purchase.fromJson(x)));

String purchaseToJson(List<Purchase> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Purchase {
    String model;
    int pk;
    Fields fields;

    Purchase({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
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
    int book;
    int user;
    int quantity;
    String paymentMethod;
    DateTime purchaseTime;

    Fields({
        required this.book,
        required this.user,
        required this.quantity,
        required this.paymentMethod,
        required this.purchaseTime,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        book: json["book"],
        user: json["user"],
        quantity: json["quantity"],
        paymentMethod: json["payment_method"],
        purchaseTime: DateTime.parse(json["purchase_time"]),
    );

    Map<String, dynamic> toJson() => {
        "book": book,
        "user": user,
        "quantity": quantity,
        "payment_method": paymentMethod,
        "purchase_time": purchaseTime.toIso8601String(),
    };
}
