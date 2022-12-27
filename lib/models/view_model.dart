import 'package:flutter/cupertino.dart';

class ViewModel with ChangeNotifier {
  final String id, proId;

  ViewModel({
    required this.id,
    required this.proId,
  });
}
