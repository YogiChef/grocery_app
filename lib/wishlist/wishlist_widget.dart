// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison, empty_catches

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/models/wishlist_model.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/service/global_methods.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../inner/product_detail.dart';
import '../providers/wishlist_provider.dart';

class WishlistWidget extends StatefulWidget {
  const WishlistWidget({super.key, });
 
  @override
  State<WishlistWidget> createState() => _WishlistWidgetState();
}

class _WishlistWidgetState extends State<WishlistWidget> {
  final _qtyCtror = TextEditingController();
  @override
  void initState() {
    _qtyCtror.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _qtyCtror.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final productProvider = Provider.of<ProductProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final getCurrProduct = productProvider.findProductById(wishlistModel.proId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    bool _isInWish =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: getCurrProduct.id);
      },
      child: Container(
        height: size.width * 0.4,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                height: size.width * 0.20,
                width: size.width * 0.25,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: FancyShimmerImage(
                  imageUrl: getCurrProduct.imageUrl,
                  boxFit: BoxFit.fill,
                ),
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 20,
                          child: IconButton(
                              onPressed: () async {
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
                                        productId:getCurrProduct.id, context: context);
                                  } else {
                                    await wishlistProvider.removeOneItem(
                                        wishlistId: wishlistProvider
                                            .getWishlistItems[
                                                getCurrProduct.id]!
                                            .id,
                                        proId: wishlistModel.proId);
                                  }
                                  await wishlistProvider.fetchWishlist();
                                } catch (e) {
                                } finally {}
                              },
                              icon: Icon(
                                _isInWish != null && _isInWish == true
                                    ? IconlyBold.heart
                                    : IconlyLight.heart,
                                size: 20,
                                color: _isInWish != null && _isInWish == true
                                    ? Colors.red
                                    : Colors.black54,
                              )),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              IconlyLight.bag2,
                              size: 20,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      text: getCurrProduct.title,
                      color: Colors.black,
                      textSize: 16,
                      maxLines: 1,
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      text: usedPrice.toStringAsFixed(2),
                      color: Colors.black,
                      textSize: 16,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
