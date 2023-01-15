import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/model/log_sensor_model.dart';
import 'package:scanera/util/app_date_formatters.dart';
import 'package:scanera/util/contants.dart';
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

  List<IndexedSensorDataModel> scanResults = [];

  final FileManager _fileManager = FileManager();

  bool isScanning = false;
  late Timer timer;
  late String currentCoords;

  int currentCoordsIndex = -1;

  ScanSensorsManager(
    this.listener,
  );

  final Function? listener;

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

  void startScan() async {
    isScanning = true;

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

    if (listener != null) {
      timer = Timer.periodic(kSensorsReportInterval, (_) async {
        sendResults();
      });
    } else {
      timer = Timer.periodic(kSensorsReportInterval, (_) async {
        saveScanResults();
      });
    }
  }

  void stopScan() async {
    timer.cancel();

    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions = [];

    isScanning = false;

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

  void sendResults() {
    final magnetometer = getMagnetometerValues();
    final accelerometer = getAccelerometerValues();
    final gyroscope = getGyroscopeValues();

    listener!(magnetometer, accelerometer, gyroscope);
  }

  void dispose() {
    timer.cancel();

    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions = [];
    scanResults = [];

    _logger.fine('[ℹ️] Sensors scan end');
  }

  void saveScanResults() {
    final now = DateTime.now();

    if (!isScanning) return;

    scanResults[currentCoordsIndex].data.add(
          SensorDataModel(
            type: "magnetomer",
            time: AppDateFormatters.hourMinuteSecond.format(now).toString(),
            x: _magnetometerValues[0].toString(),
            y: _magnetometerValues[1].toString(),
            z: _magnetometerValues[2].toString(),
          ),
        );

    scanResults[currentCoordsIndex].data.add(
          SensorDataModel(
            type: "accelerometer",
            time: AppDateFormatters.hourMinuteSecond.format(now).toString(),
            x: _accelerometerValues[0].toString(),
            y: _accelerometerValues[1].toString(),
            z: _accelerometerValues[2].toString(),
          ),
        );

    scanResults[currentCoordsIndex].data.add(
          SensorDataModel(
            type: "gyroscope",
            time: AppDateFormatters.hourMinuteSecond.format(now).toString(),
            x: _gyroscopeValues[0].toString(),
            y: _gyroscopeValues[1].toString(),
            z: _gyroscopeValues[2].toString(),
          ),
        );
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

  void resetData() {
    scanResults.clear();
    currentCoordsIndex = -1;
    isScanning = false;
    accList = 0;
    gyroList = 0;
    magneList = 0;

    _accelerometerValues = [0, 0, 0];
    _gyroscopeValues = [0, 0, 0];
    _magnetometerValues = [0, 0, 0];

    accelerometerValues.clear();
    gyroscopeValues.clear();
    magnetometerValues.clear();

    _streamSubscriptions.clear();
  }
}
