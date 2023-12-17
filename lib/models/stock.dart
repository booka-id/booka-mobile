// To parse this JSON data, do
//
//     final stock = stockFromJson(jsonString);

import 'dart:convert';

List<Stock> stockFromJson(String str) => List<Stock>.from(json.decode(str).map((x) => Stock.fromJson(x)));

String stockToJson(List<Stock> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Stock {
    Model model;
    int pk;
    Fields fields;

    Stock({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int book;
    int quantity;
    int price;

    Fields({
        required this.book,
        required this.quantity,
        required this.price,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        book: json["book"],
        quantity: json["quantity"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "book": book,
        "quantity": quantity,
        "price": price,
    };
}

enum Model {
    CATALOGUE_BOOKSTOCK
}

final modelValues = EnumValues({
    "catalogue.bookstock": Model.CATALOGUE_BOOKSTOCK
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
