import 'package:flutter/material.dart';

import 'colors.dart';

class MyStyles {
  static TextStyle title = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 56, 56, 56));

  static TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: MyColors.smallText,
  );
  static TextStyle subtitleItalic = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: MyColors.smallText,
      fontStyle: FontStyle.italic);

  static TextStyle text = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: MyColors.smallText);

  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: MyColors.smallText,
      ),
      borderRadius: BorderRadius.circular(5));

  static TextStyle tipText = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: MyColors.smallText);
}
