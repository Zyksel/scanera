import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:scanera/manager/files_manager.dart';

class ConfigState {
  List<String> configFiles = [];
}

class ConfigController extends ChangeNotifier {
  ConfigState state = ConfigState();
  final FileManager _fileManager = FileManager();

  ConfigController() {
    getConfigList();
  }

  Future<void> getConfigList() async {
    final result = await _fileManager.getConfigFiles();
    state.configFiles.clear();

    for (var file in result) {
      state.configFiles.add(path.basename(file.path));
    }
    notifyListeners();
  }
}
