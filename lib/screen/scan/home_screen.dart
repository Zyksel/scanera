import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/screen/scan/home_screen_controller.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/widget/dialog/info_dialog.dart';
import 'package:scanera/widget/options_bottom_sheet.dart';
import 'package:scanera/widget/page_app_bar.dart';
import 'package:scanera/widget/snack_bar_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Widget body;
  final SnackBarMessage _snackBarMessage = SnackBarMessage();

  @override
  void initState() {
    grantPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ChangeNotifierProvider(
        create: (_) => HomeController(),
        builder: (context, _) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(74),
            child: Consumer<HomeController>(
              builder: (_, controller, ___) => PageAppBar(
                title: controller.getAppBarTitle(context),
                leftIcon: !controller.state.isScanning
                    ? Icons.play_arrow
                    : Icons.stop_circle_outlined,
                rightIcon:
                    !controller.state.isScanning ? Icons.more_vert : null,
                onLeftTap: () async {
                  if (controller.state.isScanning) {
                    final shouldEnd = await _showEndScanDialog();
                    controller.saveResult(shouldEnd);
                    if (shouldEnd != null) controller.toggleScan();
                  } else {
                    if (controller.state.chosenConfig == null) {
                      _snackBarMessage.displaySnackBar(
                        context: context,
                        message: AppLocalizations.of(context)
                            .homeMandatoryPickedConfiguration,
                      );
                    } else {
                      controller.toggleScan();
                    }
                  }
                },
                onRightIconTap: openOptions,
              ),
            ),
          ),
          bottomNavigationBar: Consumer<HomeController>(
            builder: (_, state, ___) => BottomNavigationBar(
              currentIndex: state.state.selectedIndex,
              unselectedItemColor: AppColors.kPrimary90,
              unselectedFontSize: 11,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold),
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
              onTap: (index) {
                if (!state.state.isScanning) {
                  state.changeIndex(index);
                } else {
                  _snackBarMessage.displaySnackBar(
                    context: context,
                    message: AppLocalizations.of(context).errorOngoingScan,
                  );
                }
              },
            ),
          ),
          body: Provider.of<HomeController>(context, listen: true).getBody(),
        ),
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
        onOptionTap: (int index) {
          switch (index) {
            case 0:
              return GoRouter.of(context).pushNamed('config');
            case 1:
              return GoRouter.of(context).pushNamed('logs');
            case 2:
              return GoRouter.of(context).pushNamed('settings');
          }
        },
        options: [
          AppLocalizations.of(context).homeBottomSheetOptionFirst,
          AppLocalizations.of(context).homeBottomSheetOptionSecond,
          AppLocalizations.of(context).homeBottomSheetOptionThird,
        ],
      ),
    );
  }

  Future<bool?> _showEndScanDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => InfoDialog(
        label: AppLocalizations.of(context).homeDialogLabel,
        leftOptionTitle: AppLocalizations.of(context).homeDialogOptionFirst,
        rightOptionTitle: AppLocalizations.of(context).homeDialogOptionSecond,
      ),
    );
    return result;
  }

  void grantPermissions() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await [
        Permission.location,
        Permission.bluetoothScan,
      ].request();
    });
  }
}
