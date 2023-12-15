import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;
  final double defaultPadding = 16.0;
  final Color primaryColor = const Color(0xFF2967FF);
  final Color grayColor = const Color(0xFF8D8D8E);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: Image.network(image,fit: BoxFit.contain,),
            ),
            SizedBox(width: defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: defaultPadding / 2),
                    child: Text(
                      "Classical Mythology",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Mark P. O. Morford",
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
                        "2002",
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