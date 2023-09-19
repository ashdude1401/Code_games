import 'package:flutter/material.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
    suffixIconColor: Colors.deepPurple,
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.deepPurple),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    prefixIconColor: Colors.deepPurple,
    floatingLabelStyle: TextStyle(color: Colors.deepPurple),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.deepPurple),
    ),
  );

  /// ---------Dark Theme
}
