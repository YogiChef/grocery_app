import 'package:flutter/cupertino.dart';
import '../models/view_model.dart';

class ViewProvider with ChangeNotifier {
  final Map<String, ViewModel> _viewlistItems = {};

  Map<String, ViewModel> get getViewListItems {
    return _viewlistItems;
  }

  void addProductToHistory({required String proId}) {
    _viewlistItems.putIfAbsent(
        proId,
        () => ViewModel(
              id: DateTime.now().toString(),
              proId: proId,
            ));

    notifyListeners();
  }

  void clearHistory() {
    _viewlistItems.clear();
    notifyListeners();
  }
}
