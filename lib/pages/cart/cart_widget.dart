// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/inner/product_detail.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/widgets/button_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../providers/dark_theme_provider.dart';
import '../../providers/wishlist_provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key, required this.qty});
  final int qty;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _qtyCtror = TextEditingController();
  @override
  void initState() {
    _qtyCtror.text = widget.qty.toString();
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
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProductById(cartModel.proId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool _isInWish =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: cartModel.proId);
      },
      child: Row(children: [
        Expanded(
          child: Container(
            height: size.width * 0.2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Container(
                  height: size.width * 0.2,
                  width: size.width * 0.22,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: FancyShimmerImage(
                    imageUrl: getCurrProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: getCurrProduct.title,
                      color: Colors.white,
                      textSize: 20,
                      isTitle: true,
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: Row(
                        children: [
                          _qtyCtr(() {
                            // _qtyCtror.text == '1'
                            //     ? null
                            //     : setState(() {
                            //         _qtyCtror.text =
                            //             (int.parse(_qtyCtror.text) - 1)
                            //                 .toString();
                            //       });

                            if (_qtyCtror.text == '1') {
                              return;
                            } else {
                              cartProvider.reduceQuantityByOne(cartModel.proId);

                              setState(() {
                                _qtyCtror.text =
                                    (int.parse(_qtyCtror.text) - 1).toString();
                              });
                            }
                          }, Icons.remove, Colors.red),
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _qtyCtror,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(),
                              )),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  // if (value.isEmpty) {
                                  //   _qtyCtror.text = '1';
                                  // }
                                  value.isEmpty ? _qtyCtror.text = '1' : null;
                                });
                              },
                            ),
                          ),
                          _qtyCtr(() {
                            cartProvider.increaseQuantityByOne(cartModel.proId);
                            setState(() {
                              _qtyCtror.text =
                                  (int.parse(_qtyCtror.text) + 1).toString();
                            });
                          }, Icons.add, Colors.green),
                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: IconButton(
                          onPressed: () async {
                            await cartProvider.removeOneItem(
                              cartId: cartModel.id,
                              proId: cartModel.proId,
                              qty: cartModel.qty,
                            );
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.red,
                          )),
                    ),
                    SizedBox(
                        width: 25,
                        height: 20,
                        child: HeartBtn(
                          proId: getCurrProduct.id,
                          isInWish: _isInWish,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: TextWidget(
                        text: (usedPrice * int.parse(_qtyCtror.text))
                            .toStringAsFixed(2),
                        textSize: 16,
                        isTitle: true,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _qtyCtr(
    Function()? press,
    IconData icon,
    Color color,
  ) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                icon,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
