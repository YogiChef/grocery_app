// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/inner/product_detail.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../models/view_model.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../service/global_methods.dart';

class ViewedWidget extends StatefulWidget {
  const ViewedWidget({super.key});

  @override
  State<ViewedWidget> createState() => _ViewedWidgetState();
}

class _ViewedWidgetState extends State<ViewedWidget> {
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

    final viewProvider = Provider.of<ProductProvider>(context);
    final viewModel = Provider.of<ViewModel>(context);
    final getCurrProduct = viewProvider.findProductById(viewModel.proId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: getCurrProduct.id);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FancyShimmerImage(
            width: size.width * 0.25,
            height: size.width * 0.2,
            imageUrl: getCurrProduct.imageUrl,
            boxFit: BoxFit.cover,
          ),
          Column(
            children: [
              Builder(builder: (context) {
                return TextWidget(
                  text: '฿ ${usedPrice.toStringAsFixed(2)}',
                  color: isDark ? Colors.white : Colors.black,
                  textSize: 18,
                );
              }),
              TextWidget(
                text: getCurrProduct.title,
                color: isDark ? Colors.yellow : Colors.black,
                textSize: 20,
              ),
            ],
          ),
          const Spacer(),
          _qtyCtr(
            _isInCart
                ? null
                : () async {
                    await addToCart(
                        productId: getCurrProduct.id, qty: 1, context: context);
                    await cartProvider.fetchCart();
                    // cartProvider.addProductsToCart(
                    //     proId: getCurrProduct.id, qty: 1);
                  },
            _isInCart ? Icons.check : Icons.add,
            _isInCart ? Colors.green : Colors.grey,
          )
        ],
      ),
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
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
