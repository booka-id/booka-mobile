import 'package:flutter/material.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';

class BookList extends StatelessWidget {
  final String type;
  const BookList(this.type, {Key? key}) : super(key: key);

  String changeUrl(String url) {
    String newUrl = url.replaceAll('http://images.amazon.com' , 'https://m.media-amazon.com');
    return newUrl;
  }

  List<Fields> getBooks(UserProvider user, String type){
    if (type == 'favorit') {
      return user.favorite_book;
    } else if(type == 'wishlist'){
      return user.wishlist;
    }else{
      return user.temp_books;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, user, child) {
        List<Fields> books = getBooks(user, type);
        return Center(
            child: SizedBox(
              height: 275,
                child: books.isEmpty ?
                const SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'Belum ada buku',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )) :
                ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                  return SizedBox(
                    width: 150,
                    height: 250,
                    child: Card(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: FadeInImage(
                                placeholder: const AssetImage('assets/images/no_image.jpg'),
                                image: NetworkImage(changeUrl(books[index].imageUrlMedium)),
                                fit: BoxFit.cover,
                                placeholderErrorBuilder: (context, error, stackTrace) {
                                  return const Image(
                                    image: AssetImage('assets/images/no_image.jpg'),
                                  );
                                }
                              )
                            ),
                            SizedBox(
                              height: 75,
                              child: Text(
                                books[index].title,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              child: Text(
                                'By: ${books[index].author}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )),
                  );
                },
                )
                )
            );
        },

        );
      }
}