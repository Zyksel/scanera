import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:scanera/manager/files_manager.dart';

class ConfigState {
  List<String> configPaths = [];
  List<String> configNames = [];
}

class ConfigController extends ChangeNotifier {
  ConfigState state = ConfigState();
  final FileManager _fileManager = FileManager();

  ConfigController() {
    getConfigList();
  }

  Future<void> getConfigList() async {
    final result = await _fileManager.getConfigFiles();
    state.configPaths.clear();
    state.configNames.clear();

    for (var file in result) {
      final names = path.basename(file.path).split('_');
      state.configNames.add(names[1]);
      state.configPaths.add(path.basename(file.path));
    }
    notifyListeners();
  }
}
