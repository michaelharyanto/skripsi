import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('ini home'),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: GestureDetector(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Cari',
                  style: TextStyle(
                      fontSize: 14, color: Colors.black, fontFamily: 'Poppins'),
                )
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 25),
            child: Badge(
              label: Text(
                '99+',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white),
              ),
              offset: Offset(8, -8),
              backgroundColor: Colors.red,
              child: GestureDetector(
                child: Icon(
                  MdiIcons.cartOutline,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
