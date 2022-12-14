import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/screen/scan/home_screen_controller.dart';
import 'package:scanera/widget/scan_controller.dart';
import 'package:scanera/widget/tile/sensor_tile.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsModeScreen extends StatefulWidget {
  const SensorsModeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SensorsModeScreen> createState() => _SensorsModeScreenState();
}

class _SensorsModeScreenState extends State<SensorsModeScreen> {
  int accList = 0;
  int gyroList = 0;
  int magneList = 0;

  List<double> _accelerometerValues = [0, 0, 0];
  List<double> _gyroscopeValues = [0, 0, 0];
  List<double> _magnetometerValues = [0, 0, 0];

  List<List<double?>> accelerometerValues = [];
  List<List<double?>> gyroscopeValues = [];
  List<List<double?>> magnetometerValues = [];

  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  bool _isScanning = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    startScan();
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer = _accelerometerValues
        .map((double v) =>
            v > -0.01 && v < 0.1 ? "0" : v.toStringAsFixed(2).substring(0, 4))
        .toList();

    final gyroscope = _gyroscopeValues
        .map((double v) =>
            v > 0.01 && v < 0.1 ? "0" : v.toStringAsFixed(2).substring(0, 4))
        .toList();

    final magnetometer = _magnetometerValues
        .map((double v) =>
            v > 0.01 && v < 0.1 ? "0" : v.toStringAsFixed(2).substring(0, 4))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<HomeController>(
            builder: (_, controller, ___) => ScanController(
              onPressedFirst: () {},
              onPressedSecond: () {
                _isScanning ? stopScan() : resumeScan();
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
                      label:
                          AppLocalizations.of(context).sensorsModeMagnetometer,
                      data: magnetometer,
                    ),
                    SensorTile(
                      label:
                          AppLocalizations.of(context).sensorsModeAccelerometer,
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
    );
  }

  void startScan() async {
    setState(() {
      _isScanning = !_isScanning;
    });

    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
            updateAccelerometerList(event);
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
            updateGyroscopeList(event);
          });
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
            updateMagnetometerList(event);
          });
        },
      ),
    );
    if (kDebugMode) {
      print('[ℹ️] Sensors listening started');
    }
  }

  void stopScan() async {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions = [];

    setState(() {
      _isScanning = !_isScanning;
    });

    if (kDebugMode) {
      print('[ℹ️] Sensors listening stopped');
    }
  }

  void resumeScan() {
    startScan();
  }

  void updateMagnetometerList(MagnetometerEvent event) {
    magnetometerValues.add(<double>[event.x, event.y, event.z]);
  }

  void updateAccelerometerList(AccelerometerEvent event) {
    accelerometerValues.add(<double>[event.x, event.y, event.z]);
  }

  void updateGyroscopeList(GyroscopeEvent event) {
    gyroscopeValues.add(<double>[event.x, event.y, event.z]);
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions = [];

    if (kDebugMode) {
      print('[ℹ️] Sensors scan end');
    }
  }
}
