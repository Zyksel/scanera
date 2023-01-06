import 'dart:async';

import 'package:logging/logging.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ScanSensorsManager {
  final _logger = Logger('SensorsScan');

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

  bool isScanning = false;
  late Timer timer;

  List<String> getAccelerometerValues() {
    return mapValues(
      values: _accelerometerValues,
    );
  }

  List<String> getGyroscopeValues() {
    return mapValues(
      values: _gyroscopeValues,
    );
  }

  List<String> getMagnetometerValues() {
    return mapValues(
      values: _magnetometerValues,
    );
  }

  List<String> mapValues({
    required List<double> values,
  }) {
    return values
        .map((double v) =>
            v > -0.01 && v < 0.1 ? "0" : v.toStringAsFixed(2).substring(0, 4))
        .toList();
  }

  ScanSensorsManager();

  void startScan() async {
    isScanning = !isScanning;

    _logger.fine('[ℹ️] Sensors listening started');

    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          _accelerometerValues = <double>[event.x, event.y, event.z];
          updateAccelerometerList(event);
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          _gyroscopeValues = <double>[event.x, event.y, event.z];
          updateGyroscopeList(event);
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          _magnetometerValues = <double>[event.x, event.y, event.z];
          updateMagnetometerList(event);
        },
      ),
    );
  }

  void stopScan() async {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions = [];

    isScanning = !isScanning;

    _logger.fine('[ℹ️] Sensors listening stopped');
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

  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions = [];

    _logger.fine('[ℹ️] Sensors scan end');
  }
}
