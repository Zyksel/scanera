import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanera/manager/scan_bluetooth_manager.dart';
import 'package:scanera/manager/scan_sensors_manager.dart';
import 'package:scanera/manager/scan_wifi_manager.dart';
import 'package:scanera/screen/scan/home_screen_controller.dart';
import 'package:scanera/util/contants.dart';
import 'package:scanera/widget/scan_controller.dart';

class AllModeScreen extends StatefulWidget {
  const AllModeScreen({Key? key}) : super(key: key);

  @override
  State<AllModeScreen> createState() => _AllModeScreenState();
}

class _AllModeScreenState extends State<AllModeScreen> {
  ScanSensorsManager scanControllerSensors = ScanSensorsManager();
  ScanBluetoothManager scanControllerBluetooth = ScanBluetoothManager();
  ScanWifiManager scanControllerWifi = ScanWifiManager();

  Random random = Random();
  final ScrollController _controller = ScrollController();

  bool isScanning = false;
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAllScan();
    });
  }

  @override
  void dispose() {
    stopAllScan();
    super.dispose();
  }

  void startAllScan() {
    isScanning = true;
    scanControllerSensors.startScan();
    displayData("[SENSORS] scan initialized");
    scanControllerBluetooth.startScan(
      context: context,
      interval: kBluetoothScanInterval,
    );
    displayData("[BLUETOOTH] scan initialized");
    scanControllerWifi.startScan(
      context: context,
      interval: kWifiScanInterval,
    );
    displayData("[WIFI] scan initialized");
  }

  void stopAllScan() {
    isScanning = false;
    scanControllerSensors.stopScan();
    scanControllerBluetooth.stopScan();
    scanControllerWifi.stopScan();
  }

  void resumeAllScan() {
    isScanning = true;
    scanControllerSensors.resumeScan();
    scanControllerBluetooth.resumeScan(
      context: context,
      interval: kBluetoothScanInterval,
    );
    scanControllerWifi.resumeScan(
      context: context,
      interval: kWifiScanInterval,
    );
  }

  void displayData(String data) {
    logs.add(data);
    setState(() {});
    _controller.jumpTo(_controller.position.maxScrollExtent + 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<HomeController>(
              builder: (_, controller, ___) => ScanController(
                onPressedSecond: () {
                  isScanning ? stopAllScan() : resumeAllScan();
                },
                coordinates: controller.state.coordinates,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: logs.length,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    logs[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
