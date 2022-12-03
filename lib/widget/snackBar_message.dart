import 'package:flutter/material.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';

class SnackBarMessage {
  void displaySnackBar({
    required BuildContext context,
    required String message,
    bool warningStyle = false,
  }) {
    final snackBar = SnackBar(
      backgroundColor: warningStyle ? AppColors.kError : AppColors.kPrimary95,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      duration: const Duration(
        seconds: 10,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      content: Text(
        message,
        style: warningStyle
            ? AppTypography().white.bodyLarge
            : AppTypography().black.bodyLarge,
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
