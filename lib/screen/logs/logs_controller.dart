import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:scanera/manager/files_manager.dart';

class LogsState {
  List<String> logsPaths = [];
}

class LogsController extends ChangeNotifier {
  LogsState state = LogsState();
  final FileManager _fileManager = FileManager();

  LogsController() {
    getFilesList();
  }

  Future<void> getFilesList() async {
    final result = await _fileManager.getLogsFiles();

    for (var file in result) {
      state.logsPaths.add(path.basename(file.path));
    }
    notifyListeners();
  }
}
