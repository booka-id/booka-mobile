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

  ImageProvider getImage(String url){
    ImageProvider image;
    try{
      image = NetworkImage(changeUrl(url));
    }catch(e){
      image = const AssetImage('assets/images/no_image.jpg');
    }
    return image;
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider image;;
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
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    )) :
                ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: books.length,
                    itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 150,
                    height: 200,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: getImage(books[index].imageUrlLarge),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children:[
                                Text(
                                  books[index].title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  books[index].author,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]
                            ),
                          ),
                        )
                    )
                  );
                },
                )
                )
            );
        },

        );
      }
}