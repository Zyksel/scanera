import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/manager/scan_sensors_manager.dart';
import 'package:scanera/screen/scan/home_screen_controller.dart';
import 'package:scanera/widget/scan_controller.dart';
import 'package:scanera/widget/tile/sensor_tile.dart';

class SensorsModeScreen extends StatefulWidget {
  const SensorsModeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SensorsModeScreen> createState() => _SensorsModeScreenState();
}

class _SensorsModeScreenState extends State<SensorsModeScreen> {
  late Timer refreshController;
  ScanSensorsManager scanController = ScanSensorsManager(null);

  @override
  void initState() {
    super.initState();
    refreshController = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) async {
        setState(() {});
      },
    );
    scanController.startScan();
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer = scanController.getAccelerometerValues();

    final gyroscope = scanController.getGyroscopeValues();

    final magnetometer = scanController.getMagnetometerValues();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<HomeController>(
              builder: (_, controller, ___) => ScanController(
                onPressedSecond: () {
                  scanController.isScanning
                      ? scanController.stopScan()
                      : scanController.resumeScan();
                },
                coordinates: controller.state.coordinates,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SensorTile(
                        label: AppLocalizations.of(context)
                            .sensorsModeMagnetometer,
                        data: magnetometer,
                      ),
                      SensorTile(
                        label: AppLocalizations.of(context)
                            .sensorsModeAccelerometer,
                        data: accelerometer,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SensorTile(
                    label: AppLocalizations.of(context).sensorsModeGyroscope,
                    data: gyroscope,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scanController.dispose();
    refreshController.cancel();
  }
}
