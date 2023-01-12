// ignore_for_file: non_constant_identifier_names

import 'package:scanera/model/scan_model.dart';

class LogSignalModel implements ScanModel {
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

class SignalDataModel implements ScanModel {
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

  @override
  Map<String, dynamic> toJson() => {
        "type": type,
        "time": time,
        "SSID": SSID,
        "BSID": BSID,
        "signal": signal,
      };
}
