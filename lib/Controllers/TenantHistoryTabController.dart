import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:skripsi/Fragments/OrderDoneFragment.dart';
import 'package:skripsi/Fragments/OrderFragment.dart';
import 'package:skripsi/Fragments/OrderReadyFragment.dart';

class TenantHistoryTabController extends StatefulWidget {
  const TenantHistoryTabController({super.key});

  @override
  State<TenantHistoryTabController> createState() =>
      _TenantHistoryTabControllerState();
}

class _TenantHistoryTabControllerState extends State<TenantHistoryTabController>
    with TickerProviderStateMixin {
  late TabController tc;
  @override
  void initState() {
    super.initState();
    tc = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: tc, children: [
        OrderFragment(),
        OrderReadyFragment(),
        OrderDoneFragment()
      ]),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Pesanan',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
          ],
        ),
        bottom: TabBar(
          controller: tc,
          unselectedLabelColor: Colors.grey[400],
          tabs: [
            Tab(
              text: "Diterima",
            ),
            Tab(
              child: Text("Siap",
                  style: TextStyle(
                      fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
            ),
            Tab(
              child: Marquee(
                text: "Selesai / Tolak",
                blankSpace: 20.0,
                velocity: 20,
                // pauseAfterRound: Duration(seconds: 1),
              ),
            ),
          ],
          overlayColor: MaterialStatePropertyAll(Colors.grey.shade100),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          labelColor: Colors.white,
          labelStyle:
              TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
