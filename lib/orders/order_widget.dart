import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/inner/product_detail.dart';
import 'package:grocery_app/models/orders_model.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final _qtyCtror = TextEditingController();
  late String orederDate;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var date = ordersModel.orderDate.toDate();
    orederDate =
        '${date.hour}:${date.minute}/${date.day}-${date.month}-${date.year}';
    super.didChangeDependencies();
  }

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
    final ordersModel = Provider.of<OrderModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProductById(ordersModel.proId);
    return ListTile(
      subtitle:
          Text('Paid: ฿ ${double.parse(ordersModel.price).toStringAsFixed(2)}'),
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: ordersModel.proId);
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: ordersModel.imagUrl,
        boxFit: BoxFit.cover,
      ),
      title: TextWidget(
        text: '${getCurrProduct.title}  X ${ordersModel.qty}',
        color: isDark ? Colors.yellow : Colors.black,
        textSize: 18,
      ),
      trailing: TextWidget(
        text: orederDate,
        color: isDark ? Colors.white : Colors.black,
        textSize: 18,
      ),
    );
  }
}
