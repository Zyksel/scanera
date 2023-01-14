import 'package:scanera/model/scan_model.dart';

class LogAllScanModel {
  final String time;
  final List<IndexedAllDataModel> data;

  LogAllScanModel({
    required this.time,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    List<Map> dataJson = data.map((i) => i.toJson()).toList();

    return {
      time: dataJson,
    };
  }
}

class IndexedAllDataModel {
  final String coordinates;
  final List<ScanModel> data;

  IndexedAllDataModel({
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
