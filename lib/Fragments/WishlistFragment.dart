import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Controllers/MenuDetailPageController.dart';
import 'package:skripsi/Controllers/WishlistFragmentController.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Pages/CartPage.dart';
import 'package:skripsi/Pages/MenuDetailPage.dart';

class WishlistFragment extends StatefulWidget {
  const WishlistFragment({super.key});

  @override
  State<WishlistFragment> createState() => _WishlistFragmentState();
}

class _WishlistFragmentState extends State<WishlistFragment> {
  WishlistFragmentController w = Get.put(WishlistFragmentController());
  MenuDetailPageController m = Get.put(MenuDetailPageController());
  @override
  void initState() {
    super.initState();
    w.getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Obx(() => w.wishlist.isNotEmpty
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('menu list')
                      .where('menu_id', whereIn: w.wishlist)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Color(int.parse(
                                        "#FFCECECE".replaceAll('#', ""),
                                        radix: 16))))),
                        child: SingleChildScrollView(
                            child: AlignedGridView.count(
                                crossAxisCount: GlobalVar.isTablet ? 4 : 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 16,
                                itemBuilder: (builder, itemindex) {
                                  final data = snapshot.data.docs[itemindex];
                                  return GestureDetector(
                                    onTap: () {
                                      if ((data['menu_stock'] == 0 ||
                                          data['isActive'] == false)) {
                                      } else {
                                        menu currentMenu =
                                            menu.fromJson(data.data());
                                        Get.to(MenuDetailPage(
                                            currentMenu: currentMenu));
                                      }
                                    },
                                    child: Opacity(
                                      opacity: (data['menu_stock'] == 0 ||
                                              data['isActive'] == false)
                                          ? 0.5
                                          : 1,
                                      child: Material(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: Container(
                                                height: 150,
                                                width: 150,
                                                color: (data['menu_stock'] ==
                                                            0 ||
                                                        data['isActive'] ==
                                                            false)
                                                    ? Colors.grey[400]
                                                    : const Color(0xF5F5F5F5),
                                                alignment: Alignment.center,
                                                child: CachedNetworkImage(
                                                  imageUrl: data['menu_image'],
                                                  memCacheHeight: 200,
                                                  memCacheWidth: 200,
                                                  color: (data['menu_stock'] ==
                                                              0 ||
                                                          data['isActive'] ==
                                                              false)
                                                      ? Colors.grey[400]
                                                      : Colors.transparent,
                                                  colorBlendMode:
                                                      BlendMode.saturation,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['menu_name'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                      NumberFormat.currency(
                                                        locale:
                                                            '${Localizations.localeOf(context)}_ID',
                                                        decimalDigits: 0,
                                                        symbol: 'Rp',
                                                      ).format(
                                                          data['menu_price']),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13)),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                              'Stok: ${data['menu_stock']}',
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      14)),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.star,
                                                                color: Color(
                                                                    0xFFF8D24C),
                                                                size: 20,
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                  '${data.data().containsKey('averageRating') ? data['averageRating'] : 0}',
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Visibility(
                                                        visible: (data[
                                                                    'menu_stock'] !=
                                                                0 ||
                                                            data['isActive'] !=
                                                                false),
                                                        child: SizedBox(
                                                          height: 55,
                                                          width: 55,
                                                          child:
                                                              FloatingActionButton(
                                                            heroTag: data.id,
                                                            onPressed: () {
                                                              menu currentMenu =
                                                                  menu.fromJson(
                                                                      data.data());
                                                              m.addMenuToCart(
                                                                  context,
                                                                  '1',
                                                                  currentMenu,
                                                                  false);
                                                            },
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            splashColor: Colors
                                                                .transparent,
                                                            foregroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                            mini: true,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            child: Icon(
                                                              MdiIcons.cartPlus,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                padding: const EdgeInsets.all(10),
                                // physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.docs.length)),
                      );
                    } else {
                      return Container();
                    }
                  })
              : const Center(
                  child: Text('Belum ada data wishlist',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14)),
                ))),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Wishlist',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 18),
        ),
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
