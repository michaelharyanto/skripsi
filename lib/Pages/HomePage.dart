import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Controllers/HomePageController.dart';
import 'package:skripsi/Controllers/TenantHistoryTabController.dart';
import 'package:skripsi/Controllers/TenantHomeFragmentController.dart';
import 'package:skripsi/Fragments/ChatroomListFragment.dart';
import 'package:skripsi/Fragments/HistoryFragment.dart';
import 'package:skripsi/Fragments/HomeFragment.dart';
import 'package:skripsi/Fragments/MenuFragment.dart';
import 'package:skripsi/Fragments/ProfileFragment.dart';
import 'package:skripsi/Fragments/TenantHomeFragment.dart';
import 'package:skripsi/Fragments/WishlistFragment.dart';
import 'package:skripsi/GlobalVar.dart';

class HomePage extends StatefulWidget {
  final int? animateToIndex;
  const HomePage({super.key, required this.animateToIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController h = Get.put(HomePageController());
  TenantHomeFragmentController t = Get.put(TenantHomeFragmentController());
  GlobalKey<ConvexAppBarState> appBarKey = GlobalKey<ConvexAppBarState>();
  PageStorageBucket bucket = PageStorageBucket();
  List<Widget> fragments = GlobalVar.currentUser.user_role == 'tenant'
      ? [
          const TenantHomeFragment(),
          const ChatroomListFragment(),
          const TenantHistoryTabController(),
          const MenuFragment(),
          const ProfileFragment()
        ]
      : [
          const HomeFragment(),
          const HistoryFragment(),
          const WishlistFragment(),
          const ProfileFragment()
        ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (GlobalVar.currentUser.user_role == 'tenant') {
      t.initHistory();
      t.initTenantData();
    } else {
      h.getCarrousel();
      h.getCartCount();
    }
    if (widget.animateToIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        appBarKey.currentState!.animateTo(widget.animateToIndex!);
        await Future.delayed(const Duration(milliseconds: 300));
        GlobalVar.currentNavBarIndex.value = widget.animateToIndex!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: false,
        body: Obx(() => PageStorage(
            bucket: bucket,
            child: fragments[GlobalVar.currentNavBarIndex.value])),
        bottomNavigationBar: StyleProvider(
          style: Style(),
          child: Obx(() => ConvexAppBar(
              key: appBarKey,
              activeColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              onTap: (index) {
                GlobalVar.currentNavBarIndex.value = index;
              },
              initialActiveIndex: GlobalVar.currentNavBarIndex.value,
              color: Colors.white,
              items: GlobalVar.currentUser.user_role == 'tenant'
                  ? [
                      TabItem(
                          icon: const Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            Icons.home,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: 'Beranda',
                          fontFamily: 'Poppins'),
                      TabItem(
                          icon: const Icon(
                            Icons.chat_outlined,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            Icons.chat_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: 'Chat',
                          fontFamily: 'Poppins'),
                      TabItem(
                          icon: const Icon(
                            Icons.local_restaurant,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            Icons.local_restaurant,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: 'Pesanan',
                          fontFamily: 'Poppins'),
                      TabItem(
                          icon: const Icon(
                            Icons.restaurant,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            Icons.restaurant,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: 'Menu',
                          fontFamily: 'Poppins'),
                      TabItem(
                          icon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: 'Profil',
                          fontFamily: 'Poppins'),
                    ]
                  : [
                      TabItem(
                          icon: const Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            Icons.home,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: 'Beranda',
                          fontFamily: 'Poppins'),
                      TabItem(
                          icon: const Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            Icons.history,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: 'Riwayat',
                          fontFamily: 'Poppins'),
                      TabItem(
                          icon: Icon(
                            MdiIcons.heart,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            MdiIcons.heart,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: 'Wishlist',
                          fontFamily: 'Poppins'),
                      TabItem(
                          icon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: 'Profil',
                          fontFamily: 'Poppins'),
                    ])),
        ));
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 30;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500);
  }
}
