import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:scanera/blocs/signal/signal_bloc.dart';
import 'package:scanera/model/signal_model.dart';
import 'package:scanera/util/contants.dart';
import 'package:scanera/widget/scan_controller.dart';
import 'package:scanera/widget/snackBar_message.dart';
import 'package:scanera/widget/tile/signal_tile.dart';

class BluetoothModeScreen extends StatefulWidget {
  const BluetoothModeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BluetoothModeScreen> createState() => _BluetoothModeScreenState();
}

class _BluetoothModeScreenState extends State<BluetoothModeScreen> {
  bool _isScanning = false;
  late Timer timer;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  late Future<List<List<ScanResult>>> results;
  final _snackBar = SnackBarMessage();

  @override
  void initState() {
    context.read<SignalBloc>().add(
          const LoadingSignals(),
        );
    startScan(interval: kBluetoothScanInterval);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   final ctx = context;
  //   ctx.read<SignalBloc>().add(
  //         const RemoveSignal(),
  //       );
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    stopScan();
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
                              ? resumeScan(interval: kBluetoothScanInterval)
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
    await flutterBlue.stopScan();
    timer.cancel();
    if (kDebugMode) {
      print('[ℹ️] Bluetooth scanning stopped');
    }
    setState(() {
      _isScanning = !_isScanning;
    });
  }

  void resumeScan({required Duration interval}) {
    flutterBlue.startScan(timeout: interval);
    if (kDebugMode) {
      print(
        '[ℹ️] Background scanning resumed with interval ${interval.inSeconds} seconds',
      );
    }

    timer = Timer.periodic(interval, (_) async {
      scanSignals();
    });
  }

  void startScan({required Duration interval}) async {
    if (kDebugMode) {
      print(
        '[ℹ️] Bluetooth scanning started with interval ${interval.inSeconds} seconds',
      );
    }

    timer = Timer.periodic(interval, (_) async {
      scanSignals();
    });

    Future.delayed(interval, () {
      context.read<SignalBloc>().add(
            const LoadSignals(
              signalModel: [],
            ),
          );
    });
  }

  void scanSignals() async {
    await flutterBlue.startScan(timeout: kBluetoothScanPeriodInterval);

    flutterBlue.scanResults.listen(
      (results) {
        if (kDebugMode) {
          print(
            '[📶] Scanner fetched ${results.length} bluetooth devices',
          );
        }
        final List<SignalModel> newSignals = [];
        for (var i = 0; i < results.length; i++) {
          newSignals.add(
            SignalModel(
              SSID: results[i].device.name == ""
                  ? "Unkown"
                  : results[i].device.name,
              BSSID: results[i].device.id.id,
              level: results[i].rssi,
            ),
          );
        }
        context.read<SignalBloc>().add(
              UpdateSignal(
                signalModels: newSignals,
              ),
            );
      },
    );

    await flutterBlue.stopScan();
  }
}
