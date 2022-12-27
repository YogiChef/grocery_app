// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/categories_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Color> gridColor = [
    Colors.deepOrange,
    Colors.grey,
    Colors.green,
    Colors.brown,
    Colors.cyan,
    Colors.purple,
  ];
  List<Map<String, dynamic>> catInfo = [
    {'imagPath': 'images/fruits.png', 'catText': 'Fruits'},
    {'imagPath': 'images/vegetables.png', 'catText': 'Vegetable'},
    {'imagPath': 'images/herbs.png', 'catText': 'Herbs'},
    {'imagPath': 'images/nuts.png', 'catText': 'Nuts'},
    {'imagPath': 'images/spices.png', 'catText': 'Spices'},
    {'imagPath': 'images/grains.png', 'catText': 'Grains'}
  ];

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final Color color = themeState.getDarkTheme ? Colors.white70 : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: 'Categories',
          color: color,
          isTitle: true,
        ),
        // centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 240 / 250,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(
              6,
              (index) => CategoriesWidget(
                    imgPath: catInfo[index]['imagPath'],
                    catText: catInfo[index]['catText'],
                    colors: gridColor[index],
                  )),
        ),
      ),
    );
  }
}
