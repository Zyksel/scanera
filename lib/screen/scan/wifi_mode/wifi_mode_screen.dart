import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanera/blocs/signal/signal_bloc.dart';
import 'package:scanera/model/signal_model.dart';
import 'package:scanera/util/contants.dart';
import 'package:scanera/widget/scan_controller.dart';
import 'package:scanera/widget/snackBar_message.dart';
import 'package:scanera/widget/tile/signal_tile.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

class WifiModeScreen extends StatefulWidget {
  const WifiModeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WifiModeScreen> createState() => _WifiModeScreenState();
}

class _WifiModeScreenState extends State<WifiModeScreen> {
  bool _isScanning = false;
  late Timer timer;
  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();
  final _snackBar = SnackBarMessage();

  @override
  void initState() {
    startScan(interval: kWifiScanInterval);
    context.read<SignalBloc>().add(
          const LoadingSignals(),
        );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final ctx = context;
    ctx.read<SignalBloc>().add(
          const LoadingSignals(),
        );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignalBloc, SignalState>(
        listener: (context, state) {
          /// TODO: implement
        },
        child: BlocBuilder<SignalBloc, SignalState>(
          builder: (context, state) {
            if (state is SignalLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SignalLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScanController(
                        onPressedFirst: () {},
                        onPressedSecond: () {
                          _isScanning
                              ? resumeScan(interval: kWifiScanInterval)
                              : stopScan();
                        },
                        coordinates: const [
                          [1, 2],
                          [2, 3],
                          [3, 4]
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.signals.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SignalTile(
                            SSID: state.signals[index].SSID,
                            BSSID: state.signals[index].BSSID,
                            level: state.signals[index].level,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 12,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void stopScan() async {
    timer.cancel();
    if (kDebugMode) {
      print('[ℹ️] Wifi scanning stopped');
    }
    setState(() {
      _isScanning = !_isScanning;
    });
    // toggleScan();
  }

  void resumeScan({required Duration interval}) {
    if (kDebugMode) {
      print(
        '[ℹ️] Background scanning resumed with interval ${interval.inSeconds} seconds',
      );
    }

    timer = Timer.periodic(interval, (_) async {
      await huntWiFis();
      setState(() {});
    });
  }

  void startScan({required Duration interval}) async {
    if (kDebugMode) {
      print('[ℹ️] Wifi scanning started');
    }

    await fetchWifi();

    if (kDebugMode) {
      print(
        '[ℹ️] Background scanning started with interval ${interval.inSeconds} seconds',
      );
    }
    timer = Timer.periodic(interval, (_) async {
      await huntWiFis();
      setState(() {});
    });
    // toggleScan();
  }

  Future<void> fetchWifi() async {
    try {
      wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
      final List<SignalModel> newSignals = [];

      if (kDebugMode) {
        print(
          '[📶] Scanner fetched ${wiFiHunterResult.results.length} wifi networks',
        );
      }

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
      setState(() {
        _isScanning = !_isScanning;
      });

      if (kDebugMode) {
        print('[ℹ️] Fetching failed');
        print(exception.toString());
      }
    }

    if (!mounted) return;
  }

  Future<void> huntWiFis() async {
    try {
      wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
    } on PlatformException catch (exception) {
      setState(() {
        _isScanning = !_isScanning;
      });
      if (kDebugMode) {
        print(exception.toString());
      }
    }

    if (kDebugMode) {
      print(
        '[📶] Scanner found ${wiFiHunterResult.results.length} wifi networks',
      );
    }

    updateScan(wiFiHunterResult);

    if (!mounted) return;
  }

  void updateScan(WiFiHunterResult result) {
    final List<SignalModel> newSignals = [];
    for (var i = 0; i < result.results.length; i++) {
      newSignals.add(
        SignalModel(
          SSID: result.results[i].SSID,
          BSSID: result.results[i].BSSID,
          level: result.results[i].level,
        ),
      );
    }
    context.read<SignalBloc>().add(
          UpdateSignal(
            signalModels: newSignals,
          ),
        );
  }
}
