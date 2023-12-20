import 'dart:convert';
import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/models/stock.dart';
import 'package:http/http.dart' as http;


class ApiService {
  final String baseUrl = 'https://deploytest-production-cf18.up.railway.app';

  Future<List<Book>> fetchBooks() async {
    var url = Uri.parse('$baseUrl/api/books/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});
    List data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((book) => Book.fromJson(book)).toList();
  }

  Future<List<Stock>> fetchStocks() async {
    var url = Uri.parse('$baseUrl/catalogue/json/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});
    List data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((stock) => Stock.fromJson(stock)).toList();
  }

}