import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Controllers/MenuDetailPageController.dart';
import 'package:skripsi/Controllers/TenantMenuListPageController.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Pages/CartPage.dart';
import 'package:skripsi/Pages/MenuDetailPage.dart';

// ignore: must_be_immutable
class MenuListPage extends StatefulWidget {
  String tenant_id;
  String tenant_name;
  MenuListPage({super.key, required this.tenant_id, required this.tenant_name});

  @override
  State<MenuListPage> createState() => MenuListPageState();
}

class MenuListPageState extends State<MenuListPage> {
  MenuListPageController m = Get.put(MenuListPageController());
  MenuDetailPageController md = Get.put(MenuDetailPageController());
  TextEditingController searchTF = TextEditingController();
  FocusNode TFFocus = FocusNode();
  ScrollController sc = ScrollController();
  RxBool isSearching = false.obs;

  @override
  void initState() {
    super.initState();
    m.getTenantMenu(widget.tenant_id);
    TFFocus.addListener(() {
      if (TFFocus.hasFocus) {
        isSearching.value = true;
      } else {
        isSearching.value = false;
      }
    });
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        m.getMoreTenantMenu(widget.tenant_id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Text(widget.tenant_name,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
              child: Obx(() => SingleChildScrollView(
                    child: AlignedGridView.count(
                        controller: sc,
                        crossAxisCount: GlobalVar.isTablet ? 4 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        itemBuilder: (builder, itemindex) {
                          final data = m.menuList[itemindex];
                          return GestureDetector(
                            onTap: () {
                              if ((data.menu_stock == 0 ||
                                  data.isActive == false)) {
                              } else {
                                Get.to(MenuDetailPage(currentMenu: data));
                              }
                            },
                            child: Opacity(
                              opacity: (data.menu_stock == 0 ||
                                      data.isActive == false)
                                  ? 0.5
                                  : 1,
                              child: Material(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                elevation: 5,
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        color: (data.menu_stock == 0 ||
                                                data.isActive == false)
                                            ? Colors.grey[400]
                                            : const Color(0xF5F5F5F5),
                                        alignment: Alignment.center,
                                        child: CachedNetworkImage(
                                          imageUrl: data.menu_image!,
                                          memCacheHeight: 200,
                                          memCacheWidth: 200,
                                          color: (data.menu_stock == 0)
                                              ? Colors.grey[400]
                                              : Colors.transparent,
                                          colorBlendMode: BlendMode.saturation,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.menu_name!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
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
                                              ).format(data.menu_price),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13)),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Stok: ${data.menu_stock}',
                                                      style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14)),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xFFF8D24C),
                                                        size: 20,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                          '${data.averageRating}',
                                                          style:
                                                              const TextStyle(
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
                                              SizedBox(
                                                height: 55,
                                                width: 55,
                                                child: FloatingActionButton(
                                                  heroTag: data.menu_id,
                                                  onPressed: () {
                                                    if (data.menu_stock == 0) {
                                                    } else {
                                                      md.addMenuToCart(context,
                                                          '1', data, false);
                                                    }
                                                  },
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  foregroundColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  mini: true,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  child: Icon(
                                                    MdiIcons.cartPlus,
                                                    color: Colors.white,
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
                        itemCount: m.menuList.length),
                  )))
        ],
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        title: SizedBox(
          height: 40,
          child: TextField(
            focusNode: TFFocus,
            controller: searchTF,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.black),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
                prefixIcon: Icon(
                  Icons.search,
                  color:
                      Theme.of(context).primaryTextTheme.headlineLarge!.color,
                ),
                suffixIcon: Obx(() => Visibility(
                    visible: isSearching.value,
                    replacement: const SizedBox.shrink(),
                    child: GestureDetector(
                      onTap: () {
                        searchTF.clear();
                        TFFocus.unfocus();
                        m.getTenantMenu(widget.tenant_id);
                        // c.searchfoodItems(c.searchTF.text, context);
                      },
                      child: Icon(MdiIcons.closeCircle),
                    ))),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari...',
                alignLabelWithHint: true),
            onEditingComplete: () {
              TFFocus.unfocus();
              m.searchTenantMenu(widget.tenant_id, searchTF.text);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Obx(() => GestureDetector(
                  onTap: () {
                    Get.to(const CartPage());
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
