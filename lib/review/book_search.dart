import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/review/book_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BookSearchPage extends StatefulWidget {
  const BookSearchPage({Key? key}) : super(key: key);

  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  late TextEditingController _searchController;
  List<Book> all_books = [];
  List<Book> book_displayed = [];
  
  // late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchProduct();
  }

  void updateList(String value){
    setState(() {
      book_displayed = all_books
        .where((element) => 
          element.fields.title.toLowerCase().contains(value.toLowerCase()) ||
          element.fields.author.toLowerCase().contains(value.toLowerCase())).toList();
    }); 
  }

  Future<void> fetchProduct() async {
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
    setState(() {
      all_books = fetchedBooks;
      book_displayed = List.from(all_books);
    });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booka',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  borderSide: const BorderSide(width: 2.0, color: Colors.grey),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(width: 2.0, color: Colors.indigo),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                suffixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement search logic based on value changes
                updateList(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
            itemCount: book_displayed.length,
            itemBuilder: (_, index) => ListTile(
              contentPadding: const EdgeInsets.all(10),
              onTap: () async {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(bookID: book_displayed[index].pk),
                ));
              },
              title: Text(book_displayed[index].fields.title, 
                style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              subtitle: Text("${book_displayed[index].fields.author}, ${book_displayed[index].fields.year}",
                style: const TextStyle(color: Colors.black),),
              leading: Image.network(book_displayed[index].fields.imageUrlLarge, fit: BoxFit.cover),
            )
            )
          ),
        ],
      ),
    );
  }
}
