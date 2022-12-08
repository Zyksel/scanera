import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/widget/config_dropdown.dart';
import 'package:scanera/widget/dialog/configuration_dialog.dart';
import 'package:scanera/widget/dialog/info_dialog.dart';
import 'package:scanera/widget/options_bottom_sheet.dart';
import 'package:scanera/widget/page_app_bar.dart';
import 'package:scanera/widget/scan_controller.dart';
import 'package:scanera/widget/snackBar_message.dart';
import 'package:scanera/widget/tile/sensor_tile.dart';
import 'package:scanera/widget/tile/signal_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _snackBar = SnackBarMessage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PageAppBar(
        title: "Scanera",
        leftIcon: Icons.arrow_back,
        rightIcon: Icons.more_vert,
        onRightIconTap: () => openOptions(),
        onLeftTap: () => GoRouter.of(context).pop(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        unselectedItemColor: AppColors.kPrimary90,
        unselectedFontSize: 11,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedFontSize: 11,
        selectedItemColor: AppColors.kPrimaryBlue,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.bluetooth),
            label: AppLocalizations.of(context).navBarBluetooth,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.wifi),
            label: AppLocalizations.of(context).navBarWifi,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.edgesensor_high),
            label: AppLocalizations.of(context).navBarSensors,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.perm_scan_wifi),
            label: AppLocalizations.of(context).navBarAllScan,
          ),
        ],
        onTap: (index) => _showConfigDialog(),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                ScanController(
                  onPressedFirst: () => _showSettingsDialog(),
                  onPressedSecond: () => _snackBar.displaySnackBar(
                    context: context,
                    message: AppLocalizations.of(context).homeSnackBarInfo,
                  ),
                  coordinates: const [
                    [5, 10]
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const SignalTile(
                  SSID: "Beacon (1)",
                  BSSID: "0a766574-ee7a-4d43-b717-7f51ccad3ff6",
                  level: -50,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SensorTile(
                      label: "Magnetometer",
                      data: ["-50", "-50", "-50"],
                    ),
                    SensorTile(
                      label: "Accelerometer",
                      data: ["-50", "-50", "-50"],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const ConfigDropdown(
                  data: ["Config 1", "Config 2", "Config 3"],
                )
              ],
            ),
          ),
          const Spacer(),
          const Divider(
            thickness: 1,
            color: AppColors.kSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Future<void> openOptions() async {
    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (BuildContext context) => OptionsBottomSheet(
        onOptionTap: (int index) => print(index),
        options: [
          AppLocalizations.of(context).homeBottomSheetOptionFirst,
          AppLocalizations.of(context).homeBottomSheetOptionSecond,
          AppLocalizations.of(context).homeBottomSheetOptionThird,
        ],
      ),
    );
  }

  Future<bool?> _showSettingsDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => InfoDialog(
        label: AppLocalizations.of(context).settingsDialogLabel,
        content: AppLocalizations.of(context).settingsDialogContent,
        rightOptionTitle:
            AppLocalizations.of(context).settingsDialogOptionSecond,
        leftOptionTitle: AppLocalizations.of(context).settingsDialogOptionFirst,
      ),
    );
    return result;
  }

  Future<void> _showConfigDialog() async {
    final result = await showDialog<void>(
      context: context,
      builder: (_) => const ConfigDialog(),
    );
    return result;
  }
}
