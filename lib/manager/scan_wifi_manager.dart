import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:scanera/blocs/signal/signal_bloc.dart';
import 'package:scanera/model/signal_model.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

class ScanWifiManager {
  bool isScanning = false;
  late Timer timer;
  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();
  final _logger = Logger('WifiScan');

  ScanWifiManager(
    this.listener,
  );

  final Function? listener;

  void stopScan() async {
    timer.cancel();
    isScanning = !isScanning;

    _logger.fine('[ℹ️] Wifi scanning stopped');
  }

  void resumeScan({
    required BuildContext context,
    required Duration interval,
  }) {
    _logger.fine(
      '[ℹ️] Background scanning resumed with interval ${interval.inSeconds} seconds',
    );

    isScanning = !isScanning;
    timer = Timer.periodic(interval, (_) async {
      await huntWiFis(context: context);
    });
  }

  void startScan({
    required BuildContext context,
    required Duration interval,
  }) async {
    _logger.fine('[ℹ️] Wifi scanning started');

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
      isScanning = !isScanning;

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
      isScanning = !isScanning;
      _logger.warning(exception.toString());
    }

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
          SSID: result.results[i].SSID,
          BSSID: result.results[i].BSSID,
          level: result.results[i].level,
        ),
      );
      if (listener != null) {
        listener!(
          wiFiHunterResult.results[i].SSID.toString(),
          wiFiHunterResult.results[i].level.toString(),
        );
      }
    }
    context.read<SignalBloc>().add(
          UpdateSignal(
            signalModels: newSignals,
          ),
        );
  }
}
