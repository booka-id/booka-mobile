import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/models/review.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:booka_mobile/review/card_skeleton.dart';
import 'package:booka_mobile/review/review_card.dart';
import 'package:booka_mobile/review/review_form.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BookDetailPage extends StatefulWidget {
  final int bookID;
  const BookDetailPage({Key? key, required this.bookID}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState(bookID: bookID);
}

class _BookDetailPageState extends State<BookDetailPage> {
  final int bookID;
  int refresher = 0;

  _BookDetailPageState({required this.bookID});

  void handleSubmit(){
    setState(() {
      refresher++;
    });
  }

  Future<List<Book>> fetchBookDetails() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://deploytest-production-cf18.up.railway.app/review/books/$bookID'
        // 'http://127.0.0.1:8000/review/all/'
        );
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Book> allReview = [];
    for (var d in data) {
      if (d != null) {
        allReview.add(Book.fromJson(d));
      }
    }
    return allReview;
  }

  Future<List<String>> getBookDetails() async {
    // String url = "http://10.0.2.2:8000/review/books/$bookID";
    String url = "https://deploytest-production-cf18.up.railway.app/review/books/$bookID";

    // Make the HTTP GET request
    http.Response response = await http.get(Uri.parse(url));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      dynamic userData = jsonDecode(response.body);
      print(userData);

      if (userData != null) {
        // Extract username from the first user's fields
        String author = userData['author'];
        String title = userData['title'];
        String image_url_large = userData['image_url_large'];
        String publisher = userData['publisher'];
        double avg_rating =
            userData['avg_rating'] == null ? 0.0 : userData['avg_rating'];
        int year = userData['year'];
        String isbn = userData['isbn'];
        List<String> bookDetailList = [];
        bookDetailList.add(author);
        bookDetailList.add(title);
        bookDetailList.add(image_url_large);
        bookDetailList.add(publisher);
        bookDetailList.add(avg_rating.toStringAsFixed(1));
        bookDetailList.add(year.toString());
        bookDetailList.add(isbn);
        return bookDetailList;
      } else {
        throw Exception('No user data found');
      }
    } else {
      // Request failed, throw an error or return null
      throw Exception('Failed to fetch user data');
    }
  }

  String changeUrl(String url) {
    String newUrl = url.replaceAll(
        'http://images.amazon.com', 'https://m.media-amazon.com');
    return newUrl;
  }

  Future<List<Review>> fetchBookReviews() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://deploytest-production-cf18.up.railway.app/review/get_reviews/${bookID}'
        // 'http://10.0.2.2:8000/review/get_reviews/${bookID}'
        // 'http://127.0.0.1:8000/review/get_reviews/${bookID}'
        );
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Review> allReview = [];
    for (var d in data) {
      if (d != null) {
        allReview.add(Review.fromJson(d));
      }
    }
    return allReview;
  }

  Future<List<String>> getUsername(int id) async {
    // String url = "http://10.0.2.2:8000/review/get_user/$id";
    String url = "https://deploytest-production-cf18.up.railway.app/review/get_user/$id";

    // Make the HTTP GET request
    http.Response response = await http.get(Uri.parse(url));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> userDataList = jsonDecode(response.body);

      if (userDataList.isNotEmpty) {
        // Extract username from the first user's fields
        Map<String, dynamic> userData = userDataList[0];
        String username = userData['fields']['username'];
        List<String> identityList = [];
        identityList.add(username);
        identityList.add(userData['fields']['image_url']);
        return identityList;
      } else {
        throw Exception('No user data found');
      }
    } else {
      // Request failed, throw an error or return null
      throw Exception('Failed to fetch user data');
    }
  }

  void showReviewsBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (context) {
          final user = context.read<UserProvider>();
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: MediaQuery.of(context).size.height * 0.75,
            color: Colors.white70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: const Text(
                    'What they say about this book...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: fetchBookReviews(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: 
                        Column(
                          children: [
                            SkeletonCard(),
                            SkeletonCard(),
                            SkeletonCard(),
                          ],
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "Be the first to review this book!",
                            style: TextStyle( fontSize: 20),
                          ),
                        );
                      } else {
                        if (!snapshot.hasData) {
                          return const Column(
                            children: [
                              Text(
                                "Be the first to review this book!",
                                style: TextStyle( fontSize: 20),
                              ),
                              SizedBox(height: 8),
                            ],
                          );
                        } else {
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1, color: Colors.grey),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) {
                              return FutureBuilder<List<String>>(
                                future: getUsername(
                                    snapshot.data![index].fields.user),
                                builder: (context,
                                    AsyncSnapshot<List<String>>
                                        usernameSnapshot) {
                                  if (usernameSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SkeletonCard();
                                  } else if (usernameSnapshot.hasError) {
                                    return Text(
                                        'Error: ${usernameSnapshot.error}');
                                  } else {
                                    return Container(
                                        child: ReviewCard(
                                      image: usernameSnapshot.data![1],
                                      username: usernameSnapshot.data![0],
                                      rating:
                                          snapshot.data![index].fields.rating,
                                      content:
                                          snapshot.data![index].fields.content,
                                      bookId: snapshot.data![index].fields.book,
                                      isAdmin:
                                          snapshot.data![index].fields.user ==
                                                  user.id ||
                                              user.is_superuser,
                                      isInFeeds: false,
                                    ));
                                  }
                                },
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  void showAddReviewBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            color: Colors.white70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'How was your journey on this book?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ReviewFormPage(bookID: bookID, onSubmit: handleSubmit,),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Book Detail'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<String>>(
        future: getBookDetails(),
        builder: (context, snapshot) {
          String author = snapshot.data![0];
          String title = snapshot.data![1];
          String image_url_large = snapshot.data![2];
          String publisher = snapshot.data![3];
          String avg_rating = snapshot.data![4];
          String year = snapshot.data![5];
          String isbn = snapshot.data![6];
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          changeUrl(image_url_large), // Gunakan URL gambar cover buku dari data API
                          fit: BoxFit.fitWidth,
                          // width: 80.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${title}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "by $author",
                              style: TextStyle(
                                fontSize: 18, 
                                color: Colors.grey[700]
                              ),
                            ),
                            Text(
                              '$year',
                              style: TextStyle(
                                fontSize: 18, 
                                color: Colors.grey[700]
                              ),
                            ),
                            Text(
                              'Publisher: $publisher',
                              style: TextStyle(
                                fontSize: 18, 
                                color: Colors.grey[700]
                              ),
                            ),
                            Text(
                              'ISBN: ${isbn}',
                              style: TextStyle(
                                fontSize: 18, 
                                color: Colors.grey[700]
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // BUTTON ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust the alignment as needed
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.amber,
                            width: 2
                          )
                        ),
                        child: Row(
                          children: [
                          const Icon(Icons.star, color: Colors.amber, size: 35,),
                          const SizedBox(width: 5,),
                          Text(
                            avg_rating,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w300,
                              color: Colors.amber
                            ),
                          ),
                        ],),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.indigo,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.article_outlined),
                              color: Colors.white, // Change the icon color as needed
                              onPressed: () {
                                // Add your onPressed logic for "See Reviews" here
                                showReviewsBottomSheet();
                              },
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'See Reviews',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.indigo,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add_comment),
                              color: Colors.white, // Change the icon color as needed
                              onPressed: () {
                                // Add your onPressed logic for "See Reviews" here
                                showAddReviewBottomSheet();
                              },
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Add Review',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30,)
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
