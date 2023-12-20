import 'package:booka_mobile/katalog_buku/booka_detail.dart';
import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/models/purchase.dart';
import 'package:flutter/material.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booka_mobile/models/stock.dart';

class HistoryPurchasePage extends StatefulWidget {
  final int userId;
  const HistoryPurchasePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HistoryPurchasePageState createState() => _HistoryPurchasePageState();
}

class _HistoryPurchasePageState extends State<HistoryPurchasePage> {
  List<int> _allBooksId = [];
  List<Purchase> _allPurchases = [];
  List<Purchase> _displayedPurchases = [];
  List<Book> _allBooks = [];
  List<Book> _displayedBooks = [];
  List<Stock> _allStocks = [];
  List<Stock> _displayedStocks = [];
  String ayam = "gagal";
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchBookId();
    await _fetchBook();
    await _fetchStocks();
    // Now that all data is fetched, update the displayed lists.
    setState(() {
      _displayedPurchases = _allPurchases;
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
      _displayedPurchases = _allPurchases.where((purchase) {
        return _displayedBooks.any((book) => book.pk == purchase.fields.book);
      }).toList();
    });
  }

  String changeUrl(String url) {
    String newUrl = url.replaceAll(
        'http://images.amazon.com', 'https://m.media-amazon.com');
    return newUrl;
  }

  Future<List<Purchase>> fetchBookId() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        // 'http://10.0.2.2:8000/api/books/'
        'https://deploytest-production-cf18.up.railway.app/catalogue/get-bookpurchase/${widget.userId}/'
        // 'http://127.0.0.1:8000/review/all/'
        );
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Purchase> fetchedBooksPurchase = [];
    List<int> tes = [];
    for (var d in data) {
      if (d != null) {
        var purchase = Purchase.fromJson(d);
        fetchedBooksPurchase.add(purchase);
        tes.add(purchase.fields.book);
      }
    }
    setState(() {
      _allBooksId = tes;
      _allPurchases = fetchedBooksPurchase;
      _displayedPurchases = List.from(_allPurchases);
    });

    return fetchedBooksPurchase;
  }

  Future<void> _fetchBook() async {
    List<Book> fetchedBooks = [];
    String halo = "tes";
    // var url = Uri.parse(
    //       'https://deploytest-production-cf18.up.railway.app/catalogue/book-json/1/'
    //       // Include the other URLs as fallback or comment out
    //   );
    // var response = await http.get(
    //     url,
    //     headers: {"Content-Type": "application/json"},
    //   );

    //     // melakukan decode response menjadi bentuk json
    // var data = jsonDecode(utf8.decode(response.bodyBytes));
    // fetchedBooks.add(Book.fromJson(data[0]));

    for (int bookId in _allBooksId) {
      var url = Uri.parse(
          'https://deploytest-production-cf18.up.railway.app/catalogue/book-json/$bookId/'
          // Include the other URLs as fallback or comment out
      );
      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

        // melakukan decode response menjadi bentuk json
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      // Tambahkan buku ke fetchedBooks jika ID cocok
      if (data !=null){
        fetchedBooks.add(Book.fromJson(data[0]));

      }
    }

    setState(() {
      ayam = halo;
      _allBooks = fetchedBooks;
      _displayedBooks = List.from(_allBooks);
    });
  }


  Future<List<Stock>> _fetchStocks() async {
    List<Stock> fetchedStocks = [];

    for (var bookId in _allBooksId) {
      var url = Uri.parse(
          'https://deploytest-production-cf18.up.railway.app/catalogue/bookstock-json/$bookId/'
          // Include the other URLs as fallback or comment out
      );
      
      try {
        var response = await http.get(
          url,
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          // melakukan decode response menjadi bentuk json
          var data = jsonDecode(utf8.decode(response.bodyBytes));

          // Tambahkan buku ke fetchedBooks jika ID cocok
          var stock = Stock.fromJson(data[0]);
          fetchedStocks.add(stock);
        } else {
          // Handle the case where the book is not found or other network issues
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (e) {
        // Handle any errors that occur during the fetch
        print(e);
      }
    }

    setState(() {
      _allStocks = fetchedStocks;
      _displayedStocks = List.from(_allStocks);
    });

    return fetchedStocks;
  }

  @override
  Widget build(BuildContext context) {
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
                      'History',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: _displayedBooks.isNotEmpty
                      ? bookCard()
                      :  Center(
                          child: Text("No books founds, get your own book now"),
                        )),
            ],
          )),
        ],
      ),
    );
  }

  
  ListView bookCard() {
                  return ListView.builder(
                    itemCount: _displayedStocks.length,
                    itemBuilder: (_, index) {
                    int quantity = _displayedPurchases[index].fields.quantity;
                    int pricePerUnit = _displayedStocks[index].fields.price;
                    int totalPrice = quantity * pricePerUnit;
                    return Container(
                      height: 215,
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
                            spreadRadius: 0.0,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 90,
                            height: 135,
                            child: FadeInImage(
                              placeholder: const AssetImage('assets/images/no_image.jpg'),
                              image: NetworkImage(changeUrl(_displayedBooks[index].fields.imageUrlMedium)),
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return const Image(
                                  image: AssetImage('assets/images/no_image.jpg'),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20,),
                          Expanded(
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
                                SizedBox(height: 15,),
                                Text(
                                  "amount : ${_displayedPurchases[index].fields.quantity}",
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w800,
                                    color: Color.fromARGB(255, 134, 132, 132),
                                  ),
                                ),
                                Text(
                                  "Rp${totalPrice}",
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                                Text(
                                  "${_displayedPurchases[index].fields.paymentMethod}",
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w800,
                                    color: Color.fromARGB(255, 134, 132, 132),
                                  ),
                                ),
                                Text(
                                  "${_displayedPurchases[index].fields.purchaseTime}",
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w200,
                                    color: Color.fromARGB(255, 134, 132, 132),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookDetailsPage(
                                          bookId: _displayedBooks[index].pk,
                                          bookName: _displayedBooks[index].fields.title,
                                        ),
                                      ),
                                    );
                                  }, 
                                  child: Text(
                                    "See this book again",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 109, 108, 108),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                          ],
                        ),
                        // color: Colors.green,
                      );
                    }
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
        'Booka History',
        ),
      centerTitle: true,
    );
  }
}
