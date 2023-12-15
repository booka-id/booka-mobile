import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/models/review.dart';
import 'package:booka_mobile/review/review_form.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookDetailPage extends StatefulWidget {
  final int bookID;
    const BookDetailPage({Key? key, required this.bookID}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState(bookID: bookID);
}

class _BookDetailPageState extends State<BookDetailPage> {
  final int bookID;

  _BookDetailPageState({required this.bookID});

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
    return all_review;
}
  String changeUrl(String url) {
    String newUrl = url.replaceAll('http://images.amazon.com' , 'https://m.media-amazon.com');
    return newUrl;
  }
  Future<List<Review>> fetchBookReviews() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        // 'https://deploytest-production-cf18.up.railway.app/review/get_reviews/${bookID}'
        'http://10.0.2.2:8000/review/get_reviews/${bookID}'
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

Future<String> getUsername(int id) async {
  String url = "http://10.0.2.2:8000/review/get_user/$id";

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
      return username;
    } else {
      throw Exception('No user data found');
    }
  } else {
    // Request failed, throw an error or return null
    throw Exception('Failed to fetch user data');
  }
}

Future<String> getUsername(int id) async {
  String url = "http://10.0.2.2:8000/review/get_user/$id";

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
      return username;
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
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "Be the first to review this book!",
                          style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                      );
                    } else {
                        if (!snapshot.hasData) {
                        return const Column(
                            children: [
                            Text(
                                "Be the first to review this book!",
                                style:
                                    TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                            ),
                            SizedBox(height: 8),
                            ],
                        );
                    } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) {
                            return FutureBuilder<String>(
                              future: getUsername(snapshot.data![index].fields.user),
                              builder: (context, AsyncSnapshot<String> usernameSnapshot) {
                                if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (usernameSnapshot.hasError) {
                                  return Text('Error: ${usernameSnapshot.error}');
                                } else {
                                  return InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BookDetailPage(bookID: snapshot.data![index].fields.book),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Review by ${usernameSnapshot.data ?? 'Loading...'}",
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("⭐ ${snapshot.data![index].fields.rating}/5"),
                                          SizedBox(height: 20,),
                                          Text("${snapshot.data![index].fields.content}"),
                                        ],
                                      ),
                                    ),
                                  );
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
    }
  );
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
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom) ,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            color: Colors.white70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: const Text(
                    'How was your journey on this book?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ReviewFormPage(bookID: bookID),
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
        title: Text('Booka'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Book>>(
        future: fetchBookDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var book = snapshot.data![0];
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Image.network(
                    changeUrl(book.fields.imageUrlLarge), // Gunakan URL gambar cover buku dari data API
                    fit: BoxFit.fitWidth,
                    // width: 80.0,
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${book.fields.author}, ${book.fields.year}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          book.fields.publisher,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'ISBN: ${book.fields.isbn}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Text(
                          '⭐5/5', // Gunakan rating dari data API
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Implementasi navigasi ke halaman reviews
                        showReviewsBottomSheet();
                      },
                      child: const Text('See Reviews'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Implementasi navigasi ke halaman tambah review
                        showAddReviewBottomSheet();
                        // Navigator.push(
                        // context,
                        // MaterialPageRoute(
                        //   builder: (context) => ReviewFormPage(bookID: bookID,),
                        // ));
                      },
                      child: const Text('Add Review'),
                    ),
                  ),
                  const SizedBox(height: 20),
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