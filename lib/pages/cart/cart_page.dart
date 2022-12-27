// ignore_for_file: dead_code, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/order_provider.dart';
import 'package:grocery_app/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/dark_theme_provider.dart';
import '../../providers/products_provider.dart';
import '../../service/global_methods.dart';
import '../../widgets/text_widget.dart';
import 'cart_empty.dart';
import 'cart_widget.dart';

class CartPage extends StatelessWidget {
  static const routeName = 'cart_page';
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                warningDialog('Empty your cart?', 'Are you sure?', () async {
                  await cartProvider.clearOnlineCart();
                  cartProvider.clearLocalCart();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }, context, 'images/cart.json');
              },
              icon: Icon(
                IconlyBroken.delete,
                color: isDark ? Colors.white70 : Colors.grey,
              ))
        ],
        title: TextWidget(
          text: 'Cart (${cartItemList.length})',
          isTitle: true,
          color: isDark ? Colors.cyan : Colors.black,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.transparent,
      ),
      body: cartItemList.isEmpty
          ? CartEmpty(isDark: isDark)
          : Column(
              children: [
                _checkOut(size, context),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemList.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: cartItemList[index],
                          child: CartWidget(
                            qty: cartItemList[index].qty,
                          ));
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _checkOut(Size size, BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrdersProvider>(context);
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProductById(value.proId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.qty;
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: size.height * 0.05,
        child: Row(
          children: [
            ButtonWidget(
              lable: 'Order Now',
              press: () async {
                User? user = auth.currentUser;
                final orderId = const Uuid().v4();
                final productProvider =
                    Provider.of<ProductProvider>(context, listen: false);

                cartProvider.getCartItems.forEach((key, value) async {
                  final getCurrProduct =
                      productProvider.findProductById(value.proId);
                  try {
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(orderId)
                        .set({
                      'orderId': orderId,
                      'userId': user!.uid,
                      'proId': value.proId,
                      'price': (getCurrProduct.isOnSale
                              ? getCurrProduct.salePrice
                              : getCurrProduct.price) *
                          value.qty,
                      'total': total,
                      'qty': value.qty,
                      'imageUrl': getCurrProduct.imageUrl,
                      'userName': user.displayName,
                      'orderDate': Timestamp.now(),
                    });
                    await cartProvider.clearOnlineCart();
                    cartProvider.clearLocalCart();                    
                    orderProvider.fatchOrders();
                    await Fluttertoast.showToast(
                        msg: "Your order has been placed",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey.shade300,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  } catch (e) {
                    errorDialog(e.toString(), context);
                  } finally {}
                });
              },
            ),
            const Spacer(),
            FittedBox(
              child: TextWidget(
                text: 'Total: ฿ ${total.toStringAsFixed(2)}',
                color: isDark ? Colors.cyan : Colors.black,
                isTitle: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
