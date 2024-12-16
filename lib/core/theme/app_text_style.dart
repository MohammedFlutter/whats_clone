import 'package:flutter/material.dart';

@immutable
class AppTextStyles {
  // Headline Styles
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headline2 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle subHeadline1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.7,
  );

  static TextStyle subHeadline2 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.7,
  );

  // Body Styles
  static TextStyle bodyLarge = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.7,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.7,
  );
  static TextStyle metadata1 = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
  static TextStyle metadata2 = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
  static TextStyle metadata3 = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.6,
  );
}
