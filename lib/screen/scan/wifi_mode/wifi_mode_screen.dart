import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scanera/blocs/signal/signal_bloc.dart';
import 'package:scanera/manager/scan_wifi_manager.dart';
import 'package:scanera/screen/scan/home_screen_controller.dart';
import 'package:scanera/util/contants.dart';
import 'package:scanera/widget/scan_controller.dart';
import 'package:scanera/widget/tile/signal_tile.dart';

class WifiModeScreen extends StatefulWidget {
  const WifiModeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WifiModeScreen> createState() => _WifiModeScreenState();
}

class _WifiModeScreenState extends State<WifiModeScreen> {
  ScanWifiManager scanController = ScanWifiManager();

  @override
  void initState() {
    scanController.startScan(
      context: context,
      interval: kWifiScanInterval,
    );
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
                        onPressedFirst: () {},
                        onPressedSecond: () {
                          scanController.isScanning
                              ? scanController.resumeScan(
                                  context: context, interval: kWifiScanInterval)
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
