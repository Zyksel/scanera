import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scanera/theme/color/app_color_scheme.dart';
import 'package:scanera/theme/text/app_text_theme.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/util/alias.dart';

@immutable
class AppThemeData extends Equatable {
  const AppThemeData({
    required this.colorScheme,
    required this.typography,
    required this.textTheme,
    required this.materialThemeData,
  });

  final AppColorScheme colorScheme;
  final AppTypography typography;
  final AppTextTheme textTheme;
  final MaterialThemeData materialThemeData;

  @override
  List<Object?> get props => [
        colorScheme,
        typography,
        textTheme,
        materialThemeData,
      ];
}
