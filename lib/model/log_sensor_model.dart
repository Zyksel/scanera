class LogSensorModel {
  final String time;
  final List<SensorDataModel> data;

  LogSensorModel({
    required this.time,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    List<Map> coordsJson = data.map((i) => i.toJson()).toList();

    return {
      "time": time,
      "data": coordsJson,
    };
  }
}

class SensorDataModel {
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

  Map<String, dynamic> toJson() => {
        "type": type,
        "time": time,
        "x": x,
        "y": y,
        "z": z,
      };
}
