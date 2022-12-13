import 'package:flutter/material.dart';
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
  List<String> configs = [];
  List<List<int>> coordinates = [];
}

class HomeController extends ChangeNotifier {
  HomeState state = HomeState();
  final FileManager _fileManager = FileManager();

  HomeController() {
    fetchConfigs();
  }

  void chooseConfig(String config) {
    state.chosenConfig = config;
    print(state.chosenConfig);
    notifyListeners();
  }

  void addConfigs(List<String> data) {
    state.configs = data;
    notifyListeners();
  }

  void changeIndex(int index) {
    state.selectedIndex = index;
    notifyListeners();
  }

  void toggleScan() {
    state.isScanning = !state.isScanning;
    notifyListeners();
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
      final configs = await _fileManager.getConfigFiles();
      for (final file in configs) {
        final configName = path.basename(file.path).split('_');
        state.configs.add(configName[1]);
      }
    });
    notifyListeners();
  }

  Future<void> getScanConfig(String config) async {
    final configString = await _fileManager.readConfigContent(config);
    // for (var file in result) {
    //   final names = path.basename(file.path).split('_');
    //   state.configNames.add(names[1]);
    //   state.configPaths.add(path.basename(file.path));
    // }
    final model = ConfigStorageModel(name: "name", path: "asdasd/asd/asd/");
  }
}
