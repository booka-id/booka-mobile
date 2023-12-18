import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    Key? key,
    required this.image,
    required this.username,
    required this.rating,
    this.bookTitle,
    required this.bookId,
    required this.content,
    required this.isAdmin,
    this.showCardOptions,
    required this.isInFeeds,
  }) : super(key: key);

  final String image;
  final String username;
  final String content;
  final String? bookTitle;
  final int bookId;
  final int rating;
  final bool isAdmin;
  final bool isInFeeds;
  final void Function(int, bool)? showCardOptions;
  final double defaultPadding = 16.0;
  final Color primaryColor = const Color(0xFF2967FF);
  final Color grayColor = const Color(0xFF8D8D8E);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(image),radius: 25),
                    SizedBox(width: defaultPadding,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: username,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo, // Color for the username part
                                ),
                              ),
                            ],
                          ),
                          softWrap: true,
                        ),
                        Row(children: [
                          const Icon(Icons.star, color: Colors.amber,),
                          const SizedBox(width: 3,),
                          Text(
                            "$rating.0",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[700]
                            ),
                          ),
                        ],)
                      ],
                    )
                  ],
                ),
                SizedBox(width: defaultPadding*2.5,),
                if(isInFeeds)
                IconButton(
                  onPressed: () {
                    showCardOptions!(bookId, isAdmin);
                  },
                  icon: const Icon(Icons.more_vert)
                )
              ],
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: isInFeeds == true ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                const Icon(Icons.menu_book_rounded, color: Colors.grey),
                const SizedBox(width: 10,),
                SizedBox (
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
            ) : null,
          ),
        ],
      ),
    );
  }
}