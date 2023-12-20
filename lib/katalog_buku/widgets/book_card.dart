import 'package:booka_mobile/katalog_buku/utils.dart';
import 'package:flutter/material.dart';
import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/models/stock.dart';
// Assuming you have a Utils class for the changeUrl method

class BookCard extends StatelessWidget {
  final Book book;
  final Stock stock;
  final VoidCallback onTap;
  final bool isLoggedIn;

  const BookCard({
    Key? key,
    required this.book,
    required this.stock,
    required this.onTap,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              height: 135,
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/no_image.jpg'),
                image: NetworkImage(Utils.changeUrl(book.fields.imageUrlMedium)),
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
                    book.fields.title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "by ${book.fields.author}",
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 134, 132, 132),
                    ),
                  ),
                  Text(
                    "Rp${stock.fields.price}",
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  Text(
                    "Tersedia : ${stock.fields.quantity}",
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w200,
                      color: Color.fromARGB(255, 134, 132, 132),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 20.0,
            ),
            
          ],
        ),
      ),
    );
  }
}
