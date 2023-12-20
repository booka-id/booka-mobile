import 'dart:convert';

import 'package:booka_mobile/katalog_buku/edit_form.dart';
import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/models/stock.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:booka_mobile/review/screens/book_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BookDetailsPage extends StatefulWidget {
  final int bookId;
  final String bookName;

  const BookDetailsPage({
    Key? key,
    required this.bookId,
    required this.bookName,
  }) : super(key: key);

  @override
  State<BookDetailsPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailsPage> {
  late Book book;
  late Stock stock;
  Future<void>? _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchBookData();
  }

  Future<void> _fetchBookData() async {
    final bookUrl = Uri.parse(
        // 'http://10.0.2.2:8000/catalogue/book-json/${widget.bookId}/'
        'https://deploytest-production-cf18.up.railway.app/catalogue/book-json/${widget.bookId}/');
    final bookstockUrl = Uri.parse(
        // 'http://10.0.2.2:8000/catalogue/bookstock-json/${widget.bookId}/'
        'https://deploytest-production-cf18.up.railway.app/catalogue/bookstock-json/${widget.bookId}/');

    var bookResponse = await http.get(
      bookUrl,
      headers: {"Content-Type": "application/json"},
    );
    var bookstockResponse = await http.get(
      bookstockUrl,
      headers: {"Content-Type": "application/json"},
    );

    var bookData = jsonDecode(utf8.decode(bookResponse.bodyBytes));
    var bookstockData = jsonDecode(utf8.decode(bookstockResponse.bodyBytes));
    setState(() {
      book = Book.fromJson(bookData[0]);
      stock = Stock.fromJson(bookstockData[0]);
    });
  }

  String changeUrl(String url) {
    String newUrl = url.replaceAll(
        'http://images.amazon.com', 'https://m.media-amazon.com');
    return newUrl;
  }

  Future<void> submitOrder(
      int userId, int quantity, String paymentMethod) async {
    final url = Uri.parse(
        // 'http://10.0.2.2:8000/catalogue/buy-book-flutter/'
        'https://deploytest-production-cf18.up.railway.app/catalogue/buy-book-flutter/'); // Ganti dengan URL API yang sesuai
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'book_id': widget.bookId.toString(),
        'user_id': userId.toString(),
        'quantity': quantity.toString(),
        'payment_method': paymentMethod,
        // Tambahkan field lain jika diperlukan
      }),
    );

    if (response.statusCode == 200) {
      // Jika server mengembalikan respons sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order berhasil disimpan!")),
      );
      Navigator.of(context).pop(); // Tutup popup pembelian
    } else {
      // Jika terjadi kesalahan saat mengirimkan order
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: ${response.body}")),
      );
    }
  }

  Future<void> deleteBook(int bookId, BuildContext context) async {
    final url = Uri.parse(
        // 'http://10.0.2.2:8000/catalogue/delete-book-flutter/$bookId/'
        'https://deploytest-production-cf18.up.railway.app/catalogue/delete-book-flutter/$bookId/'); // Sesuaikan dengan URL API Anda
    final response = await http.post(url);

    if (response.statusCode == 200) {
      // Berhasil menghapus buku
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Buku berhasil dihapus.")),
      );
      // Kembali ke halaman sebelumnya atau refresh list buku
      Navigator.of(context).pop();
    } else {
      // Terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat menghapus buku.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName),
      ),
      body: FutureBuilder(
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Tampilkan loading indicator
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Tampilkan error jika ada
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Container(
                decoration: const BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                  Colors.indigo,
                  Color.fromARGB(255, 89, 105, 198),
                  Color.fromARGB(255, 149, 158, 209)
                ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 140,
                            height: 210,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    changeUrl(book.fields.imageUrlMedium),
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60)),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: SingleChildScrollView(
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.fields.title,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                const Text(
                                  "Author",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          Color.fromARGB(255, 134, 132, 132)),
                                ),
                                Text(
                                  book.fields.author,
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                const Text(
                                  "Year",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          Color.fromARGB(255, 134, 132, 132)),
                                ),
                                Text(
                                  "${book.fields.year}",
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                const Text(
                                  "Publisher",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          Color.fromARGB(255, 134, 132, 132)),
                                ),
                                Text(
                                  book.fields.publisher,
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                const Text(
                                  "ISBN",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          Color.fromARGB(255, 134, 132, 132)),
                                ),
                                Text(
                                  book.fields.isbn,
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                const Text(
                                  "Year",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          Color.fromARGB(255, 134, 132, 132)),
                                ),
                                Text(
                                  "${book.fields.year}",
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "Rp${stock.fields.price}",
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo),
                                ),
                                Text(
                                  "Tersedia : ${stock.fields.quantity}",
                                  style: const TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w200,
                                      color:
                                          Color.fromARGB(255, 134, 132, 132)),
                                ),
                              ],
                            ),
                          )),
                    ))
                  ],
                ),
              );
            }
          }),
      bottomNavigationBar:
          user.is_superuser ? _adminBar(context) : _userBar(user.id),
    );
  }

  SafeArea _userBar(int userId) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Menyusun tombol dengan rata
          children: <Widget>[
            // Tombol Beli
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Colors.indigo),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    _showPurchasePopup(context, userId);
                  },
                  child: const Text(
                    'Beli',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10), // Jarak antar tombol
            // Tombol Review
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    // Aksi ketika tombol Review ditekan
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookDetailPage(
                                  bookID: widget.bookId,
                                )));
                  },
                  child: const Text(
                    'Cek Review',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SafeArea _adminBar(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Menyusun tombol dengan rata
          children: <Widget>[
            // Tombol Beli
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Colors.indigo),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () async {
                    // Aksi ketika tombol Beli ditekan
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditBookFormPage(bookId: widget.bookId),
                      ),
                    );

                    if (result == 'updated') {
                      _fetchBookData();
                    }
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10), // Jarak antar tombol
            // Tombol Review
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    // Aksi ketika tombol Review ditekan
                    _confirmDelete(widget.bookId, context);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int bookId, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Konfirmasi"),
          content: const Text("Are you sure you want to delete this book?"),
          actions: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(color: Colors.indigo),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Aksi ketika tombol Review ditekan
                  Navigator.of(dialogContext).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Aksi ketika tombol Review ditekan
                  deleteBook(bookId, context);
                  Navigator.of(dialogContext).pop();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPurchasePopup(BuildContext context, int userId) {
    int quantity = 0; // Default quantity
    final pricePerBook = stock.fields.price; // Harga per buku
    int totalPrice = quantity * pricePerBook; // Harga total
    String paymentMethod = 'Cash on Delivery'; // Default payment method

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Purchase Book'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        quantity = int.tryParse(value) ?? 1;
                        totalPrice = quantity * pricePerBook;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Total Price: ${totalPrice.toString()}'),
                  const SizedBox(height: 20),
                  ListTile(
                    title: const Text('Cash on Delivery'),
                    leading: Radio<String>(
                      value: 'Cash on Delivery',
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Mobile Banking'),
                    leading: Radio<String>(
                      value: 'Mobile Banking',
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Menutup dialog
              },
            ),
            TextButton(
              child: const Text('Submit Order'),
              onPressed: () {
                // Logika untuk mengirimkan order
                submitOrder(userId, quantity, paymentMethod);
                Navigator.of(dialogContext).pop(); // Menutup dialog
              },
            ),
          ],
        );
      },
    );
  }
}
