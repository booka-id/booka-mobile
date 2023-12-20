import 'package:booka_mobile/landing_page/bottom_nav_bar.dart';
import 'package:booka_mobile/models/review.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:booka_mobile/review/screens/book_detail.dart';
import 'package:booka_mobile/review/screens/book_search.dart';
import 'package:booka_mobile/review/widget/card_skeleton.dart';
import 'package:booka_mobile/review/widget/review_card.dart';
import 'package:flutter/material.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

import '../../landing_page/login.dart';
import '../../profile/profile_page.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final int _selectedIndex = 1;
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
        'https://deploytest-production-cf18.up.railway.app/review/all/'
        // 'http://10.0.2.2:8000/review/all/'
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

  Future<List<Review>> fetchUserReviews(int id) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://deploytest-production-cf18.up.railway.app/review/user/$id'
        // 'http://10.0.2.2:8000/review/user/$id'
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
    String url =
        // "http://10.0.2.2:8000/review/get_user/$id";
        "https://deploytest-production-cf18.up.railway.app/review/get_user/$id";

    // Make the HTTP GET request
    http.Response response = await http.get(Uri.parse(url));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> userDataList = jsonDecode(response.body);
      String noImage = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';

      if (userDataList.isNotEmpty) {
        // Extract username from the first user's fields
        Map<String, dynamic> userData = userDataList[0];
        String username = userData['fields']['username'];
        List<String> identityList = [];
        identityList.add(username);
        if(userData['fields']['image_url'] == null){
          identityList.add(noImage);
        }else{
          identityList.add(userData['fields']['image_url']);
        }
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
    String url =
        // "http://10.0.2.2:8000/review/books/$id";
        "https://deploytest-production-cf18.up.railway.app/review/books/$id";

    // Make the HTTP GET request
    http.Response response = await http.get(Uri.parse(url));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      dynamic userData = jsonDecode(response.body);

      if (userData != null) {
        // Extract username from the first user's fields
        String title = userData['title'];
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
    String url =
        // 'http://10.0.2.2:8000/review/delete/$id'; // Replace with your API base URL
        'https://deploytest-production-cf18.up.railway.app/review/delete/$id'; // Replace with your API base URL
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

  void showCardOptions(int id, bool isAdmin) {
    showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: [
                if (isAdmin)
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 20.0),
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.indigo,
                    ),
                    title: const Text("Delete Review"),
                    onTap: () async {
                      await deleteReview(id);
                      Navigator.of(context).pop(); // Close the bottom sheet
                      refreshFutureBuilder();
                    },
                  ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 20.0),
                  leading: const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.indigo,
                  ),
                  title: const Text("Go to this book"),
                  onTap: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(
                          bookID: id,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booka',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child:
              //User Sudah Login
              Consumer<UserProvider>(builder: (context, user, _) {
                return CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(user.profile_picture),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()));
                    },
                  ),
                );
              })
          ),
        ],
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
      bottomNavigationBar: BotNavBar(2),
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
                        return const Column(
                          children: [
                            SkeletonCard(),
                            SkeletonCard(),
                            SkeletonCard(),
                          ],
                        );
                      } else {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "There's no reviews yet...",
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        } else {
                          return ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: Colors.grey[450],
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) {
                              return FutureBuilder<List<String>>(
                                future: getUsername(
                                    snapshot.data![index].fields.user),
                                builder: (context,
                                    AsyncSnapshot<List<String>>
                                        usernameSnapshot) {
                                  return FutureBuilder<String>(
                                    future: getBookTitle(
                                        snapshot.data![index].fields.book),
                                    builder: (context,
                                        AsyncSnapshot<String>
                                            bookTitleSnapshot) {
                                      if (usernameSnapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          bookTitleSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                        return const SkeletonCard();
                                      } else if (usernameSnapshot.hasError ||
                                          bookTitleSnapshot.hasError) {
                                        return Text(
                                            'Error: ${usernameSnapshot.error ?? bookTitleSnapshot.error}');
                                      } else {
                                        return InkWell(
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookDetailPage(
                                                          bookID: snapshot
                                                              .data![index]
                                                              .fields
                                                              .book),
                                                ),
                                              );
                                            },
                                            child: ReviewCard(
                                              image: usernameSnapshot.data![1],
                                              username:
                                                  usernameSnapshot.data![0],
                                              rating: snapshot
                                                  .data![index].fields.rating,
                                              content: snapshot
                                                  .data![index].fields.content,
                                              bookTitle: bookTitleSnapshot.data,
                                              bookId: snapshot
                                                  .data![index].fields.book,
                                              isAdmin: snapshot.data![index]
                                                          .fields.user ==
                                                      user.id ||
                                                  user.is_superuser,
                                              isInFeeds: true,
                                              showCardOptions: showCardOptions,
                                            ));
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
                        return const Center(child: SkeletonCard());
                      } else {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return request.loggedIn
                              ? const Center(
                                  child: Text(
                                    "You've never written your review.",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    "Log in to see your reviews.",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                        } else {
                          return ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) {
                              return FutureBuilder<List<String>>(
                                future: getUsername(
                                    snapshot.data![index].fields.user),
                                builder: (context,
                                    AsyncSnapshot<List<String>>
                                        usernameSnapshot) {
                                  return FutureBuilder<String>(
                                    future: getBookTitle(
                                        snapshot.data![index].fields.book),
                                    builder: (context,
                                        AsyncSnapshot<String>
                                            bookTitleSnapshot) {
                                      if (usernameSnapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          bookTitleSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                        return const SkeletonCard();
                                      } else if (usernameSnapshot.hasError ||
                                          bookTitleSnapshot.hasError) {
                                        return Text(
                                            'Error: ${usernameSnapshot.error ?? bookTitleSnapshot.error}');
                                      } else {
                                        return InkWell(
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookDetailPage(
                                                          bookID: snapshot
                                                              .data![index]
                                                              .fields
                                                              .book),
                                                ),
                                              );
                                            },
                                            child: ReviewCard(
                                              image: usernameSnapshot.data![1],
                                              username:
                                                  usernameSnapshot.data![0],
                                              rating: snapshot
                                                  .data![index].fields.rating,
                                              content: snapshot
                                                  .data![index].fields.content,
                                              bookTitle: bookTitleSnapshot.data,
                                              bookId: snapshot
                                                  .data![index].fields.book,
                                              isAdmin: snapshot.data![index]
                                                          .fields.user ==
                                                      user.id ||
                                                  user.is_superuser,
                                              isInFeeds: true,
                                              showCardOptions: showCardOptions,
                                            ));
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
