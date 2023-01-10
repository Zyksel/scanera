import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/screen/scan/home_screen_controller.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/widget/config_dropdown.dart';
import 'package:scanera/widget/snack_bar_message.dart';

class EmptyScanScreen extends StatefulWidget {
  const EmptyScanScreen({Key? key}) : super(key: key);

  @override
  State<EmptyScanScreen> createState() => _EmptyScanScreenState();
}

class _EmptyScanScreenState extends State<EmptyScanScreen> {
  final SnackBarMessage _snackBarMessage = SnackBarMessage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Consumer<HomeController>(
            builder: (_, controller, ___) => Column(
              children: [
                Text(
                  AppLocalizations.of(context).homePickConfig,
                  style: AppTypography().black.headlineLarge,
                ),
                const SizedBox(
                  height: 40,
                ),
                ConfigDropdown(
                  configs: controller.state.configs,
                ),
                const SizedBox(
                  height: 50,
                ),
                IconButton(
                  onPressed: () {
                    if (controller.state.chosenConfig == null) {
                      _snackBarMessage.displaySnackBar(
                        context: context,
                        message: AppLocalizations.of(context)
                            .homeMandatoryPickedConfiguration,
                      );
                    } else {
                      controller.toggleScan();
                    }
                  },
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
      ),
    );
  }
}
