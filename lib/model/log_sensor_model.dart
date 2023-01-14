import 'package:scanera/model/scan_model.dart';

class LogSensorModel {
  final String time;
  final List<IndexedSensorDataModel> data;

  LogSensorModel({
    required this.time,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    List<Map> coordsJson = data.map((i) => i.toJson()).toList();

    return {
      time: coordsJson,
    };
  }
}

class IndexedSensorDataModel {
  final String coordinates;
  final List<SensorDataModel> data;

  IndexedSensorDataModel({
    required this.coordinates,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    List<Map> resultsJson = data.map((i) => i.toJson()).toList();

    return {
      coordinates: resultsJson,
    };
  }
}

class SensorDataModel implements ScanModel {
  final String type;
  final String time;
  final String x;
  final String y;
  final String z;

  SensorDataModel({
    required this.type,
    required this.time,
    required this.x,
    required this.y,
    required this.z,
  });

  @override
  Map<String, dynamic> toJson() => {
        "type": type,
        "time": time,
        "x": x,
        "y": y,
        "z": z,
      };
}
