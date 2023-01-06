import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/model/config_storage_model.dart';
import 'package:scanera/screen/scan/all_mode/all_mode_screen.dart';
import 'package:scanera/screen/scan/bluetooth_mode/bluetooth_mode_screen.dart';
import 'package:scanera/screen/scan/empty_scan.dart';
import 'package:scanera/screen/scan/sensors_mode/sensors_mode_screen.dart';
import 'package:scanera/screen/scan/wifi_mode/wifi_mode_screen.dart';

class HomeState {
  bool isScanning = false;
  int selectedIndex = 0;
  String? chosenConfig;
  List<ConfigStorageModel> configs = [];
  List<List<int>> coordinates = [];
}

class HomeController extends ChangeNotifier {
  HomeState state = HomeState();
  final FileManager _fileManager = FileManager();
  final _logger = Logger('HomeController');

  HomeController() {
    fetchConfigs();
  }

  void refresh() {
    notifyListeners();
  }

  void chooseConfig(String config) {
    state.chosenConfig = config;
    notifyListeners();
  }

  void changeIndex(int index) {
    state.selectedIndex = index;
    notifyListeners();
  }

  void toggleScan() {
    state.isScanning = !state.isScanning;
    if (state.chosenConfig == null) {
      _logger.warning('Brak configu');
    } else {
      notifyListeners();
    }
  }

  Widget getBody() {
    if (!state.isScanning) return const EmptyScanScreen();

    switch (state.selectedIndex) {
      case 0:
        return const AllModeScreen();
      case 1:
        return const SensorsModeScreen();
      case 2:
        return const BluetoothModeScreen();
      case 3:
        return const WifiModeScreen();
      default:
        return Container();
    }
  }

  String getAppBarTitle(BuildContext context) {
    switch (state.selectedIndex) {
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

  Future<void> fetchConfigs() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      state.configs = [];
      final configs = await _fileManager.getConfigFiles();
      for (final file in configs) {
        final configName = path.basename(file.path).split('_');
        state.configs.add(
          ConfigStorageModel(
            name: configName[1],
            path: path.basename(file.path),
          ),
        );
      }
      notifyListeners();
    });
  }

  Future<void> getScanConfig(ConfigStorageModel model) async {
    state.coordinates.clear();
    final configString = await _fileManager.readConfigContent(model.path);

    final coords = jsonDecode(configString);

    for (final data in coords["coords"]) {
      state.coordinates.add([
        int.parse(data["x"]),
        int.parse(data["y"]),
      ]);
    }
    notifyListeners();
  }
}
