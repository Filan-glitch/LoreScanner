import 'package:logging/logging.dart';
import 'package:logging_to_logcat/logging_to_logcat.dart';

final log = Logger('Lorescanner');

void setupRootLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(LogcatHandler());
}
