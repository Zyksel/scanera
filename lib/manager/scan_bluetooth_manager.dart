import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logging/logging.dart';
import 'package:scanera/blocs/signal/signal_bloc.dart';
import 'package:scanera/model/signal_model.dart';
import 'package:scanera/util/contants.dart';

class ScanBluetoothManager {
  late Timer timer;
  bool isScanning = false;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  late Future<List<List<ScanResult>>> results;
  final _logger = Logger('BluetoothScan');

  ScanBluetoothManager(
    this.listener,
  );

  final Function? listener;

  void stopScan() async {
    timer.cancel();
    await flutterBlue.stopScan();
    isScanning = !isScanning;

    _logger.fine('[ℹ️] Bluetooth scanning stopped');
  }

  void resumeScan({
    required BuildContext context,
    required Duration interval,
  }) {
    _logger.fine(
      '[ℹ️] Background scanning resumed with interval ${interval.inSeconds} seconds',
    );

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

    timer = Timer.periodic(interval, (_) async {
      scanSignals(
        context: context,
      );
    });

    Future.delayed(interval, () {
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

    final List<SignalModel> newSignals = [];
    for (var i = 0; i < results.length; i++) {
      newSignals.add(
        SignalModel(
          SSID:
              results[i].device.name == "" ? "Unkown" : results[i].device.name,
          BSSID: results[i].device.id.id,
          level: results[i].rssi,
        ),
      );

      if (listener != null) {
        listener!(
          results[i].device.name == ""
              ? "Unkown"
              : results[i].device.name.toString(),
          results[i].rssi.toString(),
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
