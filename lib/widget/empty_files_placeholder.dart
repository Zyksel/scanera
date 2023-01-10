import 'package:flutter/material.dart';
import 'package:scanera/theme/color/app_colors.dart';

class EmptyFilesPlaceholder extends StatelessWidget {
  const EmptyFilesPlaceholder({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/scanera_logo_icon.png',
          color: AppColors.kGluonGrey,
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.kGluonGrey,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
