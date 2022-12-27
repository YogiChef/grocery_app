// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';

class CartModel with ChangeNotifier {
  final String id, proId;
  final qty;

  CartModel({required this.id,required this.proId,required this.qty});

  
}
