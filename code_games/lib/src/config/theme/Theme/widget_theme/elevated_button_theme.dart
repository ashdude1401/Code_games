import 'package:flutter/material.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();
  //To avoid creating instances

  /// ---------light Theme
  static final lightOutlineButtonThem = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        side: const BorderSide(color: Colors.deepPurple),
        elevation: 0),
  );

  /// ---------Dark Theme
}
