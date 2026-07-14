import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/logging.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  runApp(const ProviderScope(child: LoreScannerApp()));
}
