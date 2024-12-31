import 'package:flutter/material.dart';
import 'package:whats_clone/core/theme/app_colors.dart';
import 'package:whats_clone/core/theme/app_text_style.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTextStyles.subHeadline1.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        surface: AppColors.surface,
        surfaceContainerLow: AppColors.surfaceContainer,
        surfaceContainerHighest: AppColors.offWhite,
        surfaceContainerHigh: AppColors.offWhite,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        headlineLarge:
            AppTextStyles.headline1.copyWith(color: AppColors.textPrimary),
        headlineMedium:
            AppTextStyles.headline2.copyWith(color: AppColors.textPrimary),
        bodyLarge:
            AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
        bodyMedium:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      ),
      // dividerColor: AppColors.divider,

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.disable),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.textOnPrimary,
          textStyle:
              AppTextStyles.subHeadline2.copyWith(color: AppColors.offWhite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // Dark theme can be added similarly
  static ThemeData get darkTheme {
    // Implement dark theme variant
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.surfaceDark,
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTextStyles.subHeadline1.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        surface: AppColors.surfaceDark,
        surfaceContainerLow: AppColors.surfaceContainerDark,
        surfaceContainerHighest: AppColors.surfaceContainerDark,
        surfaceContainerHigh: AppColors.surfaceContainerDark,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        headlineLarge:
            AppTextStyles.headline1.copyWith(color: AppColors.textPrimaryDark),
        headlineMedium:
            AppTextStyles.headline2.copyWith(color: AppColors.textPrimaryDark),
        bodyLarge:
            AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
      ),
      // dividerColor: AppColors.divider,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        filled: true,
        // fillColor: Colors.white,
        hintStyle:
            AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.textOnPrimary,
          textStyle: AppTextStyles.subHeadline2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
