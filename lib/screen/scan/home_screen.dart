import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/screen/scan/all_mode/all_mode_screen.dart';
import 'package:scanera/screen/scan/bluetooth_mode/bluetooth_mode_screen.dart';
import 'package:scanera/screen/scan/empty_scan.dart';
import 'package:scanera/screen/scan/sensors_mode/sensors_mode_screen.dart';
import 'package:scanera/screen/scan/wifi_mode/wifi_mode_screen.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/widget/options_bottom_sheet.dart';
import 'package:scanera/widget/page_app_bar.dart';
import 'package:scanera/widget/snackBar_message.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isScanning = false;
  late Widget body;
  late Timer timer;
  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();
  final _snackBar = SnackBarMessage();

  @override
  void initState() {
    body = getBody();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: getAppBarTitle(index: _selectedIndex),
        leftIcon: !_isScanning ? Icons.play_arrow : Icons.stop_circle_outlined,
        rightIcon: !_isScanning ? Icons.more_vert : null,
        onLeftTap: () {
          /// TODO: fix controlling from appBar
          // !_isScanning ? startScan(interval: kWifiScanInterval) : stopScan();
          toggleScan();
        },
        onRightIconTap: openOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        unselectedItemColor: AppColors.kPrimary90,
        unselectedFontSize: 11,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedFontSize: 11,
        selectedItemColor: AppColors.kPrimaryBlue,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.perm_scan_wifi),
            label: AppLocalizations.of(context).navBarAllScan,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.edgesensor_high),
            label: AppLocalizations.of(context).navBarSensors,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bluetooth),
            label: AppLocalizations.of(context).navBarBluetooth,
          ),
          if (Platform.isAndroid)
            BottomNavigationBarItem(
              icon: const Icon(Icons.wifi),
              label: AppLocalizations.of(context).navBarWifi,
            ),
        ],
        onTap: (index) => setState(() {
          if (!_isScanning) {
            _selectedIndex = index;
            body = getBody(index: index);
          } else {
            _snackBar.displaySnackBar(
              context: context,
              message: AppLocalizations.of(context).errorOngoingScan,
            );
          }
        }),
      ),
      body: body,
      //       Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       body,
      //
      //       /// TODO: HOW TO PLACE DIVIDER ON TOP OF NAVBAR?
      //       const Spacer(),
      //       const Divider(
      //         thickness: 1,
      //         color: AppColors.kSurfaceVariant,
      //       ),
      //     ],
      //   ),
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
        onOptionTap: (int index) => GoRouter.of(context).pushNamed('logs'),
        options: [
          AppLocalizations.of(context).homeBottomSheetOptionFirst,
          AppLocalizations.of(context).homeBottomSheetOptionSecond,
          AppLocalizations.of(context).homeBottomSheetOptionThird,
        ],
      ),
    );
  }

  Widget getBody({int index = 0}) {
    if (!_isScanning) return const EmptyScanScreen();

    switch (index) {
      case 0:
        return const AllModeScreen();
      case 1:
        return const SensorsModeScreen();
      case 2:
        return const BluetoothModeScreen();
      case 3:
        return WifiModeScreen();
      default:
        return Container();
    }
  }

  String getAppBarTitle({int index = 0}) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context).appBarAllScan;
      case 1:
        return AppLocalizations.of(context).appBarSensors;
      case 2:
        return AppLocalizations.of(context).appBarBluetooth;
      case 3:
        return AppLocalizations.of(context).appBarWifi;
      default:
        return "";
    }
  }

  void toggleScan() {
    setState(() {
      _isScanning = !_isScanning;
      body = getBody(index: _selectedIndex);
    });
  }
}
