import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:skripsi/GlobalVar.dart';

class WishlistFragmentController extends GetxController {
  RxList<String> wishlist = <String>[].obs;
  getWishlist() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(GlobalVar.currentUser.user_id)
        .collection('wishlist')
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        wishlist.add(doc['menu_id']);
      }
    });
  }
}
