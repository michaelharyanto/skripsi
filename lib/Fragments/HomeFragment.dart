import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:shimmer/shimmer.dart';
import 'package:skripsi/Controllers/HomePageController.dart';
import 'package:skripsi/Controllers/TenantHomeFragmentController.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Pages/CartPage.dart';
import 'package:skripsi/Pages/MenuDetailPage.dart';
import 'package:skripsi/Pages/TenantMenuListPage.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  HomePageController h = Get.put(HomePageController());
  final colors = [Colors.blue, Colors.green, Colors.red, Colors.yellow];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Obx(() => h.carouselList.isNotEmpty
              ? Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    cs.CarouselSlider.builder(
                        itemCount: h.carouselList.length,
                        itemBuilder: (context, index, realIndex) {
                          return SizedBox(
                            height: 196,
                            width: Get.width,
                            child: CachedNetworkImage(
                                imageUrl: h.carouselList[index]),
                          );
                        },
                        options: cs.CarouselOptions(
                          height: 196,
                          viewportFraction: 1,
                          initialPage: h.carouselIndex.value,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          scrollDirection: Axis.horizontal,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 500),
                          enableInfiniteScroll: true,
                          onPageChanged: (index, reason) {
                            h.carouselIndex.value = index;
                          },
                        )),
                    Positioned(
                        child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: h.carouselList.length,
                        itemBuilder: (context, currentindex) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor:
                                  h.carouselIndex.value == currentindex
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ))
                  ],
                )
              : Container(
                  color: Colors.grey[200],
                  height: 196,
                  child: SpinKitPouringHourGlassRefined(
                      color: Theme.of(context).primaryColor),
                )),
          const SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            height: h.tenantList.length < 6 ? 85 : 170,
            child: Obx(() => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: h.tenantList.length < 6 ? 1 : 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                  itemBuilder: (context, index) {
                    final row = index ~/ (h.tenantList.length < 6 ? 1 : 2);
                    final color = colors[row % colors.length];
                    return Container(
                      height: 60,
                      child: InkWell(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.person,
                                color: color,
                              ),
                              width: 40,
                              height: 40,
                            ),
                            Text(
                              h.tenantList[index].user_name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins'),
                            )
                          ],
                        ),
                        onTap: () {
                          Get.to(MenuListPage(
                              tenant_id: h.tenantList[index].user_id,
                              tenant_name: h.tenantList[index].user_name));
                        },
                      ),
                    );
                  },
                  itemCount: h.tenantList.length,
                  scrollDirection: Axis.horizontal,
                )),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Rekomendasi Menu Hari Ini',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('menu list')
                          .where('isActive', isEqualTo: true)
                          .where('menu_stock',isNotEqualTo: 0)
                          .orderBy('averageRating', descending: true)
                          .limit(10)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Shimmer(
                                  gradient: LinearGradient(colors: [
                                    Colors.grey[400]!,
                                    Colors.white
                                  ]),
                                  child: Container(
                                    height: 100,
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var menuData = snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  onTap: () {
                                    menu currentMenu =
                                        menu.fromJson(menuData.data());
                                    Get.to(MenuDetailPage(
                                      currentMenu: currentMenu,
                                    ));
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                height: 80,
                                                width: 80,
                                                child: CachedNetworkImage(
                                                    color: (menuData[
                                                                    'menu_stock'] ==
                                                                0 ||
                                                            menuData[
                                                                    'isActive'] ==
                                                                false)
                                                        ? Colors.grey[400]
                                                        : Colors.transparent,
                                                    colorBlendMode:
                                                        BlendMode.saturation,
                                                    fit: BoxFit.fill,
                                                    imageUrl:
                                                        menuData['menu_image']),
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              flex: 3,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    menuData['menu_name'],
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    NumberFormat.currency(
                                                            locale: 'id_ID',
                                                            decimalDigits: 0,
                                                            symbol: 'Rp')
                                                        .format(menuData[
                                                            'menu_price']),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    'Stok: ${menuData['menu_stock']}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(menuData[
                                                              'tenant_id'])
                                                          .snapshots(),
                                                      builder: (context,
                                                          tenantSnapshot) {
                                                        if (!tenantSnapshot
                                                            .hasData) {
                                                          return const SizedBox
                                                              .shrink();
                                                        } else {
                                                          return Text(
                                                            'Tenant: ${tenantSnapshot.data!.data()!['user_name']}',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          );
                                                        }
                                                      }),
                                                  // SizedBox(
                                                  //   height: 4,
                                                  // ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xFFF8D24C),
                                                      ),
                                                      Text(
                                                        menuData[
                                                                'averageRating']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                  // SizedBox(height: 4,),
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        title: 
        // GestureDetector(
        //   child: Container(
        //     height: 40,
        //     decoration: BoxDecoration(
        //         color: Colors.white, borderRadius: BorderRadius.circular(8)),
        //     padding: const EdgeInsets.symmetric(horizontal: 5),
        //     child: const Row(
        //       children: [
        //         Icon(Icons.search, color: Colors.grey),
        //         SizedBox(
        //           width: 5,
        //         ),
        //         Text(
        //           'Cari',
        //           style: TextStyle(
        //               fontSize: 14, color: Colors.black, fontFamily: 'Poppins'),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        Text(
          '${TenantHomeFragmentController().changeGreetings(DateTime.now())} ${GlobalVar.currentUser.user_name.split(' ')[0]}',
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Obx(() => GestureDetector(
                  onTap: () {
                    Get.to(CartPage());
                  },
                  child: Badge(
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
                      child: Icon(
                        MdiIcons.cartOutline,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
