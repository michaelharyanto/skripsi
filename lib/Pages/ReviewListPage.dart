import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skripsi/Controllers/ReviewListPageController.dart';
import 'package:skripsi/Widgets/HeroPhotoView.dart';

class ReviewListPage extends StatefulWidget {
  String menu_id;
  ReviewListPage({super.key, required this.menu_id});

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  ReviewListPageController r = Get.put(ReviewListPageController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    r.initReviews(widget.menu_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Obx(() => ListView.builder(
                itemCount: r.reviewList.length,
                itemBuilder: (context, index) {
                  var reviewData = r.reviewList[index];
                  return Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Colors.grey,
                    ))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reviewData.createdByName
                                        .toString()
                                        .replaceAllMapped(
                                            RegExp(r'(?<=\b\w)\w+'), (match) {
                                      return '*' * match.group(0)!.length;
                                    }),
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  Row(
                                    children: [
                                      IgnorePointer(
                                        ignoring: true,
                                        child: PannableRatingBar.builder(
                                            rate: reviewData.rating.toDouble(),
                                            itemBuilder: (p0, p1) {
                                              return const RatingWidget(
                                                  unSelectedColor: Colors.grey,
                                                  selectedColor:
                                                      Color(0xFFF8D24C),
                                                  child: Icon(
                                                    Icons.star,
                                                    size: 20,
                                                  ));
                                            },
                                            spacing: 1,
                                            itemCount: 5),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '(${reviewData.rating.toDouble()})',
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                DateFormat('dd MMM yyyy HH:mm').format(
                                    DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .parse(reviewData.created)),
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: reviewData.comment.toString().isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                '${reviewData.comment}',
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            height: reviewData.image.isEmpty ? 0 : 120,
                            child: ListView.builder(
                              itemBuilder: (context, imageIndex) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(HeroPhotoView(imagePath: reviewData.image, tag: '$index - $imageIndex'));
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder:
                                      //             (context) =>
                                      //                 HeroPhotoView(
                                      //                   galleryItems: reviewData[index]['images'],
                                      //                   reviewIndex: index,
                                      //                   initIndex: imageIndex,
                                      //                   rating: reviewData[index]['averageRating'].toDouble(),
                                      //                   sentAt: DateFormat('yyyy-MM-dd HH:mm:ss').parse(reviewData[index]['sentAt']),
                                      //                   sentBy: reviewData[index]['sentByName'].toString().replaceAllMapped(RegExp(r'(?<=\b\w)\w+'), (match) {
                                      //                     return '*' * match.group(0)!.length;
                                      //                   }),
                                      //                 )));
                                    },
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Hero(
                                        tag: '$index - $imageIndex',
                                        child: CachedNetworkImage(
                                          imageUrl: reviewData.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: 1,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ))),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Ulasan Menu',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
            SizedBox(
              width: 5,
            ),
            Badge(
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
              largeSize: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              label: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('menu list')
                    .doc(widget.menu_id)
                    .collection('reviews')
                    .count()
                    .get()
                    .asStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      '0',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    );
                  } else {
                    return Text(
                      snapshot.data!.count.toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    );
                  }
                },
              ),
              isLabelVisible: true,
            ),
          ],
        ),
      ),
    );
  }
}
