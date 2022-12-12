import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scanera/manager/files_manager.dart';

class LogsDetailsState {
  Map<String, dynamic> jsonConfig = {};
}

class LogsDetailsController extends ChangeNotifier {
  LogsDetailsState state = LogsDetailsState();
  final FileManager _fileManager = FileManager();
  final String logName;

  LogsDetailsController({
    required this.logName,
  }) {
    getLogContent();
  }

  Future<void> getLogContent() async {
    final result = await _fileManager.readLogContent(logName);
    state.jsonConfig = jsonDecode(result);
    notifyListeners();
  }
}
