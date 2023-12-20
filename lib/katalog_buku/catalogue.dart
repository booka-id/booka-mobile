import 'package:booka_mobile/katalog_buku/add_form.dart';
import 'package:booka_mobile/katalog_buku/api_service.dart';
import 'package:booka_mobile/katalog_buku/booka_detail.dart';
import 'package:booka_mobile/katalog_buku/history_purchase.dart';
import 'package:booka_mobile/katalog_buku/widgets/book_card.dart';
import 'package:booka_mobile/landing_page/login.dart';
import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:booka_mobile/models/stock.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  _CataloguePageState createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  final ApiService _apiService = ApiService();
  List<Book> _allBooks = [];
  List<Book> _displayedBooks = [];
  List<Stock> _allStocks = [];
  List<Stock> _displayedStocks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _allBooks = await _apiService.fetchBooks();
    _allStocks = await _apiService.fetchStocks();

    setState(() {
      _displayedBooks = _allBooks;
      _displayedStocks = _allStocks;
    });
  }

  void updateList(String value) {
    setState(() {
      _displayedBooks = _allBooks
          .where((element) =>
              element.fields.title
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.fields.author.toLowerCase().contains(value.toLowerCase()))
          .toList();

      _displayedStocks = _allStocks.where((stock) {
        return _displayedBooks.any((book) => book.pk == stock.pk);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user =
        context.read<UserProvider>(); // Jika Anda memerlukan 'user' di bawah
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      drawer: const LeftDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          const SizedBox(
            height: 40,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Ini akan mengatur ruang antara teks dan tombol
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
                  user.is_superuser ? _addBookButton() : Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                      icon: Icon(Icons.history),
                      onPressed:() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryPurchasePage(userId: user.id,)),
                        );
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: _displayedBooks.isNotEmpty
                      ? bookCard(request)
                      : const Center(
                          child: Text("No books founds"),
                        )),
            ],
          )),
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
      itemCount: _displayedBooks.length, // Make sure this is the count of displayed books, not stocks
      itemBuilder: (_, index) => BookCard(
        book: _displayedBooks[index],
        stock: _displayedStocks[index], // Ensure this matches the book by index
        onTap: () {
          if (request.loggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailsPage(
                  bookId: _displayedBooks[index].pk,
                  bookName: _displayedBooks[index].fields.title,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text("Please log in first!")));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        },
        isLoggedIn: request.loggedIn,
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
              hintText: 'Search Book by title...',
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
                borderSide: BorderSide.none)),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      title: const Text(
        'Booka Catalogue',
        ),
      centerTitle: true,
    );
  }
}
