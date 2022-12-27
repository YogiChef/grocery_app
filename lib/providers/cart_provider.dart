// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  // void addProductsToCart({
  //   required String proId,
  //   required int qty,
  // }) {
  //   _cartItems.putIfAbsent(
  //       proId,
  //       () => CartModel(
  //             id: DateTime.now().toString(),
  //             proId: proId,
  //             qty: qty,
  //           ));
  //   notifyListeners();
  // }

  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchCart() async {
    final User? user = auth.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();

    if (userDoc == null) {
      return;
    }
    final leng = userDoc.get('userCart').length;
    for (int i = 0; i < leng; i++) {
      _cartItems.putIfAbsent(
          userDoc.get('userCart')[i]['proId'],
          () => CartModel(
              id: userDoc.get('userCart')[i]['cartId'],
              proId: userDoc.get('userCart')[i]['proId'],
              qty: userDoc.get('userCart')[i]['qty']));
    }
    notifyListeners();
  }

  void reduceQuantityByOne(String proId) {
    _cartItems.update(
        proId,
        (value) => CartModel(
              id: value.id,
              proId: proId,
              qty: value.qty - 1,
            ));
    notifyListeners();
  }

  void increaseQuantityByOne(String proId) {
    _cartItems.update(
        proId,
        (value) => CartModel(
              id: value.id,
              proId: proId,
              qty: value.qty + 1,
            ));
    notifyListeners();
  }

  Future<void> removeOneItem(
      {required String cartId, required String proId, required int qty}) async {
    final User? user = auth.currentUser;
    await userCollection.doc(user!.uid).update({
      'userCart': FieldValue.arrayRemove([
        {'cartId': cartId, 'proId': proId, 'qty': qty}
      ])
    });
    _cartItems.remove(proId);
    await fetchCart();
    notifyListeners();
  }

  Future<void> clearOnlineCart() async {
    final User? user = auth.currentUser;
    await userCollection.doc(user!.uid).update({
      'userCart': [],
    });
    _cartItems.clear();
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
