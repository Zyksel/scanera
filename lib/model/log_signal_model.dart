class LogSignalModel {
  final String time;
  final List<SignalDataModel> data;

  LogSignalModel({
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

class SignalDataModel {
  final String type;
  final String time;
  final String SSID;
  final String BSID;
  final String signal;

  SignalDataModel({
    required this.type,
    required this.time,
    required this.SSID,
    required this.BSID,
    required this.signal,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "time": time,
        "SSID": SSID,
        "BSID": BSID,
        "signal": signal,
      };
}
