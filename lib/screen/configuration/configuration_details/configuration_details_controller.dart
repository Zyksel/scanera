import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scanera/manager/files_manager.dart';

class ConfigDetailsState {
  String configName = "";
  Map<String, dynamic> jsonConfig = {};
}

class ConfigDetailsController extends ChangeNotifier {
  ConfigDetailsState state = ConfigDetailsState();
  final FileManager _fileManager = FileManager();
  final String configName;

  ConfigDetailsController({
    required this.configName,
  }) {
    getConfigContent();
  }

  Future<void> getConfigContent() async {
    final result = await _fileManager.readConfigContent(configName);
    state.jsonConfig = jsonDecode(result);
    notifyListeners();
  }
}
