import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/review/book_detail.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BookSearchPage extends StatefulWidget {
  BookSearchPage({Key? key}) : super(key: key);

  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  int _selectedIndex = 0;
  // late TextEditingController _searchController;

  // @override
  // void initState() {
  //   super.initState();
  //   _searchController = TextEditingController();
  // }

  Future<List<Book>> fetchProduct() async {
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
    List<Book> all_review = [];
    for (var d in data) {
        if (d != null) {
            all_review.add(Book.fromJson(d));
        }
    }
    return all_review;
}


  @override
  Widget build(BuildContext context) {
    var _searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booka',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Which book do you want to review?',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(width: 2.0, color: Colors.grey),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(width: 2.0, color: Colors.indigo),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Implement search functionality here
                    // You can access the search query using _searchController.text
                  },
                ),
              ),
              onChanged: (value) {
                // Implement search logic based on value changes
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
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
                            onTap: () async {
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailPage(bookID: snapshot.data![index].pk),
                              ));
                            },
                            child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20.0), // Set the border radius here
                                  ),
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                      Text(
                                      "${snapshot.data![index].fields.title}",
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                      ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text("${snapshot.data![index].fields.author}"),
                                      const SizedBox(height: 10),
                                      Text(
                                          "${snapshot.data![index].fields.year}")
                                  ],
                                  ),
                              ),
                          )
                          );
                      }
                  }
              },
            ),
          ),
        ],
      ),
    );
  }
}
