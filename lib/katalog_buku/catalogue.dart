import 'package:booka_mobile/katalog_buku/add_form.dart';
import 'package:booka_mobile/katalog_buku/booka_detail.dart';
import 'package:booka_mobile/landing_page/login.dart';
import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booka_mobile/models/stock.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  _CataloguePageState createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  List<Book> _allBooks = [];
  List<Book> _displayedBooks = [];
  List<Stock> _allStocks = [];
  List<Stock> _displayedStocks = [];

  @override
  void initState() {
    super.initState();
    fetchBook();
    _fetchStocks();

    setState(() {
      _displayedBooks = _allBooks;
      _displayedStocks = _allStocks;
    });
  }

  void updateList(String value){
    setState(() {
      _displayedBooks = _allBooks
        .where((element) => 
          element.fields.title.toLowerCase().contains(value.toLowerCase()) ||
          element.fields.author.toLowerCase().contains(value.toLowerCase())).toList();
      
      _displayedStocks = _allStocks.where((stock) {
        return _displayedBooks.any((book) => book.pk == stock.pk);
      }).toList();

    }); 
  }

  String changeUrl(String url) {
    String newUrl = url.replaceAll('http://images.amazon.com' , 'https://m.media-amazon.com');
    return newUrl;
  }
  
  Future<List<Book>> fetchBook() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url =
        Uri.parse(
          // 'http://10.0.2.2:8000/api/books/'
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
      _allBooks = fetchedBooks;
      _displayedBooks = List.from(_allBooks);
    });

    return fetchedBooks;
  }

  Future<List<Stock>> _fetchStocks() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        // 'http://10.0.2.2:8000/catalogue/json/'
        'https://deploytest-production-cf18.up.railway.app/catalogue/json/'
      );
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Stock> listProduct = [];
    for (var d in data) {
        if (d != null) {
            listProduct.add(Stock.fromJson(d));
        }
    }

    setState(() {
      _allStocks = listProduct;
      _displayedStocks = List.from(_allStocks);
    });

    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>(); // Jika Anda memerlukan 'user' di bawah
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      drawer: const LeftDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          const SizedBox(height: 40,),
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ini akan mengatur ruang antara teks dan tombol
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Books',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  user.is_superuser ? _addBookButton() : Container()
                ],
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: _displayedBooks.isNotEmpty ? bookCard(request) : const Center(child: Text("No books founds"),)
              ),
            ],
          )
          ),
          
        ],
      ),
    );
  }

  Padding _addBookButton() {
    return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      onPressed: () {
                        // Aksi ketika tombol Add Book ditekan
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddBookFormPage()),
                        );
                      },
                      child: Text(
                        'Add Book',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
  }

  ListView bookCard(CookieRequest request) {
    return ListView.builder(
                itemCount: _displayedStocks.length,
                itemBuilder: (_, index) => 
                Container(
                        height: 150,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.11),
                              offset: const Offset(0, 10),
                              blurRadius: 40,
                              spreadRadius: 0.0
                            )
                          ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                            width: 90,
                            height: 135,
                            child: FadeInImage(
                              placeholder: const AssetImage('assets/images/no_image.jpg'),
                              image: NetworkImage(changeUrl(_displayedBooks[index].fields.imageUrlMedium),),
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return const Image(
                                  image: AssetImage('assets/images/no_image.jpg'),
                                );
                              }
                            )
                            ),
                            const SizedBox(width: 20,),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _displayedBooks[index].fields.title,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "by ${ _displayedBooks[index].fields.author}",
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w800,
                                      color: Color.fromARGB(255, 134, 132, 132)
                                    ),
                                  ),
                                  Text(
                                    "Rp${ _displayedStocks[index].fields.price}",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo
                                    ),
                                  ),
                                  Text(
                                    "Tersedia : ${ _displayedStocks[index].fields.quantity}",
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w200,
                                      color: Color.fromARGB(255, 134, 132, 132)
                                    ),
                                  )
                                ],
                              )
                            ),
                            // SizedBox(width: 30,),
                            IconButton(
                            onPressed: () {
                              if(request.loggedIn){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailsPage(
                                      bookId: _displayedBooks[index].pk,
                                      bookName: _displayedBooks[index].fields.title,
                                    ),
                                  ),
                                );
                              }else{
                                ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(const SnackBar(content: Text("Login terlebih dahulu!")));
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()));
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 20.0,
                            )
                          )
                          ],
                        ),
                        // color: Colors.green,
                      ),
              );
  }


  Container _searchField() {
    return Container(
          margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.11),
                blurRadius: 40,
                spreadRadius: 0.0
              )
            ]
          ),
          child: TextField(
            onChanged: (value) => updateList(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(15),
              hintText: 'Search Book by title',
              hintStyle: const TextStyle(
                color: Color.fromARGB(255, 139, 137, 133),
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 20.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none
              )
            ),
          ),
        );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Booka Catalogue'),
      centerTitle: true,
    );
  }
}