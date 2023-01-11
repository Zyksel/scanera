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
    required this.scanController,
  }) : super(key: key);

  final ScanSensorsManager scanController;

  @override
  State<SensorsModeScreen> createState() => _SensorsModeScreenState();
}

class _SensorsModeScreenState extends State<SensorsModeScreen> {
  late Timer refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) async {
        setState(() {});
      },
    );
    widget.scanController.startScan();
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer = widget.scanController.getAccelerometerValues();

    final gyroscope = widget.scanController.getGyroscopeValues();

    final magnetometer = widget.scanController.getMagnetometerValues();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<HomeController>(
              builder: (_, controller, ___) => ScanController(
                onPressedSecond: () {
                  widget.scanController.isScanning
                      ? widget.scanController.stopScan()
                      : widget.scanController.resumeScan();
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
    widget.scanController.dispose();
    refreshController.cancel();
  }
}
