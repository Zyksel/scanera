import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/util/alias.dart';

abstract class BaseColorScheme extends Equatable {
  const BaseColorScheme({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.error,
    required this.onError,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.surfaceVariant,
  }) : brightness = Brightness.light;

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color error;
  final Color onError;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color surfaceVariant;

  MaterialColorScheme get materialColorScheme => MaterialColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onError,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
      );

  @mustCallSuper
  @override
  List<Object?> get props => [
        brightness,
        primary,
        onPrimary,
        secondary,
        onSecondary,
        error,
        onError,
        background,
        onBackground,
        surface,
        onSurface,
        onSurfaceVariant,
        surfaceVariant,
      ];
}

@immutable
class AppColorScheme extends BaseColorScheme {
  const AppColorScheme()
      : super(
          onPrimary: Colors.black,
          secondary: AppColors.kSecondary,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: AppColors.kError,
          onBackground: Colors.black,
          onSurface: Colors.black12,
          primary: AppColors.kPrimaryBlue,
          background: Colors.white,
          surface: Colors.black,
          onSurfaceVariant: AppColors.kOnSurfaceVariant,
          surfaceVariant: AppColors.kSurfaceVariant,
        );

  @override
  List<Object?> get props => [...super.props];
}
