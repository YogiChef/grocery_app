// ignore_for_file: equal_keys_in_map, unused_local_variable

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/pages/categories.dart';
import 'package:grocery_app/pages/home_page.dart';
import 'package:grocery_app/pages/user.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../providers/cart_provider.dart';
import 'cart/cart_page.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomePage(), 'title': 'Home'},
    {'page': const CategoriesPage(), 'title': 'Categories'},
    {'page': const CartPage(), 'title': 'Cart'},
    {'page': const UserPage(), 'title': 'User'},
  ];

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final cartProvider = Provider.of<CartProvider>(context);

    final cartItemList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor:
      //       isDark ? Theme.of(context).canvasColor : Colors.grey.shade100,
      //   title: Text(
      //     _pages[_selectedIndex]['title'],
      //     style: TextStyle(
      //       color: isDark ? Theme.of(context).cardColor : Colors.black87,
      //     ),
      //   ),
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
          selectedItemColor: isDark ? Theme.of(context).cardColor : Colors.cyan,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedItemColor: Colors.grey,
          onTap: _selectedPage,
          currentIndex: _selectedIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(_selectedIndex == 1
                    ? IconlyBold.category
                    : IconlyLight.category),
                label: 'Categories'),
            BottomNavigationBarItem(
                icon: Consumer<CartProvider>(builder: (_, myCart, child) {
                  return Badge(
                    toAnimate: true,
                    shape: BadgeShape.circle,
                    badgeColor: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    position: const BadgePosition(top: -10, end: -10),
                    badgeContent: Text(
                        // cartProvider.getCartItems.length.toString(),
                        myCart.getCartItems.length.toString(),
                        // cartItemList.length.toString(),
                        style: const TextStyle(color: Colors.white)),
                    child: Icon(
                        _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),
                  );
                }),
                label: 'Cart'),
            BottomNavigationBarItem(
                icon: Icon(
                    _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
                label: 'User'),
          ]),
    );
  }
}
