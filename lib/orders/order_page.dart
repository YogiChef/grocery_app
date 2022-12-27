// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/orders/order_widget.dart';
import 'package:grocery_app/providers/order_provider.dart';
import 'package:grocery_app/widgets/empty_product.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../../service/global_methods.dart';
import '../../widgets/text_widget.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final orderProvider = Provider.of<OrdersProvider>(context);
    final ordersList = orderProvider.getOrder;

    bool isDark = themeState.getDarkTheme;
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
                  warningDialog('Empty your orders?', 'Are you sure?', () {
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
            text: 'My Order (${ordersList.length})',
            isTitle: true,
            color: isDark ? Colors.cyan : Colors.black,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: isDark ? Colors.black : Colors.transparent,
        ),
        body: FutureBuilder(
          future: orderProvider.fatchOrders(),
          builder: (context, snapshot) {
            return ordersList.isEmpty
                ? const EmptyProduct(
                    text:
                        'You didnt place any order yet \n order something and make me happy',
                    image: 'images/box.json',
                    label: 'Shop now')
                : ListView.separated(
                    itemCount: ordersList.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: ordersList[index], child: const OrderWidget());
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: isDark ? Colors.cyan : Colors.black,
                        thickness: 1.5,
                      );
                    },
                  );
          },
        ));
  }
}
