import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_text_theme.dart';
import 'package:scanera/theme/text/font_family.dart';

@immutable
class AppTypography extends Equatable {
  const AppTypography._({
    required this.black,
    required this.white,
    required this.gray,
    required this.primary,
    required this.error,
  });

  AppTypography()
      : this._(
          black: _createBlackTextTheme(),
          white: _createWhiteTextTheme(),
          gray: _createGrayTextTheme(),
          primary: _createBlueTextTheme(),
          error: _createErrorTextTheme(),
        );

  final AppTextTheme black;
  final AppTextTheme white;
  final AppTextTheme gray;
  final AppTextTheme primary;
  final AppTextTheme error;

  Typography get materialTypography => Typography.material2018(
        // Platform independent
        platform: null,
        // Dark mode not supported for now
        white: black.materialTextTheme,
        black: black.materialTextTheme,
      );

  @override
  List<Object?> get props => [
        black,
        white,
        gray,
        primary,
        error,
      ];

  static AppTextTheme _createBlackTextTheme() =>
      _createTextTheme(AppColors.kOnSurfaceVariant);

  static AppTextTheme _createWhiteTextTheme() =>
      _createTextTheme(AppColors.kWhite);

  static AppTextTheme _createErrorTextTheme() =>
      _createTextTheme(AppColors.kError);

  static AppTextTheme _createGrayTextTheme() =>
      _createTextTheme(AppColors.kOnSurfaceVariant);

  static AppTextTheme _createBlueTextTheme() =>
      _createTextTheme(AppColors.kPrimaryBlue);

  /// Define app Text theme style
  static AppTextTheme _createTextTheme(Color color) => AppTextTheme(
        displayLarge: TextStyle(
          debugLabel: 'AppTextTheme displayLarge',
          color: color,
          fontSize: 52.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w700,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 52,
            lineHeight: 62,
          ),
        ),
        displayMedium: TextStyle(
          debugLabel: 'AppTextTheme displayMedium',
          color: color,
          fontSize: 36.0,
          fontFamily: kIcelandFamily,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 36,
            lineHeight: 32,
          ),
        ),
        displaySmall: TextStyle(
          debugLabel: 'AppTextTheme displaySmall',
          color: color,
          fontSize: 18.0,
          fontFamily: kIcelandFamily,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 32,
            lineHeight: 32,
          ),
        ),
        headlineLarge: TextStyle(
          debugLabel: 'AppTextTheme headlineLarge',
          color: color,
          fontSize: 32.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 32,
            lineHeight: 40,
          ),
        ),
        headlineMedium: TextStyle(
          debugLabel: 'AppTextTheme headlineMedium',
          color: color,
          fontSize: 28.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w700,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 28,
            lineHeight: 36,
          ),
        ),
        headlineSmall: TextStyle(
          debugLabel: 'AppTextTheme headlineSmall',
          color: color,
          fontSize: 24.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w700,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 24,
            lineHeight: 32,
          ),
        ),
        titleLarge: TextStyle(
          debugLabel: 'AppTextTheme titleLarge',
          color: color,
          fontSize: 28.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w700,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 28,
            lineHeight: 32,
          ),
        ),
        titleMedium: TextStyle(
          debugLabel: 'AppTextTheme titleMedium',
          color: color,
          fontSize: 16.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w700,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 16,
            lineHeight: 24,
          ),
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          debugLabel: 'AppTextTheme titleSmall',
          color: color,
          fontSize: 14.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w700,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 14,
            lineHeight: 20,
          ),
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          debugLabel: 'AppTextTheme bodyLarge',
          color: color,
          fontSize: 18.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
          height: calculateHeight(
            fontSize: 18,
            lineHeight: 32,
          ),
          letterSpacing: 0.15,
        ),
        bodyMedium: TextStyle(
          debugLabel: 'AppTextTheme bodyMedium',
          color: color,
          fontSize: 14.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 14,
            lineHeight: 20,
          ),
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
            debugLabel: 'AppTextTheme bodySmall',
            color: color,
            fontSize: 12.0,
            fontFamily: kHelveticaNeueFontFamily,
            fontWeight: FontWeight.w400,
            textBaseline: TextBaseline.alphabetic,
            height: calculateHeight(
              fontSize: 12,
              lineHeight: 16,
            ),
            letterSpacing: 0.4),
        labelLarge: TextStyle(
          debugLabel: 'AppTextTheme labelLarge',
          color: color,
          fontSize: 14.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w700,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 14,
            lineHeight: 20,
          ),
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          debugLabel: 'AppTextTheme labelMedium',
          color: color,
          fontSize: 12.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w700,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 12,
            lineHeight: 16,
          ),
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          debugLabel: 'AppTextTheme labelSmall',
          color: color,
          fontSize: 11.0,
          fontFamily: kHelveticaNeueFontFamily,
          fontWeight: FontWeight.w700,
          textBaseline: TextBaseline.alphabetic,
          height: calculateHeight(
            fontSize: 11,
            lineHeight: 16,
          ),
          letterSpacing: 0.1,
        ),
      );

  static double calculateHeight({
    required double fontSize,
    required double lineHeight,
  }) =>
      lineHeight / fontSize;
}
