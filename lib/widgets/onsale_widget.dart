// ignore_for_file: unnecessary_null_comparison, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/inner/product_detail.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/service/global_methods.dart';
import 'package:grocery_app/widgets/price_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../models/products_model.dart';
import '../providers/dark_theme_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/view_provider.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({
    super.key,
  });

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final Color color = themeState.getDarkTheme ? Colors.white70 : Colors.black;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool _isInWish =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    final viewProvider = Provider.of<ViewProvider>(context);   
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        color: isDark
            ? Colors.white
            : Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
             viewProvider.addProductToHistory(proId: productModel.id);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FancyShimmerImage(
                          imageUrl: productModel.imageUrl,
                          height: size.width * 0.28,
                          width: size.width * 0.4,
                          boxFit: BoxFit.fill,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 10,
                      child: Column(
                        children: [
                          TextWidget(
                            text: productModel.isPiece ? '1 Piece' : '1 Kg.',
                            color: isDark ? Colors.grey : color,
                            textSize: 16,
                            isTitle: true,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                    final User? user = auth.currentUser;
                                  try {
                                    if (user == null) {
                                      errorDialog(
                                        "No user found, Please login first",
                                        context,
                                      );
                                      return;
                                    }
                                    // _isInCart
                                    // ? cartProvider
                                    //     .removeOneItem( )
                                    // :

                                    _isInCart
                                        ? await cartProvider.removeOneItem(
                                            cartId: cartProvider
                                                .getCartItems[productModel.id]!
                                                .id,
                                            proId: productModel.id,
                                            qty: 1)
                                        : await addToCart(
                                            productId: productModel.id,
                                            qty: 1,
                                            context: context);                                  
                                    await cartProvider.fetchCart();
                                  } catch (e) {
                                    errorDialog(e.toString(), context);
                                  } finally {} //     proId: productModel.id, qty: 1);
                                },
                                child: Icon(
                                  _isInCart
                                      ? IconlyBold.bag2
                                      : IconlyLight.bag2,
                                  size: 20,
                                  color: _isInCart
                                      ? Colors.red
                                      : isDark
                                          ? Colors.grey
                                          : color,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  final User? user = auth.currentUser;
                                  try {
                                    if (user == null) {
                                      errorDialog(
                                        "No user found, Please login first",
                                        context,
                                      );
                                      return;
                                    }
                                    if (_isInWish == false &&
                                        _isInWish != null) {
                                      await addToWishlist(
                                          productId: productModel.id,
                                          context: context);
                                    } else {
                                      await wishlistProvider.removeOneItem(
                                          wishlistId: wishlistProvider
                                              .getWishlistItems[
                                                  productModel.id]!
                                              .id,
                                          proId: productModel.id);
                                    }
                                    await wishlistProvider.fetchWishlist();
                                  } catch (e) {
                                    log(e.toString());
                                  } finally {}
                                },
                                child: Icon(
                                  _isInWish != null && _isInWish == true
                                      ? IconlyBold.heart
                                      : IconlyLight.heart,
                                  size: 20,
                                  color: _isInWish != null && _isInWish == true
                                      ? Colors.red
                                      : isDark
                                          ? Colors.grey
                                          : color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextWidget(
                    text: productModel.title,
                    color: Colors.black,
                    isTitle: true,
                    textSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                PriceWidget(
                  salePrice: productModel.salePrice,
                  price: productModel.price,
                  textPrice: '1',
                  isOnSale: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
