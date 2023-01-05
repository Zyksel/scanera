import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scanera/blocs/signal/signal_bloc.dart';
import 'package:scanera/manager/scan_bluetooth_manager.dart';
import 'package:scanera/screen/scan/home_screen_controller.dart';
import 'package:scanera/util/contants.dart';
import 'package:scanera/widget/scan_controller.dart';
import 'package:scanera/widget/tile/signal_tile.dart';

class BluetoothModeScreen extends StatefulWidget {
  const BluetoothModeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BluetoothModeScreen> createState() => _BluetoothModeScreenState();
}

class _BluetoothModeScreenState extends State<BluetoothModeScreen> {
  final ScanBluetoothManager scanController = ScanBluetoothManager();

  @override
  void initState() {
    context.read<SignalBloc>().add(
          const LoadingSignals(),
        );
    scanController.startScan(
        context: context, interval: kBluetoothScanInterval);
    super.initState();
  }

  @override
  void dispose() {
    scanController.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SignalBloc, SignalState>(
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
                    Consumer<HomeController>(
                      builder: (_, controller, ___) => ScanController(
                        onPressedSecond: () {
                          scanController.isScanning
                              ? scanController.resumeScan(
                                  context: context,
                                  interval: kBluetoothScanInterval)
                              : scanController.stopScan();
                        },
                        coordinates: controller.state.coordinates,
                      ),
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
    );
  }
}
