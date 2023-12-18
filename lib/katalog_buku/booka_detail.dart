import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/models/stock.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;
  final Stock stock;

  const BookDetailPage({Key? key, required this.book, required this.stock}) : super(key: key);
  String changeUrl(String url) {
    String newUrl = url.replaceAll('http://images.amazon.com' , 'https://m.media-amazon.com');
    return newUrl;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(book.fields.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
               Colors.indigo,
               Color.fromARGB(255, 89, 105, 198),
               Color.fromARGB(255, 149, 158, 209)

            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 140,
                    height: 210,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(changeUrl(book.fields.imageUrlMedium),),
                        fit: BoxFit.cover,
                      )
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: 
                  SingleChildScrollView(
                    child: 
                  Column(
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
                        SizedBox(height: 12,),
                        Text(
                          "Author",
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 134, 132, 132)
                          ),
                        ),
                        Text(
                          book.fields.author,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 7,),
                        Text(
                          "Year",
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 134, 132, 132)
                          ),
                        ),
                        Text(
                          "${ book.fields.year}",
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 7,),
                        Text(
                          "Publisher",
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 134, 132, 132)
                          ),
                        ),
                        Text(
                          book.fields.publisher,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 7,),
                        Text(
                          "ISBN",
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 134, 132, 132)
                          ),
                        ),
                        Text(
                          book.fields.isbn,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 7,),
                        Text(
                          "Year",
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 134, 132, 132)
                          ),
                        ),
                        Text(
                          "${ book.fields.year}",
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 12,),
                        Text(
                          "Rp${ stock.fields.price}",
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo
                          ),
                        ),
                        Text(
                          "Tersedia : ${ stock.fields.quantity}",
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w200,
                            color: Color.fromARGB(255, 134, 132, 132)
                          ),
                        ),
                      ],
                    ),
                    
                  )
                ),
              )
            )
          ],
        ),
      ),
      bottomNavigationBar: user.is_superuser ?  _adminBar() : _userBar(),
    );
  }

  SafeArea _userBar() {
    return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Menyusun tombol dengan rata
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
                    side: BorderSide(color: Colors.indigo),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Aksi ketika tombol Beli ditekan
                },
                child: Text(
                  'Beli',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10), // Jarak antar tombol
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
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Aksi ketika tombol Review ditekan
                },
                child: Text(
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

  SafeArea _adminBar() {
    return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Menyusun tombol dengan rata
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
                    side: BorderSide(color: Colors.indigo),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Aksi ketika tombol Beli ditekan
                },
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10), // Jarak antar tombol
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
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Aksi ketika tombol Review ditekan
                },
                child: Text(
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
}
