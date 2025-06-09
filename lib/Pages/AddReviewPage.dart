import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skripsi/Controllers/AddReviewPageController.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart'
    as rating;

// ignore: must_be_immutable
class AddReviewPage extends StatelessWidget {
  List<cart> items;
  String order_id;
  AddReviewPage({super.key, required this.items, required this.order_id});
  AddReviewPageController a = Get.put(AddReviewPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, menuIndex) {
          var menuData = items[menuIndex];
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('menu list')
                  .doc(menuData.menu_id)
                  .collection('reviews')
                  .doc(order_id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  );
                } else {
                  if (snapshot.data!.data() == null) {
                    return InkWell(
                      onTap: () {
                        a.showReviewModal(
                            context,
                            menuData.currentMenu!.menu_name!,
                            menuData.menu_id,
                            order_id,
                            snapshot.data!.data());
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: CachedNetworkImage(
                                    colorBlendMode: BlendMode.saturation,
                                    fit: BoxFit.fill,
                                    imageUrl:
                                        menuData.currentMenu!.menu_image!),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            menuData.currentMenu!.menu_name!,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700),
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 44,
                                                width: 44,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Color(int.parse(
                                                        "#FFF0F0F0".replaceAll(
                                                            '#', ""),
                                                        radix: 16))),
                                                child: Text(
                                                  menuData.quantity.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Poppins',
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                  Visibility(
                                    visible: menuData.notes.isNotEmpty,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: [
                                          RichText(
                                              text: TextSpan(children: [
                                            const TextSpan(
                                                text: 'Catatan: ',
                                                style: TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            TextSpan(
                                                text: menuData.notes,
                                                style: const TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ])),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(menuData.status,
                                      style: const TextStyle(
                                          color: Color(0xFF979797),
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NumberFormat.currency(
                                                locale: 'id_ID',
                                                decimalDigits: 0,
                                                symbol: 'Rp')
                                            .format(menuData.menu_price),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    maxRating: 5,
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    allowHalfRating: true,
                                    unratedColor: Colors.grey,
                                    ignoreGestures: true,
                                    itemSize: 20,
                                    itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Color(0xFFF8D24C)),
                                    onRatingUpdate: (double value) {},
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        a.showReviewModal(
                            context,
                            menuData.currentMenu!.menu_name!,
                            menuData.menu_id,
                            order_id,
                            snapshot.data!.data());
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: CachedNetworkImage(
                                    colorBlendMode: BlendMode.saturation,
                                    fit: BoxFit.fill,
                                    imageUrl:
                                        menuData.currentMenu!.menu_image!),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            menuData.currentMenu!.menu_name!,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700),
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 44,
                                                width: 44,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Color(int.parse(
                                                        "#FFF0F0F0".replaceAll(
                                                            '#', ""),
                                                        radix: 16))),
                                                child: Text(
                                                  menuData.quantity.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Poppins',
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                  Visibility(
                                    visible: menuData.notes.isNotEmpty,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: [
                                          RichText(
                                              text: TextSpan(children: [
                                            const TextSpan(
                                                text: 'Catatan: ',
                                                style: TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            TextSpan(
                                                text: menuData.notes,
                                                style: const TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ])),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(menuData.status,
                                      style: const TextStyle(
                                          color: Color(0xFF979797),
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NumberFormat.currency(
                                                locale: 'id_ID',
                                                decimalDigits: 0,
                                                symbol: 'Rp')
                                            .format(menuData.menu_price),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IgnorePointer(
                                        ignoring: true,
                                        child: rating.PannableRatingBar.builder(
                                            rate: snapshot.data!
                                                .data()!['rating']
                                                .toDouble(),
                                            itemBuilder: (p0, p1) {
                                              return const rating.RatingWidget(
                                                  unSelectedColor: Colors.grey,
                                                  selectedColor:
                                                      Color(0xFFF8D24C),
                                                  child: Icon(
                                                    Icons.star,
                                                    size: 20,
                                                  ));
                                            },
                                            itemCount: 5),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                          "(${snapshot.data!.data()!['rating']})",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14))
                                    ],
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }
              });
        },
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Tambah Ulasan',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
