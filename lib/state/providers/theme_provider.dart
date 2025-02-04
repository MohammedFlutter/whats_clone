import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(themeBox: Hive.box<bool>(HiveBoxName.themeMode));
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final Box<bool> themeBox;
  static const _keySystem = 'is_system';
  static const _keyTheme = 'theme_mode';

  ThemeNotifier({required this.themeBox}) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final isSystem = themeBox.get(_keySystem, defaultValue: true);
    final theme = themeBox.get(_keyTheme, defaultValue: true); // true -> Light

    if (isSystem!) {
      state = ThemeMode.system;
    } else {
      state = theme! ? ThemeMode.light : ThemeMode.dark;
    }
  }

  Future<void> toggleSystemMode() async {
    final isSystem = state == ThemeMode.system;
    await themeBox.put(_keySystem, !isSystem);

    if (isSystem) {
      // Switch to stored non-system theme
      final theme = themeBox.get(_keyTheme, defaultValue: true);
      state = theme! ? ThemeMode.light : ThemeMode.dark;
    } else {
      // Switch to system mode
      state = ThemeMode.system;
    }
  }

  Future<void> toggleLightDarkMode() async {
    if (state != ThemeMode.system) {
      final isLight = state == ThemeMode.light;
      await themeBox.put(_keyTheme, !isLight);
      state = isLight ? ThemeMode.dark : ThemeMode.light;
    }
  }
}
