import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:skripsi/Data%20Model/pesanan.dart';

class ReviewListPageController extends GetxController {
  RxList<review> reviewList = <review>[].obs;
  DocumentSnapshot? lastReview;
  initReviews(String menu_id) {
    FirebaseFirestore.instance
        .collection('menu list')
        .doc(menu_id)
        .collection('reviews')
        .orderBy('created', descending: true)
        .limit(10)
        .get()
        .then((value) {
      reviewList.clear();
      if (value.docs.isNotEmpty) {
        lastReview = value.docs.last;
        for (var element in value.docs) {
          reviewList.add(review.fromJson(element.data()));
        }
      }
    });
  }

  getMoreReviews(String menu_id) {
    FirebaseFirestore.instance
        .collection('menu list')
        .doc(menu_id)
        .collection('reviews')
        .orderBy('created', descending: true)
        .limit(10)
        .startAfterDocument(lastReview!)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        lastReview = value.docs.last;
        for (var element in value.docs) {
          reviewList.add(review.fromJson(element.data()));
        }
      }
    });
  }
}
