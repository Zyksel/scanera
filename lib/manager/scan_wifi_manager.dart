import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:scanera/blocs/signal/signal_bloc.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/model/log_signal_model.dart';
import 'package:scanera/model/signal_model.dart';
import 'package:scanera/util/app_date_formatters.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

class ScanWifiManager {
  bool isScanning = false;
  late Timer timer;
  late String currentCoords;

  /// on fix loading screen change to -1 and delete if condition in setCurrentCoordinates
  int currentCoordsIndex = -2;
  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();
  List<IndexedSignalDataModel> scanResults = [];
  final _logger = Logger('WifiScan');
  final FileManager _fileManager = FileManager();

  ScanWifiManager(
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
    isScanning = false;

    _logger.fine('[ℹ️] Wifi scanning stopped');
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
      await huntWiFis(context: context);
    });
  }

  void startScan({
    required BuildContext context,
    required Duration interval,
  }) async {
    _logger.fine('[ℹ️] Wifi scanning started');
    isScanning = true;

    await fetchWifi(context: context);

    _logger.fine(
      '[ℹ️] Background scanning started with interval ${interval.inSeconds} seconds',
    );

    timer = Timer.periodic(interval, (_) async {
      await huntWiFis(context: context);
    });
    // toggleScan();
  }

  Future<void> fetchWifi({
    required BuildContext context,
  }) async {
    try {
      wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
      final List<SignalModel> newSignals = [];

      _logger.fine(
        '[📶] Scanner fetched ${wiFiHunterResult.results.length} wifi networks',
      );

      for (var i = 0; i < wiFiHunterResult.results.length; i++) {
        newSignals.add(
          SignalModel(
            SSID: wiFiHunterResult.results[i].SSID,
            BSSID: wiFiHunterResult.results[i].BSSID,
            level: wiFiHunterResult.results[i].level,
          ),
        );
      }
      context.read<SignalBloc>().add(
            LoadSignals(
              signalModel: newSignals,
            ),
          );
    } on PlatformException catch (exception) {
      isScanning = false;

      _logger.fine('[ℹ️] Fetching failed');
      _logger.warning(exception.toString());
    }
  }

  Future<void> huntWiFis({
    required BuildContext context,
  }) async {
    try {
      wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
    } on PlatformException catch (exception) {
      isScanning = false;
      _logger.warning(exception.toString());
    }

    if (!isScanning) return;

    _logger.fine(
      '[📶] Scanner found ${wiFiHunterResult.results.length} wifi networks',
    );

    updateScan(context: context, result: wiFiHunterResult);
  }

  void updateScan({
    required BuildContext context,
    required WiFiHunterResult result,
  }) {
    final List<SignalModel> newSignals = [];
    for (var i = 0; i < result.results.length; i++) {
      newSignals.add(
        SignalModel(
          SSID: result.results[i].SSID.isEmpty
              ? "Unknown"
              : result.results[i].SSID,
          BSSID: result.results[i].BSSID,
          level: result.results[i].level,
        ),
      );

      final logSignal = SignalDataModel(
        type: "wifi",
        time: AppDateFormatters.hourMinuteSecond
            .format(DateTime.now())
            .toString(),
        SSID:
            result.results[i].SSID.isEmpty ? "Unknown" : result.results[i].SSID,
        BSID: result.results[i].BSSID,
        signal: result.results[i].level.toString(),
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

  void saveWifiScan() {
    _fileManager.saveLogFile(
      scanType: "wifi",
      data: jsonEncode(LogSignalModel(
        time: AppDateFormatters.dayMonthYearWithTime
            .format(DateTime.now())
            .toString(),
        data: scanResults,
      )),
    );
  }
}
