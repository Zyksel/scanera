import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanera/model/config_model.dart';

class FileManager {
  FileManager();

  final _logger = Logger('FileManager');

  Future<Directory> get _logsDirectory => getApplicationSupportDirectory();

  /// both
  Future<String> readFileContent(File file) async {
    return await file.readAsString();
  }

  /// logs
  Future<void> saveLogFile({
    required String scanType,
    required String data,
  }) async {
    final directory = await _logsDirectory;
    final logsPath = '${directory.path}/logs';

    final logFileName =
        'log_${scanType}_${DateTime.now().toIso8601String()}.json';

    final File file =
        await File('$logsPath/$logFileName').create(recursive: true);

    await file.writeAsString(data);
    _logger.fine('Scan results saved to directory ${file.path}');
  }

  Future<List<File>> getLogsFiles() async {
    final directory = await _logsDirectory;
    final logsDir = Directory('${directory.path}/logs');

    final files = logsDir.listSync().whereType<File>().toList();

    _logger.fine('${files.length} logs found!');

    return files;
  }

  Future<void> clearLogsDirectory() async {
    final directory = await _logsDirectory;
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

  /// configurations
  Future<void> saveConfigFile({
    required ConfigModel model,
  }) async {
    final directory = await _logsDirectory;
    final configsPath = '${directory.path}/configs';

    final configFileName =
        'config_${model.name}_${DateTime.now().toIso8601String()}.json';

    final File file =
        await File('$configsPath/$configFileName').create(recursive: true);

    print(model.toJson().toString());

    await file.writeAsString(model.toJson().toString());
    _logger
        .fine('Configuration $configFileName saved to directory ${file.path}');
  }

  Future<List<File>> getConfigFiles() async {
    final directory = await _logsDirectory;
    final logsDir = Directory('${directory.path}/configs');

    final files = logsDir.listSync().whereType<File>().toList();

    _logger.fine('${files.length} configs found!');

    return files;
  }

  Future<void> clearConfigDirectory() async {
    final directory = await _logsDirectory;
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
}
