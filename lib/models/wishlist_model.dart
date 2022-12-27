import 'package:flutter/cupertino.dart';

class WishlistModel with ChangeNotifier {
  final String id, proId;

  WishlistModel({
    required this.id,
    required this.proId,
  });
}
