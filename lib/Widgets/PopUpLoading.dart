import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PopUpLoading {
  showdialog(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      surfaceTintColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 100, vertical: 24),
      content: SizedBox(
        height: 50,
        width: 50,
        child: SpinKitPouringHourGlassRefined(
          color: Color(0xFF337AB7),
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(canPop: false, child: alert);
      },
    );
  }
}