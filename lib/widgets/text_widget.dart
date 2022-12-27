// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  TextWidget({
    super.key,
    required this.text,
    this.color = Colors.black54,
    this.textSize = 20,
    this.isTitle = false,
    this.fontWeight = FontWeight.w600,
    this.maxLines = 2,
  });
  final String text;
  final Color color;
  final double textSize;
  final FontWeight fontWeight;
  bool isTitle;
  int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: color,
        fontSize: textSize,
        fontWeight: isTitle ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
