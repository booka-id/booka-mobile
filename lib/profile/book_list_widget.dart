import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../landing_page/login.dart';
import '../models/user.dart';

class BookListWidget extends StatefulWidget {
  final String type;
  const BookListWidget(String this.type, {Key? key}) : super(key: key);

  @override
  _BookListWidgetState createState() => _BookListWidgetState(type);
}

class _BookListWidgetState extends State<BookListWidget> {
  String type;
  _BookListWidgetState(this.type);

  String changeUrl(String url) {
    String newUrl = url.replaceAll('http://images.amazon.com' , 'https://m.media-amazon.com');
    return newUrl;

  }

  Future<List<Container>> fetchBook(String type) async {
    final userProvider = context.read<UserProvider>();
    var url;
    if (type == 'Favorit') {
      url = Uri.parse(
          'http://10.0.2.2:8000/profile/get_favorite_book/${userProvider.email}/');
    } else {
      url = Uri.parse(
          'http://10.0.2.2:8000/profile/get_wishlist/${userProvider.email}/');
    }
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    var favoriteBook = jsonDecode(data['book']);
    //loop untuk membuat container di dalam list

    List<Container> listBuku = [];

    for (var d in favoriteBook) {
      if (d != null) {
        listBuku.add(
          Container(
            width: 150,
            height: 300,
            child: Card(
                child: Column(
              children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: Image.network(
                        changeUrl(d['image_url_medium'],
                    ),
                      fit: BoxFit.fill,
                    )
                  ),

                  SizedBox(
                    height: 75,
                    child: Text(
                        d['title'],
                        overflow: TextOverflow.clip,
                      ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Text(
                      'By: ${d['author']}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            )),
          ),
        );
      }
    }
    return listBuku;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: fetchBook(type),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData || snapshot.data == null){
          return Container(
              child: const Center(
                child: Text("Belum ada buku"),
              ),
            );
        } else {
          return Container(
            height: 350,
            child: Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data,
              ),
            )
          );
        }
      },
    ));
  }
}
