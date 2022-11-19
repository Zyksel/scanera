import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:scanera/theme/app_theme_data.dart';
import 'package:scanera/theme/color/app_color_scheme.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/util/alias.dart';

@singleton
class ThemeFactory {
  ThemeFactory();

  AppThemeData create() {
    return _createNormalStyle(false);
  }

  AppThemeData _createNormalStyle(
    bool isDark,
  ) {
    final brightness = isDark ? Brightness.dark : Brightness.light;

    final colorScheme = _createDefaultColorScheme(brightness);

    final appTypography = AppTypography();

    final textTheme = appTypography.black;

    final materialThemeData = MaterialThemeData(
      primaryColor: colorScheme.primary,
      backgroundColor: colorScheme.background,
      errorColor: colorScheme.error,
      colorScheme: colorScheme.materialColorScheme,
      brightness: colorScheme.brightness,
      typography: appTypography.materialTypography,
      useMaterial3: true,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );

    return AppThemeData(
      colorScheme: colorScheme,
      typography: appTypography,
      textTheme: textTheme,
      materialThemeData: materialThemeData,
    );
  }

  AppColorScheme _createDefaultColorScheme(Brightness brightness) =>
      const AppColorScheme();
}
