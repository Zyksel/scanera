import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  FileManager();

  final _logger = Logger('FileManager');

  Future<Directory> get _logsDirectory => getApplicationSupportDirectory();

  Future<void> saveLogFile({
    required String scanType,
    required String data,
  }) async {
    final directory = await _logsDirectory;

    final logFileName =
        'log_${scanType}_${DateTime.now().toIso8601String()}.json';

    final File file =
        await File('${directory.path}/$logFileName').create(recursive: true);

    await file.writeAsString(data);
    _logger.fine('Scan results saved to directory ${file.path}');
  }

  Future<List<File>> getLogsFiles() async {
    final directory = await _logsDirectory;
    final files = directory.listSync().whereType<File>().toList();

    _logger.fine('${files.length} logs found!');

    return files;
  }

  Future<String> readLogContent(File log) async {
    return await log.readAsString();
  }

  Future<void> clearLogsDirectory() async {
    final directory = await _logsDirectory;

    if (!await directory.exists()) {
      return;
    }

    final filesToDelete = directory.listSync();

    for (final file in filesToDelete) {
      _logger.fine('Deleting log ${file.path}');
      await file.delete();
    }

    _logger.fine('Directory $directory cleared!');
  }
}
