import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/model/config_storage_model.dart';

class ConfigState {
  List<ConfigStorageModel> configStorageModel = [];
}

class ConfigController extends ChangeNotifier {
  ConfigState state = ConfigState();
  final FileManager _fileManager = FileManager();

  ConfigController() {
    getConfigList();
  }

  Future<void> getConfigList() async {
    final result = await _fileManager.getConfigFiles();
    state.configStorageModel.clear();

    for (var file in result) {
      final names = path.basename(file.path).split('_');
      state.configStorageModel.add(
        ConfigStorageModel(
          name: names[1],
          path: path.basename(file.path),
        ),
      );
    }
    notifyListeners();
  }
}
