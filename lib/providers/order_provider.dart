// ignore_for_file: prefer_final_fields, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orderList = [];
  List<OrderModel> get getOrder {
    return _orderList;
  }

   void clearLocalOrders() {
    _orderList.clear();
    notifyListeners();
  }

  Future<void> fatchOrders() async {
    User? user = auth.currentUser;
    await FirebaseFirestore.instance
        .collection('orders')
        .where(
          'userId',
          isEqualTo: user!.uid,
        )
        .get()
        .then((QuerySnapshot snapshot) {
      _orderList = [];
     
      // for (var element in snapshot.docs) {
      snapshot.docs.forEach((element) {
        _orderList.insert(
          0,
          OrderModel(
            orderId: element.get('orderId'),
            userId: element.get('userId'),
            proId: element.get('proId'),
            userName: element.get('userName'),
            price: element.get('price').toString(),
            imagUrl: element.get('imageUrl'),
            qty: element.get('qty').toString(),
            orderDate: element.get('orderDate'),
          ),
        );
      });
    });
    notifyListeners();
  }
}
