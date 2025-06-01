import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class HeroPhotoView extends StatelessWidget {
  final String imagePath;
  final String tag;
  HeroPhotoView({super.key, required this.imagePath, required this.tag});

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            constraints: BoxConstraints.expand(height: Get.height),
            child: PhotoViewGallery.builder(
              pageController: pageController,
              itemCount: 1,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                    heroAttributes: PhotoViewHeroAttributes(tag: tag),
                    imageProvider: imagePath.startsWith('http')
                        ? CachedNetworkImageProvider(imagePath)
                        : FileImage(File(imagePath)) as ImageProvider);
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).padding.top + 10,
                  horizontal: 10),
              child: Icon(
                Icons.cancel,
                color: Colors.white,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}
