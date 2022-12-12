import 'package:flutter/material.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/widget/config_dropdown.dart';

class EmptyScanScreen extends StatefulWidget {
  const EmptyScanScreen({Key? key}) : super(key: key);

  @override
  State<EmptyScanScreen> createState() => _EmptyScanScreenState();
}

class _EmptyScanScreenState extends State<EmptyScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context).homePickConfig,
                style: AppTypography().black.headlineLarge,
              ),
              const SizedBox(
                height: 40,
              ),
              const ConfigDropdown(),
              const SizedBox(
                height: 50,
              ),
              IconButton(
                onPressed: () => print('Start scan!'),
                icon: const Icon(
                  Icons.radar_outlined,
                  size: 140,
                  color: AppColors.kPrimaryBlue,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                AppLocalizations.of(context).homeStarScan,
                style: AppTypography().black.headlineLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
