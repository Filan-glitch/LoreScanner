import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final Logger log = Logger('LoreScanner');

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // debugPrint reaches the `flutter run` console; developer.log only
    // shows up in DevTools.
    if (kDebugMode) {
      debugPrint('[${record.level.name}] ${record.message}'
          '${record.error != null ? ' | ${record.error}' : ''}');
    }
    developer.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
}
