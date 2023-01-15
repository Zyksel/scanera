import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/manager/scan_all_manager.dart';
import 'package:scanera/manager/scan_bluetooth_manager.dart';
import 'package:scanera/manager/scan_sensors_manager.dart';
import 'package:scanera/manager/scan_wifi_manager.dart';
import 'package:scanera/model/config_storage_model.dart';
import 'package:scanera/screen/scan/all_mode/all_mode_screen.dart';
import 'package:scanera/screen/scan/bluetooth_mode/bluetooth_mode_screen.dart';
import 'package:scanera/screen/scan/empty_scan.dart';
import 'package:scanera/screen/scan/sensors_mode/sensors_mode_screen.dart';
import 'package:scanera/screen/scan/wifi_mode/wifi_mode_screen.dart';

class HomeState {
  bool isScanning = false;
  bool shouldSaveScanResults = false;
  int selectedIndex = 0;
  String? chosenConfig;
  List<ConfigStorageModel> configs = [];
  List<List<int>> coordinates = [];
}

class HomeController extends ChangeNotifier {
  HomeState state = HomeState();
  final FileManager _fileManager = FileManager();
  final _logger = Logger('HomeController');
  final ScanWifiManager scanWifiController = ScanWifiManager(null);
  final ScanSensorsManager scanSensorsController = ScanSensorsManager(null);
  final ScanBluetoothManager scanBluetoothController =
      ScanBluetoothManager(null);
  final ScanAllManager scanAllManager = ScanAllManager(isIOS: Platform.isIOS);

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

  void saveResult(bool? result) {
    if (result == null) {
      return;
    }

    switch (state.selectedIndex) {
      case 0:
        scanAllManager.stopAllScan();
        if (result) scanAllManager.saveSensorsScan();
        scanAllManager.resetData();
        break;
      case 1:
        scanSensorsController.stopScan();
        if (result) scanSensorsController.saveSensorsScan();
        scanSensorsController.resetData();
        break;
      case 2:
        scanBluetoothController.stopScan();
        if (result) scanBluetoothController.saveBluetoothScan();
        scanBluetoothController.resetData();
        break;
      case 3:
        scanWifiController.stopScan();
        if (result) scanWifiController.saveWifiScan();
        scanWifiController.resetData();
        break;
    }
  }

  bool get shouldSave => state.shouldSaveScanResults;

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
        return AllModeScreen(scanAllManager: scanAllManager);
      case 1:
        return SensorsModeScreen(scanController: scanSensorsController);
      case 2:
        return BluetoothModeScreen(scanController: scanBluetoothController);
      case 3:
        return WifiModeScreen(scanController: scanWifiController);
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
