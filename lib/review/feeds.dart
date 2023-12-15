import 'package:booka_mobile/landing_page/menu.dart';
import 'package:booka_mobile/models/review.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:booka_mobile/review/book_detail.dart';
import 'package:booka_mobile/review/book_search.dart';
import 'package:booka_mobile/review/review_card.dart';
import 'package:flutter/material.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';


class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _selectedIndex = 1;
  int _refreshCount = 0;

  // Function to refresh the FutureBuilder
  void refreshFutureBuilder() {
    setState(() {
      _refreshCount++; // Update the state to trigger a rebuild
    });
  }

  Future<List<Review>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        // 'https://deploytest-production-cf18.up.railway.app/review/all/'
        'http://10.0.2.2:8000/review/all/'
        );
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Review> all_review = [];
    for (var d in data) {
        if (d != null) {
            all_review.add(Review.fromJson(d));
        }
    }
    return all_review;
}

  Future<List<Review>> fetchUserReviews(int id) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        // 'https://deploytest-production-cf18.up.railway.app/review/all/'
        'http://10.0.2.2:8000/review/user/$id'
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

Future<String> getBookTitle(int id) async {
  String url = "http://10.0.2.2:8000/review/books/$id";

  // Make the HTTP GET request
  http.Response response = await http.get(Uri.parse(url));

  // Check if the request was successful (status code 200)
  if (response.statusCode == 200) {
    // Parse the JSON response
    List<dynamic> userDataList = jsonDecode(response.body);

    if (userDataList.isNotEmpty) {
      // Extract title from the first book's fields
      Map<String, dynamic> userData = userDataList[0];
      String title = userData['fields']['title'];
      return title;
    } else {
      throw Exception('No user data found');
    }
  } else {
    // Request failed, throw an error or return null
    throw Exception('Failed to fetch user data');
  }
}

Future<void> deleteReview(int id) async {
  String url = 'http://10.0.2.2:8000/review/delete/$id'; // Replace with your API base URL
  try {
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      // Review successfully deleted
      print('Review deleted successfully');
      // You can add further actions after successful deletion if needed
    } else {
      // Error occurred while deleting the review
      print('Failed to delete review. Status code: ${response.statusCode}');
      // Handle error or display an error message to the user
    }
  } catch (error) {
    // Exception thrown during deletion
    print('Exception occurred while deleting review: $error');
    // Handle exception or display an error message to the user
  }
}

void showCardOptions(int id, bool isAdmin){
  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    context: context,
    shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical( 
            top: Radius.circular(25.0),
          ),
        ),
    builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            if(isAdmin)
              ListTile(
                contentPadding: EdgeInsets.only(left:20.0),
                leading: Icon(Icons.delete_outline,
                  color: Colors.indigo,
                ),
                title: Text("Delete Review"),
                onTap: () async {
                  await deleteReview(id);
                  Navigator.of(context).pop(); // Close the bottom sheet
                  refreshFutureBuilder();
                },
              ),
            ListTile(
              contentPadding: EdgeInsets.only(left:20.0),
              leading: Icon(Icons.menu_book_rounded,
                color: Colors.indigo,
              ),
              title: Text("Go to this book"),
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailPage(bookID: id,),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  );
}

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    print(user.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booka',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BookSearchPage(),
          ));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.indigo.withOpacity(0.6),
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if(_selectedIndex == 0){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          }else if(_selectedIndex == 1){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewPage(),
              ),
            );

          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30.0,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.comment,
              size: 30.0,
            ),
            label: "Reviews",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.campaign,
              size: 30.0,
            ),
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30.0,
            ),
            label: "Profile",
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Feeds'),
                Tab(text: 'My Reviews'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Feeds Tab Content (using FutureBuilder)
                  FutureBuilder(
                    future: fetchProduct(),
                    builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                            return const Center(child: CircularProgressIndicator());
                        } else {
                            if (!snapshot.hasData) {
                            return const Column(
                                children: [
                                Text(
                                    "Tidak ada data produk.",
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
                                  return FutureBuilder<List<String>>(
                                    future: getUsername(snapshot.data![index].fields.user),
                                    builder: (context, AsyncSnapshot<List<String>> usernameSnapshot) {
                                      return FutureBuilder<String>(
                                        future: getBookTitle(snapshot.data![index].fields.book),
                                        builder: (context, AsyncSnapshot<String> bookTitleSnapshot) {
                                          if (usernameSnapshot.connectionState == ConnectionState.waiting ||
                                              bookTitleSnapshot.connectionState == ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (usernameSnapshot.hasError || bookTitleSnapshot.hasError) {
                                            return Text('Error: ${usernameSnapshot.error ?? bookTitleSnapshot.error}');
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
                                              child: ReviewCard(
                                                image: usernameSnapshot.data![1],
                                                username: usernameSnapshot.data![0],
                                                rating: snapshot.data![index].fields.rating,
                                                bookTitle: bookTitleSnapshot.data!,
                                                content: snapshot.data![index].fields.content,
                                                showCardOptions: showCardOptions,
                                                bookId: snapshot.data![index].fields.book,
                                                isAdmin:snapshot.data![index].fields.user==user.id || user.is_superuser,
                                              )
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                },

                                );
                            }
                        }
                    },
                  ),
                  // Ranks Tab Content (Placeholder)
                  FutureBuilder(
                    // TODO: GANTI DENGAN LOGGED IN USER'S ID
                    future: fetchUserReviews(user.id),
                    builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                            return const Center(child: CircularProgressIndicator());
                        } else {
                            if (!snapshot.hasData) {
                            return const Column(
                                children: [
                                Text(
                                    "Tidak ada data produk.",
                                    style:
                                        TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                                ),
                                SizedBox(height: 8),
                                ],
                            );
                        } else {
                            return ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const Divider(height: 1, color: Colors.grey);
                                },
                                itemCount: snapshot.data!.length,
                                itemBuilder: (_, index) {
                                  return FutureBuilder<List<String>>(
                                    future: getUsername(snapshot.data![index].fields.user),
                                    builder: (context, AsyncSnapshot<List<String>> usernameSnapshot) {
                                      return FutureBuilder<String>(
                                        future: getBookTitle(snapshot.data![index].fields.book),
                                        builder: (context, AsyncSnapshot<String> bookTitleSnapshot) {
                                          if (usernameSnapshot.connectionState == ConnectionState.waiting ||
                                              bookTitleSnapshot.connectionState == ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (usernameSnapshot.hasError || bookTitleSnapshot.hasError) {
                                            return Text('Error: ${usernameSnapshot.error ?? bookTitleSnapshot.error}');
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
                                              child: ReviewCard(
                                                image: user.profile_picture,
                                                username: user.username,
                                                rating: snapshot.data![index].fields.rating,
                                                bookTitle: bookTitleSnapshot.data!,
                                                content: snapshot.data![index].fields.content,
                                                showCardOptions: showCardOptions,
                                                bookId: snapshot.data![index].pk,
                                                isAdmin: true,
                                              )
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                },

                                );
                            }
                        }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}

