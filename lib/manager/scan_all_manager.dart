import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/manager/scan_bluetooth_manager.dart';
import 'package:scanera/manager/scan_sensors_manager.dart';
import 'package:scanera/manager/scan_wifi_manager.dart';
import 'package:scanera/model/log_all_scan_model.dart';
import 'package:scanera/model/log_sensor_model.dart';
import 'package:scanera/model/log_signal_model.dart';
import 'package:scanera/util/app_date_formatters.dart';
import 'package:scanera/util/contants.dart';

class ScanAllManager extends ChangeNotifier {
  ScanAllManager({
    required this.isIOS,
  }) {
    scanBluetoothManager = ScanBluetoothManager(receiveBluetoothData);
    if (!isIOS) scanWifiManager = ScanWifiManager(receiveWifiData);
    scanSensorsManager = ScanSensorsManager(receiveSensorsData);
  }

  List<String> logs = [];
  List<IndexedAllDataModel> scanResults = [];
  int currentCoordsIndex = -1;
  late String currentCoords;
  final FileManager _fileManager = FileManager();
  late final ScanBluetoothManager scanBluetoothManager;
  late final ScanWifiManager scanWifiManager;
  late final ScanSensorsManager scanSensorsManager;
  late Function notifier;
  final bool isIOS;

  void setCurrentCoordinates(List<int> coords) {
    currentCoords = "${coords[0]}:${coords[1]}";
    scanResults.add(
      IndexedAllDataModel(
        coordinates: currentCoords,
        data: [],
      ),
    );
    currentCoordsIndex += 1;
  }

  void receiveWifiData(SignalDataModel model) {
    displayData("[WIFI] ${model.SSID} with signal ${model.signal}");
    scanResults[currentCoordsIndex].data.add(model);
  }

  void receiveBluetoothData(SignalDataModel model) {
    displayData("[BLE] ${model.SSID} with signal ${model.signal}");
    scanResults[currentCoordsIndex].data.add(model);
  }

  List<String> mapValues({
    required List<String> values,
  }) {
    return values
        .map((String v) => v.length > 3 ? v.substring(0, 4) : v)
        .toList();
  }

  void receiveSensorsData(
    List<String> accelerometer,
    List<String> magnetometer,
    List<String> gyroscope,
  ) {
    final now = DateTime.now();

    displayData(
      "[SENSORS]\n[ACCELEROMETER] ${mapValues(values: accelerometer)}\n[MAGNETOMETER] ${mapValues(values: magnetometer)}\n[GYROSCOPE] ${mapValues(values: gyroscope)}",
    );

    scanResults[currentCoordsIndex].data.add(
          SensorDataModel(
            type: "accelerometer",
            time: AppDateFormatters.hourMinuteSecondMillisecond
                .format(now)
                .toString(),
            x: accelerometer[0],
            y: accelerometer[1],
            z: accelerometer[2],
          ),
        );

    scanResults[currentCoordsIndex].data.add(
          SensorDataModel(
            type: "magnetometer",
            time: AppDateFormatters.hourMinuteSecondMillisecond
                .format(now)
                .toString(),
            x: magnetometer[0],
            y: magnetometer[1],
            z: magnetometer[2],
          ),
        );

    scanResults[currentCoordsIndex].data.add(
          SensorDataModel(
            type: "gyroscope",
            time: AppDateFormatters.hourMinuteSecondMillisecond
                .format(now)
                .toString(),
            x: gyroscope[0],
            y: gyroscope[1],
            z: gyroscope[2],
          ),
        );
  }

  void setListener(Function fun) {
    notifier = fun;
  }

  void startAllScan({
    required BuildContext context,
  }) {
    scanBluetoothManager.startScan(
      context: context,
      interval: kBluetoothScanInterval,
    );
    displayData("[BLUETOOTH] scan initialized");

    if (!isIOS) {
      scanWifiManager.startScan(
        context: context,
        interval: kWifiScanInterval,
      );
      displayData("[WIFI] scan initialized");
    }

    displayData("[SENSORS] scan initialized");
    scanSensorsManager.startScan();
  }

  void stopAllScan() {
    scanBluetoothManager.stopScan();
    if (!isIOS) scanWifiManager.stopScan();
    scanSensorsManager.stopScan();
  }

  void resumeAllScan({
    required BuildContext context,
  }) {
    scanSensorsManager.resumeScan();
    scanBluetoothManager.resumeScan(
      context: context,
      interval: kBluetoothScanInterval,
    );

    if (isIOS) return;
    scanWifiManager.resumeScan(
      context: context,
      interval: kWifiScanInterval,
    );
  }

  void displayData(String data) {
    logs.add(
      "[${AppDateFormatters.hourMinuteSecond.format(DateTime.now()).toString()}] $data",
    );
    notifier();
  }

  void saveSensorsScan() {
    _fileManager.saveLogFile(
      scanType: "all",
      data: jsonEncode(LogAllScanModel(
        time: AppDateFormatters.dayMonthYearWithTime
            .format(DateTime.now())
            .toString(),
        data: scanResults,
      )),
    );
  }

  void resetData() {
    logs.clear();
    scanResults.clear();
    currentCoordsIndex = -1;
  }
}
