import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    Key? key,
    required this.image,
    required this.title,
    required this.author,
    required this.year,
  }) : super(key: key);

  final String image;
  final String title;
  final String author;
  final int year;
  final double defaultPadding = 16.0;
  final Color primaryColor = const Color(0xFF2967FF);
  final Color grayColor = const Color(0xFF8D8D8E);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 170,
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(image,fit: BoxFit.cover,),
              ),
            ),
            SizedBox(width: defaultPadding,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: defaultPadding / 2),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        author,
                        style: TextStyle(color: primaryColor),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        child: CircleAvatar(
                          radius: 3,
                          backgroundColor: grayColor,
                        ),
                      ),
                      Text(
                        year.toString(),
                        style: TextStyle(color: grayColor),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}