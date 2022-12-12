import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanera/model/config_model.dart';

class FileManager {
  FileManager();

  final _logger = Logger('FileManager');

  Future<Directory> get _appDirectory => getApplicationSupportDirectory();

  /// logs
  Future<void> saveLogFile({
    required String scanType,
    required String data,
  }) async {
    final directory = await _appDirectory;
    final logsPath = '${directory.path}/logs';

    final logFileName =
        'log_${scanType}_${DateTime.now().toIso8601String()}.json';

    final File file =
        await File('$logsPath/$logFileName').create(recursive: true);

    await file.writeAsString(data);
    _logger.fine('Scan results saved to directory ${file.path}');
  }

  Future<List<File>> getLogsFiles() async {
    final directory = await _appDirectory;
    await Directory('${directory.path}/logs').create(recursive: true);
    final logsDir = Directory('${directory.path}/logs');

    final files = logsDir.listSync().whereType<File>().toList();

    _logger.fine('${files.length} logs found!');

    return files;
  }

  Future<void> clearLogsDirectory() async {
    final directory = await _appDirectory;
    final logsDir = Directory('${directory.path}/logs');

    if (!await logsDir.exists()) {
      return;
    }

    final filesToDelete = logsDir.listSync();

    for (final file in filesToDelete) {
      _logger.fine('Deleting log ${file.path}');
      await file.delete();
    }

    _logger.fine('Directory $logsDir cleared!');
  }

  Future<String> readLogContent(String path) async {
    final directory = await _appDirectory;
    final logFile = File("${directory.path}/logs/$path");

    return await logFile.readAsString();
  }

  /// configurations
  Future<void> saveConfigFile({
    required ConfigModel model,
  }) async {
    final directory = await _appDirectory;
    final configsPath = '${directory.path}/configs';

    final configFileName =
        'config_${model.name}_${DateTime.now().toIso8601String()}.json';

    final File file =
        await File('$configsPath/$configFileName').create(recursive: true);

    await file.writeAsString(jsonEncode(model));
    _logger.fine(
      'Configuration $configFileName saved to directory ${file.path}',
    );
  }

  Future<List<File>> getConfigFiles() async {
    final directory = await _appDirectory;
    await Directory('${directory.path}/configs').create(recursive: true);
    final logsDir = Directory('${directory.path}/configs');

    final files = logsDir.listSync().whereType<File>().toList();

    _logger.fine('${files.length} configs found!');

    return files;
  }

  Future<void> clearConfigDirectory() async {
    final directory = await _appDirectory;
    final logsDir = Directory('${directory.path}/configs');

    if (!await logsDir.exists()) {
      return;
    }

    final filesToDelete = logsDir.listSync();

    for (final file in filesToDelete) {
      _logger.fine('Deleting log ${file.path}');
      await file.delete();
    }

    _logger.fine('Directory $logsDir cleared!');
  }

  Future<String> readConfigContent(String path) async {
    final directory = await _appDirectory;
    final configFile = File("${directory.path}/configs/$path");

    return await configFile.readAsString();
  }
}
