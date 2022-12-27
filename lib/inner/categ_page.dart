// ignore_for_file: dead_code, unused_local_variable

import 'package:flutter/material.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:grocery_app/widgets/empty_product.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/feed_items.dart';
import '../widgets/text_widget.dart';

class CategoryPage extends StatefulWidget {
  static const routeName = 'cat_page';
  const CategoryPage({
    super.key,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _searchTextCtr = TextEditingController();
  final _searchFocusNode = FocusNode();
  List<ProductModel> listProductSearch = [];

  @override
  void dispose() {
    _searchTextCtr.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> productBycat = productProvider.findByCategory(catName);

    bool isDark = themeState.getDarkTheme;
    bool isEmpty = false;
    return Scaffold(
      appBar: AppBar(
          title: TextWidget(
            text: catName,
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
      body: productBycat.isEmpty
          ? const EmptyProduct(
              text: 'No products belong\n\n to this category',
              image: 'images/cart.json',
              label: 'Add now',
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: TextFormField(
                        focusNode: _searchFocusNode,
                        controller: _searchTextCtr,
                        onChanged: (value) {
                          setState(() {
                            listProductSearch =
                                productProvider.searchQuery(value);
                          });
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          label: const Text('Search'),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black45,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(30)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(30)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                _searchFocusNode.unfocus();
                                _searchTextCtr.clear();
                              },
                              icon: Icon(
                                Icons.close,
                                color: _searchFocusNode.hasFocus
                                    ? Colors.red
                                    : Colors.transparent,
                              )),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 1)),
                        ),
                      ),
                    ),
                  ),
                  _searchTextCtr.text.isNotEmpty && listProductSearch.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Image.asset(
                                  'images/boxempty.png',
                                ),
                              ),
                              Text(
                                "No products found, \n\nplease try another keyword",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      isDark ? Colors.white : Colors.blueGrey,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          padding: EdgeInsets.zero,
                          childAspectRatio: size.width / (size.height * 0.67),
                          children: List.generate(
                            _searchTextCtr.text.isNotEmpty
                                ? listProductSearch.length
                                : productBycat.length,
                            (index) => ChangeNotifierProvider.value(
                              value: _searchTextCtr.text.isNotEmpty
                                  ? listProductSearch[index]
                                  : productBycat[index],
                              child: const FeedsWidget(),
                            ),
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
