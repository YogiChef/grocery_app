// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app/models/products_model.dart';

class ProductProvider with ChangeNotifier {
  static List<ProductModel> _productList = [];
  List<ProductModel> get getProducts {
    return _productList;
  }

  List<ProductModel> get getOnSaleProducts {
    return _productList.where((element) => element.isOnSale).toList();
  }

  ProductModel findProductById(String proId) {
    return _productList.firstWhere((element) => element.id == proId);
  }

  Future<void> fatchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot snapshot) {
      _productList = [];
      _productList.clear();
      // for (var element in snapshot.docs) {
      snapshot.docs.forEach((element) {
        _productList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('title'),
              imageUrl: element.get('imageUrl'),
              productcategoryName: element.get('productCategoryName'),
              price: double.parse(element.get('price')),
              salePrice: element.get('salePrice'),
              isOnSale: element.get('isOnSale'),
              isPiece: element.get('isPiece'),
            ));
      });
    });
    notifyListeners();
  }

  List<ProductModel> findByCategory(String category) {
    List<ProductModel> _categoryList = _productList
        .where((element) => element.productcategoryName
            .toLowerCase()
            .contains(category.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<ProductModel> searchQuery(String text) {
    List<ProductModel> _searchList = _productList
        .where((element) =>
            element.title.toLowerCase().contains(text.toLowerCase()))
        .toList();
    return _searchList;
  }

  // static final List<ProductModel> _productList = [
  //   ProductModel(
  //       id: '1',
  //       title: 'apple',
  //       imageUrl:
  //           'https://5.imimg.com/data5/AK/RA/MY-68428614/apple-1000x1000.jpg',
  //       productcategoryName: 'Fruits',
  //       price: 45.00,
  //       salePrice: 34.00,
  //       isOnSale: false,
  //       isPiece: true),
  //   ProductModel(
  //       id: '2',
  //       title: 'Durian',
  //       imageUrl:
  //           'https://www.shutterstock.com/image-photo/durian-fruit-fresh-pulp-isolated-260nw-2025524150.jpg',
  //       productcategoryName: 'Fruits',
  //       price: 155.00,
  //       salePrice: 125.00,
  //       isOnSale: true,
  //       isPiece: false),
  //   ProductModel(
  //       id: '3',
  //       title: 'Graps',
  //       imageUrl:
  //           'https://i0.wp.com/www.freshfoodsbkk.com/wp-content/uploads/2017/08/grapes-red-seedless.jpg?fit=500%2C500',
  //       productcategoryName: 'Fruits',
  //       price: 80.00,
  //       salePrice: 68.00,
  //       isOnSale: true,
  //       isPiece: false),
  //   ProductModel(
  //       id: '4',
  //       title: 'Avocado',
  //       imageUrl:
  //           'https://images.immediate.co.uk/production/volatile/sites/30/2020/02/Avocados-3d84a3a.jpg',
  //       productcategoryName: 'Fruits',
  //       price: 145.00,
  //       salePrice: 134.00,
  //       isOnSale: true,
  //       isPiece: true),
  //   ProductModel(
  //       id: '5',
  //       title: 'Watermelon',
  //       imageUrl:
  //           'https://www.gardeningknowhow.com/wp-content/uploads/2021/05/whole-and-slices-watermelon.jpg',
  //       productcategoryName: 'Fruits',
  //       price: 45.00,
  //       salePrice: 34.00,
  //       isOnSale: false,
  //       isPiece: false),
  // ];
}
