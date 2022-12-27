// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery_app/consts/conts.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/pages/btm_bar.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/order_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

List<String> imgs = Constss.authImgePaths;

class FetchPage extends StatefulWidget {
  const FetchPage({super.key});

  @override
  State<FetchPage> createState() => _FetchPageState();
}

class _FetchPageState extends State<FetchPage> {
  @override
  void initState() {
    imgs.shuffle();
    Future.delayed(const Duration(microseconds: 5), () async {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      final User? use = auth.currentUser;
      if (use == null) {
        await productProvider.fatchProducts();
        cartProvider.clearLocalCart();
        wishlistProvider.clearLocalWishlist();
        ordersProvider.clearLocalOrders();
      } else {
        await productProvider.fatchProducts();
        await cartProvider.fetchCart();
        await wishlistProvider.fetchWishlist();
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BottomBarPage()));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            imgs[0],
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(
            child: SpinKitFadingCube(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
