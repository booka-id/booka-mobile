import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'book.dart';

class UserProvider extends ChangeNotifier {
  String? _username ="" ;
  int? _id = 0;
  bool? _is_superuser = false;
  String? _profile_picture="" ;
  String? _email="";
  List<Fields> _favorite_book = [];
  List<Fields> _wishlist = [];
  List<Fields> _temp_books = [];


  String get username => _username!;
  String get profile_picture => _profile_picture!;
  String get email => _email!;
  int get id => _id!;
  bool get is_superuser => _is_superuser!;
  List<Fields> get favorite_book => _favorite_book;
  List<Fields> get wishlist => _wishlist;
  List<Fields> get temp_books => _temp_books;

  Future<List<Fields>> fetchBook(String type) async {
    Uri url;
    var book;
    if (type == 'favorit') {
      url = Uri.parse(
          'https://deploytest-production-cf18.up.railway.app/profile/get_favorite_book/$_email/');
    } else {
      url = Uri.parse(
          'https://deploytest-production-cf18.up.railway.app/profile/get_wishlist/$_email/');
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

  Future<bool> saveProfilePic(String imageUrl) async {
    Uri url = Uri.parse(
      'https://deploytest-production-cf18.up.railway.app/profile/change_profile_pic/',);
    var response = await http.post(
      url,
      body: {
        'email': _email,
        'profile_picture': imageUrl,
      },
    );
    String message = jsonDecode(response.body)['message'];
    if (message == 'success') {
      return true;
    } else {
      return false;
    }
  }

  Future<String> saveBook(List<Fields> books, String type) async {
    Uri url;
    if (type == 'favorit') {
      url = Uri.parse(
          'https://deploytest-production-cf18.up.railway.app/profile/add_favorite_book/',
      );
    } else {
      url = Uri.parse(
          'https://deploytest-production-cf18.up.railway.app/profile/add_wishlist/',
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

  Future<void> setUser(String username, String profilePicture, String email, int id, bool is_superuser) async {
    _username = username;
    _id = id;
    _is_superuser = is_superuser;
    _profile_picture = profilePicture;
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

  void changeProfilePic(String imageUrl){
    saveProfilePic(imageUrl);
    _profile_picture = imageUrl;
    notifyListeners();
  }
}


