// ignore_for_file: unused_local_variable

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/providers/dark_theme_provider.dart';
import 'package:grocery_app/widgets/feed_items.dart';
import 'package:grocery_app/widgets/onsale_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../models/products_model.dart';
import '../providers/products_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _offerImg = [
    'images/fruit.jpg',
    'images/grocery.jpg',
    'images/shop.webp',
    'images/cartnew.jpg',
    'images/vegs.jpg',
    'images/sop.webp',
    'images/carttwo.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> allProducts = productProvider.getProducts;
    List<ProductModel> productOnSale = productProvider.getOnSaleProducts;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.33,
            child: Center(
                child: Swiper(
              itemCount: _offerImg.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  _offerImg[index],
                  fit: BoxFit.fill,
                );
              },
              autoplay: true,
              pagination: const SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.white,
                    activeColor: Colors.deepOrange,
                  )),
            )),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 10),
              child: TextButton(
                child: TextWidget(
                  text: 'View all',
                  color: Colors.cyan,
                  isTitle: true,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'on_sale');
                },
              ),
            ),
          ),
          Row(
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Row(
                  children: [
                    TextWidget(
                      text: 'On sale'.toUpperCase(),
                      color: Colors.red,
                      textSize: 22,
                      isTitle: true,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      IconlyLight.discount,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: size.height * 0.29,
                  child: ListView.builder(
                      itemCount: productOnSale.length,
                      // < 10 ? productOnSale.length : 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: productOnSale[index],
                            child: const OnSaleWidget());
                      }),
                ),
              ),
            ],
          ),
          ListTile(
            leading: TextWidget(
              text: 'Our products',
              color: Colors.black,
              textSize: 16,
              isTitle: true,
            ),
            trailing: TextWidget(
              text: 'Browse all',
              color: Colors.cyan,
              textSize: 16,
              isTitle: true,
            ),
            onTap: () {
              Navigator.pushNamed(context, 'feed_page');
            },
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            padding: EdgeInsets.zero,
            childAspectRatio: size.width / (size.height * 0.67),
            children: List.generate(
              allProducts.length,
              //< 4 ? allProducts.length : 4,
              (index) => ChangeNotifierProvider.value(
                value: allProducts[index],
                child: const FeedsWidget(),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
