import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/screen/scan/home_screen_controller.dart';
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
              Consumer<HomeController>(
                builder: (_, state, ___) => ConfigDropdown(
                  configs: state.state.configs,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              IconButton(
                onPressed: () =>
                    Provider.of<HomeController>(context, listen: false)
                        .toggleScan(),
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
