import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> initSqfliteFfi() async {
  // Only run on desktop platforms
  try {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  } catch (_) {
    // initialization is best-effort; callers handle errors from DB usage
  }
}
