// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../consts/firebase_const.dart';
import '../models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

  // void addProductToWishlist({required String proId}) {
  //   if (_wishlistItems.containsKey(proId)) {
  //     removeOneItem( proId: '', wishlistId: '');
  //   } else {
  //     _wishlistItems.putIfAbsent(
  //         proId,
  //         () => WishlistModel(
  //               id: DateTime.now().toString(),
  //               proId: proId,
  //             ));
  //   }
  //   notifyListeners();
  // }
  
  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchWishlist() async {   
     final User? user = auth.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
    if (userDoc == null) {
      return;
    }
    final leng = userDoc.get('userWish').length;
    for (int i = 0; i < leng; i++) {
      _wishlistItems.putIfAbsent(
          userDoc.get('userWish')[i]['proId'],
          () => WishlistModel(
                id: userDoc.get('userWish')[i]['wishlistId'],
                proId: userDoc.get('userWish')[i]['proId'],
              ));
    }
    notifyListeners();
  }

  Future<void> removeOneItem( {
    required String wishlistId,
    required String proId,
  }) async {
    final User? user = auth.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish': FieldValue.arrayRemove([
        {
          'wishlistId': wishlistId,
          'proId': proId,
        }
      ])
    });
    _wishlistItems.remove(proId);
    await fetchWishlist();
    notifyListeners();
  }

  Future<void> clearOnlineWishlist() async {   
     final User? user = auth.currentUser; 
    await userCollection.doc(user!.uid).update({
      'userWish': [],
    });
    _wishlistItems.clear();
    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }

 
}
