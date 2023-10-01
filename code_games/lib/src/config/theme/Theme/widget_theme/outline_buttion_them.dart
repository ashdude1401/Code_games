import 'package:flutter/material.dart';

class TOutlineButtonTheme {
  TOutlineButtonTheme._(); //To avoid creating instances

  /// ---------light Theme
  static final lightOutlineButtonThem = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      side: const BorderSide(color: Colors.deepPurple),
    ),
  );

  /// ---------Dark Theme
}
