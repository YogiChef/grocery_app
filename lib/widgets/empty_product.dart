import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'button_widget.dart';

class EmptyProduct extends StatelessWidget {
  const EmptyProduct({
    super.key,
    required this.text,
    required this.image,
    required this.label,
    this.isDark = false,
  });
  final String label;
  final String text;
  final String image;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Lottie.asset(
                image,
              ),
            ),
            Text(
              text,
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
              lable: label,
              horizontal: 20,
              fontSize: 20,
              press: () {
                Navigator.pushNamed(context, 'feed_page');
              },
            )
          ],
        ),
      ),
    );
  }
}
