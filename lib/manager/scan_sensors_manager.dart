import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/model/log_sensor_model.dart';
import 'package:scanera/util/app_date_formatters.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ScanSensorsManager {
  final _logger = Logger('SensorsScan');
  final FileManager _fileManager = FileManager();

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  List<double> _accelerometerValues = [0, 0, 0];
  List<double> _gyroscopeValues = [0, 0, 0];
  List<double> _magnetometerValues = [0, 0, 0];

  List<IndexedSensorDataModel> scanResults = [];
  bool isScanning = false;
  int currentCoordsIndex = -1;
  late String currentCoords;

  final Function? listener;

  ScanSensorsManager(
    this.listener,
  );

  void setCurrentCoordinates(List<int> coords) {
    currentCoords = "${coords[0]}:${coords[1]}";
    scanResults.add(
      IndexedSensorDataModel(
        coordinates: currentCoords,
        data: [],
      ),
    );
    currentCoordsIndex += 1;
  }

  void startScan() async {
    isScanning = true;

    _logger.fine('[ℹ️] Sensors listening started');

    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          _accelerometerValues = <double>[event.x, event.y, event.z];

          addSensorModeResults(_accelerometerValues, "accelerometer");
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          _gyroscopeValues = <double>[event.x, event.y, event.z];

          addSensorModeResults(_gyroscopeValues, "gyroscope");
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          _magnetometerValues = <double>[event.x, event.y, event.z];

          addSensorModeResults(_magnetometerValues, "magnetometer");

          if (listener != null) sendResults();
        },
      ),
    );
  }

  void addSensorModeResults(
    List<double> values,
    String mode,
  ) {
    if (listener != null) {
      return;
    }

    scanResults[currentCoordsIndex].data.add(SensorDataModel(
          type: mode,
          time: AppDateFormatters.hourMinuteSecondMillisecond
              .format(DateTime.now())
              .toString(),
          x: values[0].toString(),
          y: values[1].toString(),
          z: values[2].toString(),
        ));
  }

  void stopScan() async {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();

    isScanning = false;

    _logger.fine('[ℹ️] Sensors listening stopped');
  }

  void resumeScan() {
    startScan();
  }

  void sendResults() {
    final magnetometer = mapValuesToString(values: _magnetometerValues);
    final accelerometer = mapValuesToString(values: _accelerometerValues);
    final gyroscope = mapValuesToString(values: _gyroscopeValues);

    listener!(magnetometer, accelerometer, gyroscope);
  }

  void saveSensorsScan() {
    _fileManager.saveLogFile(
      scanType: "sensors",
      data: jsonEncode(LogSensorModel(
        time: AppDateFormatters.dayMonthYearWithTime
            .format(DateTime.now())
            .toString(),
        data: scanResults,
      )),
    );
  }

  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }

    _streamSubscriptions.clear();
    scanResults.clear();

    _logger.fine('[ℹ️] Sensors scan end');
  }

  void resetData() {
    scanResults.clear();
    currentCoordsIndex = -1;
    isScanning = false;

    _accelerometerValues = [0, 0, 0];
    _gyroscopeValues = [0, 0, 0];
    _magnetometerValues = [0, 0, 0];

    _streamSubscriptions.clear();
  }

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

  List<String> mapValuesToString({
    required List<double> values,
  }) {
    return values.map((double v) => v.toString()).toList();
  }
}
