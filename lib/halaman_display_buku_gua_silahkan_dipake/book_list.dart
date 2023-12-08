import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booka_mobile/models/product.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  bool _userBook = false;

  Future<List<Book>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final userProvider = context.read<UserProvider>();
    final username = userProvider.username;
    var url = Uri.parse('//127.0.0.1:8000/json/');
    if (_userBook) {
      url = Uri.parse('//127.0.0.1:8000/get-product/');
    }
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username}),
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Book> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Book.fromJson(d));
      }
    }
    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('List Buku'),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            actions: [
              SwitchBook(
                initialValue: _userBook,
                onValueChanged: (value) {
                  setState(() {
                    _userBook = value;
                  });
                },
              ),
            ]),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: fetchProduct(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak ada data produk.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Detail Produk"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Judul Buku: ${snapshot.data![index].fields.name}'),
                                        Text(
                                            'Penulis Buku: ${snapshot.data![index].fields.author}'),
                                        Text(
                                            'Status Buku: ${snapshot.data![index].fields.status}'),
                                        Text(
                                            'Jumlah Buku: ${snapshot.data![index].fields.amount}'),
                                        Text(
                                            'Deskripsi Buku: ${snapshot.data![index].fields.description}'),
                                        Text(
                                            'Kontributor Buku: ${snapshot.data![index].fields.user}'),
                                        Text(
                                            'Waktu Ditambahkan: ${snapshot.data![index].fields.dateAdded}'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.indigo),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data![index].fields.name}",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text("${snapshot.data![index].fields.amount}"),
                                const SizedBox(height: 10),
                                Text(
                                    "${snapshot.data![index].fields.description}")
                              ],
                            ),
                          )));
                }
              }
            }));
  }
}

class SwitchBook extends StatelessWidget {
  final bool initialValue;
  final ValueChanged<bool> onValueChanged;

  const SwitchBook({super.key, required this.initialValue, required this.onValueChanged});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final username = userProvider.username;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Buku $username',
          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(width: 8.0), // Adjust spacing as needed
        Switch(
          value: initialValue,
          onChanged: onValueChanged,
          activeTrackColor: Colors.lightGreenAccent,
          inactiveTrackColor: Colors.grey,
          activeColor: Colors.green,
          inactiveThumbColor: Colors.grey,
        ),
      ],
    );
  }
}
