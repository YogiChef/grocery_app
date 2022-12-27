// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/providers/view_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../consts/firebase_const.dart';
import '../providers/dark_theme_provider.dart';
import '../providers/cart_provider.dart';
import '../service/global_methods.dart';
import '../widgets/button_widget.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = 'product_details';
  const ProductDetails({
    super.key,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
    final User? user = auth.currentUser;
  final _qtyCtr = TextEditingController(
    text: '1',
  );

  @override
  void dispose() {
    _qtyCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    bool isDark = themeState.getDarkTheme;
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrProduct = productProvider.findProductById(productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    double totalPrice = usedPrice * int.parse(_qtyCtr.text);
    bool _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);
    final viewProvider = Provider.of<ViewProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool _isInWish =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);

    return WillPopScope(
      onWillPop: () async {
        // viewProvider.addProductToHistory(proId: productId);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                Flexible(
                    flex: 2,
                    child: SizedBox(
                      width: size.width,
                      height: size.height * 0.45,
                      child: FancyShimmerImage(
                        imageUrl: getCurrProduct.imageUrl,
                        boxFit: BoxFit.cover,
                        
                      ),
                    )),
                Flexible(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black
                            : Colors.cyan.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: TextWidget(
                                text: getCurrProduct.title,
                                color: color,
                                textSize: 24,
                                isTitle: true,
                              )),
                              HeartBtn(
                                proId: getCurrProduct.id,
                                isInWish: _isInWish,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 30, right: 30),
                          child: Row(
                            children: [
                              TextWidget(
                                text: '฿ ${usedPrice.toStringAsFixed(2)}/',
                                // getCurrProduct.salePrice.toString(),
                                isTitle: true,
                                color: Colors.green,
                              ),
                              TextWidget(
                                text: getCurrProduct.isPiece ? 'Piece' : 'Kg ',
                                isTitle: true,
                                textSize: 16,
                                color: Colors.green,
                              ),
                              Visibility(
                                visible: getCurrProduct.isOnSale ? true : false,
                                child: Text(
                                  getCurrProduct.price.toStringAsFixed(2),
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                              const Spacer(),
                              const ButtonWidget(
                                lable: 'Free Delivery',
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: SizedBox(
                            width: size.width * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                qtyCtr(() {
                                  setState(() {
                                    if (_qtyCtr.text == '1') {
                                      return;
                                    } else {
                                      _qtyCtr.text =
                                          (int.parse(_qtyCtr.text) - 1)
                                              .toString();
                                    }
                                  });
                                }, Icons.remove, Colors.red),
                                Flexible(
                                  flex: 2,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: _qtyCtr,
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
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
                                        value.isEmpty
                                            ? _qtyCtr.text == '1'
                                            : null;
                                      });
                                    },
                                  ),
                                ),
                                qtyCtr(() {
                                  setState(() {
                                    _qtyCtr.text = (int.parse(_qtyCtr.text) + 1)
                                        .toString();
                                  });
                                }, Icons.add, Colors.green),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black
                                  : Colors.cyan.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'Total',
                                    color: Colors.red,
                                    isTitle: true,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        TextWidget(
                                          text:
                                              '฿ ${totalPrice.toStringAsFixed(2)}',
                                          color:
                                              isDark ? Colors.cyan : Colors.red,
                                          isTitle: true,
                                        ),
                                        Text(
                                          ' /${_qtyCtr.text} Kg',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: color,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                              ButtonWidget(
                                lable: _isInCart ? 'In Cart' : 'Add to cart',
                                fontSize: 20,
                                color: _isInCart ? Colors.red : Colors.green,
                                press: () async {
                                  if (user == null) {
                                    errorDialog(
                                      "No user found, Please login first",
                                      context,
                                    );
                                    return;
                                  }
                                  _isInCart
                                      ? null
                                      : await addToCart(
                                          productId: getCurrProduct.id,
                                          qty: int.parse(_qtyCtr.text),
                                          context: context);
                                  await cartProvider.fetchCart();
                                  // cartProvider.addProductsToCart(
                                  //     proId: getCurrProduct.id,
                                  //     qty: int.parse(_qtyCtr.text));
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 30,
              left: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.grey,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget qtyCtr(
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
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
