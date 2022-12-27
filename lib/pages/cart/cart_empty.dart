import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/button_widget.dart';

class CartEmpty extends StatelessWidget {
  const CartEmpty({
    Key? key,
    required this.isDark,
  }) : super(key: key);

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Lottie.asset(
              'images/box.json',
            ),
          ),
          Text(
            "No products in your cart yet!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.blueGrey,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          ButtonWidget(
            lable: 'Shop now',
            horizontal: 20,
            fontSize: 20,
            press: () {
              Navigator.pushNamed(context, 'feed_page');
            },
          )
        ],
      ),
    );
  }
}
