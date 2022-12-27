// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:grocery_app/inner/categ_page.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget(
      {super.key,
      required this.catText,
      required this.imgPath,
      required this.colors});

  final String catText, imgPath;
  final Color colors;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final Color color = themeState.getDarkTheme ? Colors.white70 : Colors.black;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryPage.routeName,
            arguments: catText);
      },
      child: Container(
        decoration: BoxDecoration(
            color: colors.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.withOpacity(0.7))),
        child: Column(
          children: [
            Container(
              height: size.width * 0.22,
              width: size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imgPath), fit: BoxFit.fitWidth)),
            ),
            const SizedBox(
              height: 5,
            ),
            TextWidget(
              text: catText,
              color: color,
              isTitle: true,
            )
          ],
        ),
      ),
    );
  }
}
