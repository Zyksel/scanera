import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

final _levelEmojiMapper = {
  Level.CONFIG: '⚙️',
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
};

String _getLogRecordPrintMessage(LogRecord record) => '${record.time} '
    '[${_levelEmojiMapper[record.level] ?? record.level.name}] '
    '[${record.loggerName}] '
    '${record.message} ';

void _printLogRecord(LogRecord record) {
  debugPrint(_getLogRecordPrintMessage(record));

  if (record.error != null) {
    debugPrint(record.error.toString());
  }

  if (record.stackTrace != null) {
    debugPrintStack(stackTrace: record.stackTrace);
  }
}

@singleton
class LoggerManager {
  LoggerManager();

  StreamSubscription<LogRecord>? _logsSub;
  bool _print = false;

  Future<void> init(
    Level level, {
    bool print = true,
    bool recordErrors = false,
  }) async {
    Logger.root.level = level;
    _print = print;
    _logsSub = Logger.root.onRecord.listen(_onRecord);
  }

  @disposeMethod
  void dispose() {
    _logsSub?.cancel();
    _logsSub = null;
    Logger.root.clearListeners();
  }

  void _onRecord(LogRecord logRecord) {
    if (_print) {
      _printLogRecord(logRecord);
    }
  }
}
