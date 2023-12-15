import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    Key? key,
    required this.image,
    required this.username,
    required this.rating,
    required this.bookTitle,
    required this.bookId,
    required this.content,
    required this.isAdmin,
    required this.showCardOptions,
  }) : super(key: key);

  final String image;
  final String username;
  final String content;
  final String bookTitle;
  final int bookId;
  final int rating;
  final bool isAdmin;
  final void Function(int, bool) showCardOptions;
  final double defaultPadding = 16.0;
  final Color primaryColor = const Color(0xFF2967FF);
  final Color grayColor = const Color(0xFF8D8D8E);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(image),radius: 25),
              SizedBox(width: defaultPadding,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Review by $username",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "⭐ $rating/5",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(width: defaultPadding*4,),
              IconButton(
                onPressed: () {
                  showCardOptions(bookId, isAdmin);
                },
                icon: Icon(Icons.more_vert)
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Text(
              "$content",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.menu_book_rounded, color: Colors.grey),
                SizedBox(width: 10,),
                Container (
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$bookTitle",
                        style: TextStyle(color: Colors.grey[800]),)
                    ]
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}