import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    Key? key
  }) : super(key: key);

  final double defaultPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    Color loadingColor = Colors.black.withOpacity(0.1);
    return Shimmer.fromColors(
      baseColor: Colors.black54,
      highlightColor: Colors.black12,
      direction: ShimmerDirection.ttb, // added direction
      period: const Duration(milliseconds: 900), // added period
      child: Container(
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
                      CircleAvatar(backgroundColor: loadingColor, radius: 25),
                      SizedBox(width: defaultPadding,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 15,
                            width: 150,
                            padding: EdgeInsets.all(defaultPadding / 2),
                            decoration: BoxDecoration(
                                color: loadingColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(defaultPadding))),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            height: 15,
                            width: 80,
                            padding: EdgeInsets.all(defaultPadding / 2),
                            decoration: BoxDecoration(
                                color: loadingColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(defaultPadding))),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(width: defaultPadding*2.5,)
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Container(
                height: 15,
                width: 300,
                padding: EdgeInsets.all(defaultPadding / 2),
                decoration: BoxDecoration(
                    color: loadingColor,
                    borderRadius:
                          BorderRadius.all(Radius.circular(defaultPadding))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Container(
                height: 15,
                width: 300,
                padding: EdgeInsets.all(defaultPadding / 2),
                decoration: BoxDecoration(
                    color: loadingColor,
                    borderRadius:
                          BorderRadius.all(Radius.circular(defaultPadding))),
              ),
            ),
          ],
        ),
      )
    );
  }
}