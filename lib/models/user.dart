import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'book.dart';

class UserProvider extends ChangeNotifier {
  String? _username ="" ;
  String? _profile_picture="" ;
  String? _email="";
  List<Fields> _favorite_book = [];
  List<Fields> _wishlist = [];
  List<Fields> _temp_books = [];


  String get username => _username!;
  String get profile_picture => _profile_picture!;
  String get email => _email!;
  List<Fields> get favorite_book => _favorite_book;
  List<Fields> get wishlist => _wishlist;
  List<Fields> get temp_books => _temp_books;

  Future<List<Fields>> fetchBook(String type) async {
    var url;
    var book;
    if (type == 'favorit') {
      url = Uri.parse(
          'http://10.0.2.2:8000/profile/get_favorite_book/${_email}/');
    } else {
      url = Uri.parse(
          'http://10.0.2.2:8000/profile/get_wishlist/${_email}/');
    }
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    if(data['book'] == null){
      book = [];
    }else{
      book = jsonDecode(data['book']);
    }


    List<Fields> fetchedBooks = [];
    for (var d in book) {
      if (d != null) {
        fetchedBooks.add(Fields.fromJson(d));
      }
    }
    return fetchedBooks;

  }

  Future<String> saveBook(List<Fields> books, String type) async {
    var url;
    if (type == 'favorit') {
      url = Uri.parse(
          'http://10.0.2.2:8000/profile/add_favorite_book/',
      );
    } else {
      url = Uri.parse(
          'http://10.0.2.2:8000/profile/add_wishlist/',
      );
    }
    var bookJson = jsonEncode(books);
    var response = await http.post(
      url,
      body:{
        'email': _email,
        'json_data': bookJson,
      },
    );
    return jsonDecode(response.body)['message'];
  }

  Future<void> setUser(String username, String profile_picture, String email) async {
    _username = username;
    _profile_picture = profile_picture;
    _email = email;
    _wishlist = await fetchBook('wishlist');
    _favorite_book = await fetchBook('favorit');
    notifyListeners();
  }

  void wishlistBookChanged() async {
    _wishlist = await fetchBook('wishlist');
    notifyListeners();
  }

  void favoriteBookChanged() async {
    _favorite_book = await fetchBook('favorit');
    notifyListeners();
  }

  Future<String> saveFavoriteBook() async {
    String response = await saveBook(_temp_books, 'favorit');
    if(response == 'success') {
      favoriteBookChanged();
      return 'success';
    }else{
      return 'gagal';
    }
  }

  Future<String> saveWishlist() async {
    String response = await saveBook(_temp_books, 'wishlist');
    if(response == 'success') {
      wishlistBookChanged();
      return 'success';
    }else{
      return 'gagal';
    }

  }

  void addBook(Fields book) {
    _temp_books.add(book);
    notifyListeners();
  }

  void clearBooks() {
    _temp_books = [];
    notifyListeners();
  }



}

