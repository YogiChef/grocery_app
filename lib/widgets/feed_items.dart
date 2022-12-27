// ignore_for_file: unnecessary_null_comparison, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/inner/product_detail.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/widgets/price_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_const.dart';
import '../models/products_model.dart';
import '../providers/dark_theme_provider.dart';
import '../providers/view_provider.dart';
import '../providers/wishlist_provider.dart';
import '../service/global_methods.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    super.key,
  });

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _qtyCtr = TextEditingController();
  final User? use = auth.currentUser;
  @override
  void initState() {
    _qtyCtr.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _qtyCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
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
        color: Theme.of(context).cardColor.withOpacity(0),
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            viewProvider.addProductToHistory(proId: productModel.id);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                height: size.width * 0.37,
                width: double.infinity,
                boxFit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: productModel.title,
                      color: color,
                      isTitle: true,
                      textSize: 16,
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
                          if (_isInWish == false && _isInWish != null) {
                            await addToWishlist(
                                productId: productModel.id, context: context);
                          } else {
                            await wishlistProvider.removeOneItem(
                                wishlistId: wishlistProvider
                                    .getWishlistItems[productModel.id]!.id,
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
                            ? Colors.deepOrange
                            : color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              PriceWidget(
                salePrice: productModel.salePrice,
                price: productModel.price,
                textPrice: _qtyCtr.text,
                isOnSale: productModel.isOnSale,
              ),
              Flexible(
                child: Row(
                  children: [
                    TextWidget(
                      text: productModel.isPiece ? 'Piece' : 'Kg.',
                      textSize: 15,
                      color: Colors.green,
                      isTitle: true,
                    ),
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: _qtyCtr,
                        key: const ValueKey('10'),
                        style: TextStyle(
                            color: color,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        enabled: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                        ],
                      ),
                    )),
                    TextButton(
                      onPressed: () async {
                          final User? user = auth.currentUser;
                        if (user == null) {
                          errorDialog(
                            "No user found, Please login first",
                            context,
                          );
                          return;
                        }
                        _isInCart
                            ? cartProvider.removeOneItem(
                                cartId: cartProvider
                                    .getCartItems[productModel.id]!.id,
                                proId: productModel.id,
                                qty: 1)
                            : await addToCart(
                                productId: productModel.id,
                                qty: int.parse(_qtyCtr.text),
                                context: context);
                        await cartProvider.fetchCart();
                        // cartProvider.addProductsToCart(
                        //     proId: productModel.id,
                        //     qty: int.parse(_qtyCtr.text));
                      },
                      child: Text(
                        _isInCart ? 'In Cart' : 'Add to card',
                        style: TextStyle(
                          color: _isInCart ? Colors.red : Colors.cyan,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
