import 'package:flutter/cupertino.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/manager/scan_bluetooth_manager.dart';
import 'package:scanera/manager/scan_sensors_manager.dart';
import 'package:scanera/manager/scan_wifi_manager.dart';
import 'package:scanera/util/contants.dart';

class ScanAllManager extends ChangeNotifier {
  ScanAllManager() {
    scanBluetoothManager = ScanBluetoothManager(receiveBluetoothData);
    scanWifiManager = ScanWifiManager(receiveWifiData);
    scanSensorsManager = ScanSensorsManager(receiveSensorsData);
  }

  List<String> logs = [];
  final FileManager _fileManager = FileManager();
  late final ScanBluetoothManager scanBluetoothManager;
  late final ScanWifiManager scanWifiManager;
  late final ScanSensorsManager scanSensorsManager;
  late Function notifier;

  void receiveWifiData(String ssid, String signal) {
    displayData("[WIFI] $ssid with signal $signal");
  }

  void receiveBluetoothData(String ssid, String signal) {
    displayData("[BLE] $ssid with signal $signal");
  }

  void receiveSensorsData(
    List<String> accelerometer,
    List<String> magnetometer,
    List<String> gyroscope,
  ) {
    displayData(
      "[SENSORS] [ACCELEROMETER] $accelerometer [MAGNETOMETER] $magnetometer [GYROSCOPE] $gyroscope",
    );
  }

  void setListener(Function fun) {
    notifier = fun;
  }

  void startAllScan({
    required BuildContext context,
  }) {
    scanSensorsManager.startScan();
    displayData("[SENSORS] scan initialized");
    scanBluetoothManager.startScan(
      context: context,
      interval: kBluetoothScanInterval,
    );
    displayData("[BLUETOOTH] scan initialized");
    scanWifiManager.startScan(
      context: context,
      interval: kWifiScanInterval,
    );
    displayData("[WIFI] scan initialized");
  }

  void stopAllScan() {
    logs = [];
    scanSensorsManager.stopScan();
    scanBluetoothManager.stopScan();
    scanWifiManager.stopScan();
  }

  void resumeAllScan({
    required BuildContext context,
  }) {
    scanSensorsManager.resumeScan();
    scanBluetoothManager.resumeScan(
      context: context,
      interval: kBluetoothScanInterval,
    );
    scanWifiManager.resumeScan(
      context: context,
      interval: kWifiScanInterval,
    );
  }

  void displayData(String data) {
    final DateTime now = DateTime.now();
    logs.add("[${now.hour}:${now.minute}:${now.second}] $data");
    notifier();
  }

  void saveSensorsScan() {
    ///TODO: saving all scan results
    print('save!');
    // _fileManager.saveLogFile(
    //   scanType: "wifi",
    //   data: jsonEncode(LogSignalModel(
    //     time: DateTime.now().toString(),
    //     data: scanResults,
    //   )),
    // );
  }
}
