import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:booka_mobile/models/book.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:booka_mobile/profile/book_list.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';


class AddBookButton extends StatelessWidget {
  final String type;
  const AddBookButton(this.type, {Key? key}) : super(key: key);

  String changeUrl(String url) {
    String newUrl = url.replaceAll('http://images.amazon.com' , 'https://m.media-amazon.com');
    return newUrl;

  }

  Future<List<Book>> fetchBook() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://deploytest-production-cf18.up.railway.app/api/books/'
      // 'http://127.0.0.1:8000/review/all/'
    );
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Book> fetchedBooks = [];
    for (var d in data) {
      if (d != null) {
        fetchedBooks.add(Book.fromJson(d));
      }
    }
    return fetchedBooks;

  }

  // List<Book> resultSearch(List<>){
  //   return [];
  // }


  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return ElevatedButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: const Text('Tambah Buku'),
                  content: SizedBox(
                    width: 300,
                    height: 300,
                    child: Column(
                      children: [
                        TypeAheadField(
                          textFieldConfiguration: const TextFieldConfiguration(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Cari Buku',
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            return await fetchBook();
                          },
                          itemBuilder: (context, Book suggestion) {
                            return ListTile(
                              leading: Image.network(changeUrl(suggestion.fields.imageUrlMedium)),
                              title: Text(suggestion.fields.title),
                              subtitle: Text(suggestion.fields.author),
                            );
                          },
                          onSuggestionSelected: (Book suggestion) {
                            userProvider.addBook(suggestion.fields);
                          },
                        ),
                        const Expanded(
                            child: BookList('temp'),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                userProvider.clearBooks();
                              },
                              child: const Text('Reset'),
                            ),
                            ElevatedButton(
                                onPressed: (){
                                  if(type == 'favorit'){
                                    userProvider.saveFavoriteBook();
                                  } else {
                                    userProvider.saveWishlist();
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Simpan'),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              }
          );
        }, child: Text('Tambah Buku $type')
    );
  }
}