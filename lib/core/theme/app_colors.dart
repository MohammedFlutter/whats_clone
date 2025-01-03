import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Color, Colors;

@immutable
class AppColors {
  const AppColors._();

  // Primary color palette
  static const Color primaryLight = Color(0xFF002DE3);
  static const Color primaryDark = Color(0xFF375FFF);

  static const Color secondaryLight = Color(0xFF00C6FF); // Bright Cyan
  static const Color secondaryDark = Color(0xFF4A90E2); // Soft Blue




  // Background and surface colors
  static const Color surfaceContainer = Color(0xFFADB5BD);
  static const Color surfaceContainerDark = Color(0xFF152033);
  static const Color surface = Colors.white;
  static const Color offWhite = Color(0xFFF7F7FC);

  static const Color surfaceDark = Color(0xFF0F1828);
  static const Color divider = Color(0xFFEDEDED);
  static const Color dividerDark = Color(0xFF152033);

  // Text colors
  static const Color textPrimary = Color(0xFF0F1828);
  static const Color textBody = Color(0xFF1B2B48);
  static const Color textWeak = Color(0xFFA4A4A4);

  static const Color disable = Color(0xFFADB5BD);
  static const Color textPrimaryDark = Color(0xFFF7F7FC);
  static const Color textOnPrimary = offWhite;
  static const Color textOnPrimaryDark = surfaceDark;

  // Other utility colors
  static const Color success = Color(0xFF2CC069);
  static const Color error = Color(0xFFE94242);
  static const Color badgeBackground = Color(0xFFD2D5F9);

  static const Color indicatorColor = Color(0xFF002DE3);

}
