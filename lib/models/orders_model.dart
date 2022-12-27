import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModel with ChangeNotifier {
  final String orderId, userId, proId, userName, price, imagUrl, qty;
  final Timestamp orderDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.proId,
    required this.userName,
    required this.price,
    required this.imagUrl,
    required this.qty,
    required this.orderDate,
  });
}
