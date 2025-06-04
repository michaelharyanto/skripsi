import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Controllers/MenuDetailPageController.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Pages/CartPage.dart';
import 'package:skripsi/Pages/ReviewListPage.dart';
import 'package:skripsi/Widgets/HeroPhotoView.dart';

// ignore: must_be_immutable
class MenuDetailPage extends StatefulWidget {
  menu currentMenu;
  MenuDetailPage({super.key, required this.currentMenu});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  MenuDetailPageController m = Get.put(MenuDetailPageController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    m.checkWishlist(widget.currentMenu.menu_id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('menu list')
              .doc(widget.currentMenu.menu_id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else {
              var menuData = snapshot.data!.data()!;
              return Column(
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height * 0.35,
                    decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.4)),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(HeroPhotoView(
                            imagePath: menuData['menu_image'], tag: 'image'));
                      },
                      child: Hero(
                          tag: 'image',
                          child: CachedNetworkImage(
                              imageUrl: menuData['menu_image'])),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Detail Menu',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700),
                            ),
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 100),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Obx(() => IconButton(
                                  onPressed: () {
                                    if (!m.isWishlist.value) {
                                      m.addWishlist(
                                          context, widget.currentMenu.menu_id!);
                                    } else {
                                      m.removeWishlist(
                                          context, widget.currentMenu.menu_id!);
                                    }
                                  },
                                  icon: Icon(
                                    m.isWishlist.value
                                        ? MdiIcons.heart
                                        : MdiIcons.heartOutline,
                                    size: 24,
                                    color: m.isWishlist.value
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ))),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey[400]!))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'Nama Menu',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                )),
                                Expanded(
                                    child: Text(
                                  menuData['menu_name'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey[400]!))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'Deskripsi Menu',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                )),
                                Expanded(
                                    child: Text(
                                  menuData['menu_desc'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey[400]!))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'Harga Menu',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                )),
                                Expanded(
                                    child: Text(
                                  NumberFormat.currency(
                                          locale: 'id_ID',
                                          decimalDigits: 0,
                                          symbol: 'Rp')
                                      .format(menuData['menu_price']),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey[400]!))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'Stok',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                )),
                                Expanded(
                                    child: Text(
                                  menuData['menu_stock'].toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: GlobalVar.currentUser.user_role != 'tenant',
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[400]!))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                      child: Text(
                                    'Penjual',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500),
                                  )),
                                  FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(menuData['tenant_id'])
                                          .get(),
                                      builder: (context, tenantSnapshot) {
                                        if (!tenantSnapshot.hasData) {
                                          return Container();
                                        } else {
                                          return Expanded(
                                              child: Text(
                                            tenantSnapshot.data!['user_name'],
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500),
                                          ));
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('menu list')
                                .doc(widget.currentMenu.menu_id)
                                .collection('reviews')
                                .orderBy('created', descending: true)
                                .limit(3)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                if (snapshot.data!.docs.isEmpty) {
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[400]!))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Ulasan',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                  '0 ulasan',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Color(0xFFF8D24C),
                                                ),
                                                Text(
                                                  menuData['averageRating']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 28,
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              color: Color(int.parse(
                                                  "#FF979797"
                                                      .replaceAll('#', ""),
                                                  radix: 16)),
                                            ))),
                                          );
                                        },
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            // product.value.reviews.length <= 3
                                            //     ? product.value.reviews.length
                                            //     :
                                            1,
                                      ),
                                    ],
                                  );
                                }
                                var reviewData = snapshot.data!.docs;
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[400]!))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Ulasan',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('menu list')
                                                      .doc(widget
                                                          .currentMenu.menu_id)
                                                      .collection('reviews')
                                                      .count()
                                                      .get()
                                                      .asStream(),
                                                  builder:
                                                      (context, countSnapshot) {
                                                    if (countSnapshot.hasData) {
                                                      return Text(
                                                        '${countSnapshot.data!.count} ulasan',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      );
                                                    } else {
                                                      return const Text(
                                                        '0 ulasan',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      );
                                                    }
                                                  }),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Color(0xFFF8D24C),
                                              ),
                                              Text(
                                                menuData['averageRating']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 28,
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      itemBuilder: (context, index) {
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          reviewData[index][
                                                                  'createdByName']
                                                              .toString()
                                                              .replaceAllMapped(
                                                                  RegExp(
                                                                      r'(?<=\b\w)\w+'),
                                                                  (match) {
                                                            return '*' *
                                                                match
                                                                    .group(0)!
                                                                    .length;
                                                          }),
                                                          style:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        Row(
                                                          children: [
                                                            IgnorePointer(
                                                              ignoring: true,
                                                              child: PannableRatingBar
                                                                  .builder(
                                                                      rate: reviewData[index]
                                                                              [
                                                                              'rating']
                                                                          .toDouble(),
                                                                      itemBuilder:
                                                                          (p0,
                                                                              p1) {
                                                                        return const RatingWidget(
                                                                            unSelectedColor:
                                                                                Colors.grey,
                                                                            selectedColor: Color(0xFFF8D24C),
                                                                            child: Icon(
                                                                              Icons.star,
                                                                              size: 20,
                                                                            ));
                                                                      },
                                                                      spacing:
                                                                          1,
                                                                      itemCount:
                                                                          5),
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text(
                                                              '(${reviewData[index]['rating'].toDouble()})',
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      DateFormat(
                                                              'dd MMM yyyy HH:mm')
                                                          .format(DateFormat(
                                                                  'yyyy-MM-dd HH:mm:ss')
                                                              .parse(reviewData[
                                                                      index]
                                                                  ['created'])),
                                                      style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: reviewData[index]
                                                          ['comment']
                                                      .toString()
                                                      .isNotEmpty,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Text(
                                                      '${reviewData[index]['comment']}',
                                                      style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: reviewData[index]
                                                              ['image']
                                                          .isEmpty
                                                      ? 0
                                                      : 120,
                                                  child: ListView.builder(
                                                    itemBuilder:
                                                        (context, imageIndex) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Get.to(
                                                                HeroPhotoView(
                                                              imagePath:
                                                                  reviewData[
                                                                          index]
                                                                      ['image'],
                                                              tag:
                                                                  '$index - $imageIndex',
                                                            ));
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
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey)),
                                                            child: Hero(
                                                              tag:
                                                                  '$index - $imageIndex',
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    reviewData[
                                                                            index]
                                                                        [
                                                                        'image'],
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    itemCount: 1,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: reviewData.length,
                                    ),
                                  ],
                                );
                              }
                            }),
                        GestureDetector(
                          onTap: () {
                            Get.to(ReviewListPage(
                                menu_id: widget.currentMenu.menu_id!));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Lihat Semua Ulasan',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: 24,
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ),
      )),
      bottomNavigationBar: Visibility(
        visible: GlobalVar.currentUser.user_role != 'tenant',
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey,
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3))
          ]),
          child: InkWell(
            onTap: () {
              m.showBuyModal(context, widget.currentMenu);
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.cartPlus,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    'Tambah Ke Keranjang',
                    style:
                        TextStyle(fontFamily: 'Poppins', color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Obx(() => Badge(
                  label: Text(
                    GlobalVar.cartCount.value <= 99
                        ? GlobalVar.cartCount.value.toString()
                        : '99+',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  isLabelVisible: GlobalVar.cartCount.value != 0,
                  offset: const Offset(8, -8),
                  backgroundColor: Colors.red,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(const CartPage());
                    },
                    child: Icon(
                      MdiIcons.cartOutline,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
