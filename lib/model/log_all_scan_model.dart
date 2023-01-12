import 'package:scanera/model/scan_model.dart';

class LogAllScanModel {
  final String time;
  final List<ScanModel> data;

  LogAllScanModel({
    required this.time,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    List<Map> dataJson = data.map((i) => i.toJson()).toList();

    return {
      "time": time,
      "data": dataJson,
    };
  }
}
