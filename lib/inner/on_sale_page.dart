// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/empty_product.dart';
import 'package:grocery_app/widgets/onsale_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../models/products_model.dart';
import '../providers/dark_theme_provider.dart';
import '../providers/products_provider.dart';

class OnSalePage extends StatelessWidget {
  const OnSalePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> productOnSale = productProvider.getProducts;
    return Scaffold(
      appBar: AppBar(
          title: TextWidget(
            text: 'Products on Sale',
            isTitle: true,
            color: isDark ? Colors.cyan : Colors.black,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: isDark ? Colors.black : Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: productOnSale.isEmpty
          ? const EmptyProduct(
              text: "No products on sale yet!,\n\nStay tued",
              image: 'cycle.json',
              label: 'Add now',
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              childAspectRatio: size.width / (size.height * 0.55),
              children: List.generate(
                productOnSale.length,
                (index) => ChangeNotifierProvider.value(
                    value: productOnSale[index], child: const OnSaleWidget()),
              ),
            ),
    );
  }
}
