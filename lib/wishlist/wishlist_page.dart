// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/service/global_methods.dart';
import 'package:grocery_app/widgets/empty_product.dart';
import 'package:grocery_app/wishlist/wishlist_widget.dart';
import 'package:provider/provider.dart';
import '../providers/dark_theme_provider.dart';
import '../../widgets/text_widget.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key, });
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final wislistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemList =
        wislistProvider.getWishlistItems.values.toList().reversed.toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.canPop(context) ? Navigator.pop(context) : null;
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.grey,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                await wislistProvider.clearOnlineWishlist();
                warningDialog('Empty your wishlist?', 'Are you sure?', () {
                  wislistProvider.clearLocalWishlist();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }, context, 'images/wishlist.json');
              },
              icon: Icon(
                IconlyBroken.delete,
                color: isDark ? Colors.white70 : Colors.grey,
              ))
        ],
        title: TextWidget(
          text: 'Wishlist (${wishlistItemList.length})',
          isTitle: true,
          color: isDark ? Colors.cyan : Colors.black,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.transparent,
      ),
      body: wishlistItemList.isEmpty
          ? const EmptyProduct(
              text:
                  'Your Wishlist is Empty\nexplore more and shortlist\nsome items',
              image: 'images/wish.json',
              label: 'Shop now',
            )
          : Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: MasonryGridView.count(
                itemCount: wishlistItemList.length,
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                      value: wishlistItemList[index],
                      child: const WishlistWidget(
                       
                      ));
                },
              ),
            ),
    );
  }
}
