// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  TextInput({
    Key? key,
    this.keyboardType,
    required this.textInputAction,
    this.onEditing,
    this.validator,
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  final FocusNode? focusNode;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Function()? onEditing;
  final String? Function(String?)? validator;
  final String hintText;
  bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      onEditingComplete: onEditing,
      controller: controller,
      keyboardType: keyboardType,
      focusNode: focusNode,
      validator: validator,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        suffixIcon: suffixIcon,
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2)),
        errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2)),
      ),
    );
  }
}
