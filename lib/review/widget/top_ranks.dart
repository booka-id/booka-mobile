import 'dart:convert';

import 'package:booka_mobile/models/user.dart';
import 'package:booka_mobile/review/screens/book_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class TopRanksWidget extends StatelessWidget {
  const TopRanksWidget({Key? key}) : super(key: key);

  final double defaultPadding = 16.0;
  final Color primaryColor = const Color(0xFF2967FF);
  final Color grayColor = const Color(0xFF8D8D8E);

  Future<List<dynamic>> getBookRanks() async {
    String url =
        // "http://10.0.2.2:8000/review/rating_ranks";
        "https://deploytest-production-cf18.up.railway.app/review/rating_ranks/";

    // Make the HTTP GET request
    http.Response response = await http.get(Uri.parse(url));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> bookRankList = jsonDecode(response.body);

      if (bookRankList.isNotEmpty) {
        return bookRankList;
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

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    final request = context.watch<CookieRequest>();
    return Center(
      child: FutureBuilder<List<dynamic>>(
        future: getBookRanks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Placeholder for loading state
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Placeholder for error state
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text(
                'No data available'); // Placeholder for empty data state
          } else {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 300, // Set a fixed height for the container
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  String rank = (index + 1).toString();
                  int id = snapshot.data![index]['id'];
                  String title = snapshot.data![index]['title'];
                  String author = snapshot.data![index]['author'];
                  String imageUrl = snapshot.data![index]['image_url'];
                  double avgRating = snapshot.data![index]['avg_rating'] ?? 0.0;
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      // decoration: BoxDecoration(
                      //   border: Border.all(width: 2, color: Colors.indigo),
                      //   borderRadius: BorderRadius.circular(15)
                      // ),
                      width: 170,
                      height: 180,
                      child: InkWell(
                        onTap: () => {
                          if (request.loggedIn)
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookDetailPage(bookID: id)))
                            }
                          else
                            {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(const SnackBar(
                                    content: Text("Login terlebih dahulu!")))
                            }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 170,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  changeUrl(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              author,
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  avgRating.toStringAsFixed(1),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ));
                },
              ),
            );
          }
        },
      ),
    );
  }
}
