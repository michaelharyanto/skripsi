import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ErrorSnackBar extends GetxController {
  showSnack(BuildContext context, String content, double width) {
    Get.snackbar("Error", '',
        titleText: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.alertCircleOutline,
              size: 27,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ERROR",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    content,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11,
                        color: Colors.white),
                    softWrap: true,
                  )
                ],
              ),
            )
          ],
        ),
        borderRadius: 33,
        messageText: SizedBox.shrink(),
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 15,
          bottom: 8,
        ),
        margin: EdgeInsets.symmetric(vertical: 100, horizontal: width),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Theme.of(context).primaryColor,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2));
  }
}
