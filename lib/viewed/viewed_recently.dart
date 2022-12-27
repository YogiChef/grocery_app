// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/viewed/viewed_widget.dart';
import 'package:grocery_app/widgets/empty_product.dart';
import 'package:provider/provider.dart';
import '../providers/dark_theme_provider.dart';
import '../../service/global_methods.dart';
import '../../widgets/text_widget.dart';
import '../providers/view_provider.dart';

class ViewedRecently extends StatelessWidget {
  const ViewedRecently({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final viewProvider = Provider.of<ViewProvider>(context);
    final viewItemList =
        viewProvider.getViewListItems.values.toList().reversed.toList();
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
              onPressed: () {
                warningDialog('Empty your history?', 'Are you sure?', () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }, context, 'images/delete.json');
              },
              icon: Icon(
                IconlyBroken.delete,
                color: isDark ? Colors.white70 : Colors.grey,
              ))
        ],
        title: TextWidget(
          text: 'History',
          isTitle: true,
          color: isDark ? Colors.cyan : Colors.black,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.transparent,
      ),
      body: viewItemList.isEmpty
          ? const EmptyProduct(
              text:
                  'Your history is empty \nNo products has been\n wiewed yet!',
              image: 'images/history.json',
              label: 'Shop now')
          : ListView.separated(
              itemCount: viewItemList.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: viewItemList[index], child: const ViewedWidget());
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: isDark ? Colors.cyan : Colors.black,
                  thickness: 1.5,
                );
              },
            ),
    );
  }
}
