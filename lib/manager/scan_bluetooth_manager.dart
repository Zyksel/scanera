import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logging/logging.dart';
import 'package:scanera/blocs/signal/signal_bloc.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/model/log_signal_model.dart';
import 'package:scanera/model/signal_model.dart';
import 'package:scanera/util/app_date_formatters.dart';
import 'package:scanera/util/contants.dart';

class ScanBluetoothManager {
  late Timer timer;
  bool isScanning = false;
  late String currentCoords;

  int currentCoordsIndex = -2;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<IndexedSignalDataModel> scanResults = [];
  final _logger = Logger('BluetoothScan');
  final FileManager _fileManager = FileManager();

  ScanBluetoothManager(
    this.listener,
  );

  final Function? listener;

  void setCurrentCoordinates(List<int> coords) {
    currentCoords = "${coords[0]}:${coords[1]}";
    if (currentCoordsIndex != -2) {
      scanResults.add(
        IndexedSignalDataModel(
          coordinates: currentCoords,
          data: [],
        ),
      );
    }
    currentCoordsIndex += 1;
  }

  void stopScan() async {
    timer.cancel();
    await flutterBlue.stopScan();
    isScanning = false;

    _logger.fine('[ℹ️] Bluetooth scanning stopped');
  }

  void resumeScan({
    required BuildContext context,
    required Duration interval,
  }) {
    _logger.fine(
      '[ℹ️] Background scanning resumed with interval ${interval.inSeconds} seconds',
    );

    isScanning = true;

    timer = Timer.periodic(interval, (_) async {
      scanSignals(
        context: context,
      );
    });
  }

  void startScan({
    required BuildContext context,
    required Duration interval,
  }) async {
    _logger.fine(
      '[ℹ️] Bluetooth scanning started with interval ${interval.inSeconds} seconds',
    );

    isScanning = true;

    timer = Timer.periodic(interval, (_) async {
      scanSignals(
        context: context,
      );
    });

    Future.delayed(interval, () {
      if (!isScanning) return;
      context.read<SignalBloc>().add(
            const LoadSignals(
              signalModel: [],
            ),
          );
    });
  }

  void scanSignals({
    required BuildContext context,
  }) async {
    final results =
        await flutterBlue.startScan(timeout: kBluetoothScanPeriodInterval);

    _logger.fine(
      '[📶] Scanner fetched ${results.length} bluetooth devices',
    );

    if (!isScanning) return;

    final List<SignalModel> newSignals = [];
    for (var i = 0; i < results.length; i++) {
      final signal = SignalModel(
        SSID: results[i].device.name == "" ? "Unkown" : results[i].device.name,
        BSSID: results[i].device.id.id,
        level: results[i].rssi,
      );

      newSignals.add(signal);

      final logSignal = SignalDataModel(
        type: "bluetooth",
        time: AppDateFormatters.hourMinuteSecond
            .format(DateTime.now())
            .toString(),
        SSID: results[i].device.name == "" ? "Unkown" : results[i].device.name,
        BSID: results[i].device.id.id,
        signal: results[i].rssi.toString(),
      );

      if (listener != null) {
        listener!(logSignal);
      } else {
        scanResults[currentCoordsIndex].data.add(logSignal);
      }
    }

    context.read<SignalBloc>().add(
          UpdateSignal(
            signalModels: newSignals,
          ),
        );
  }

  void saveBluetoothScan() {
    _fileManager.saveLogFile(
      scanType: "bluetooth",
      data: jsonEncode(LogSignalModel(
        time: AppDateFormatters.dayMonthYearWithTime
            .format(DateTime.now())
            .toString(),
        data: scanResults,
      )),
    );
  }

  void resetData() {
    scanResults.clear();
    currentCoordsIndex = -2;
    isScanning = false;
  }
}
