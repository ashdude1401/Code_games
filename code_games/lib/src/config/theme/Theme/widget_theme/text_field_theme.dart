import 'package:flutter/material.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
    hintStyle: const TextStyle(color: Colors.white),
    suffixIconColor: Colors.deepPurple,
    border: const OutlineInputBorder(
      borderSide: BorderSide(width: 4, color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    prefixIconColor: Colors.deepPurple,
    floatingLabelStyle: const TextStyle(color: Colors.deepPurple),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.deepPurple),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  /// ---------Dark Theme
}
