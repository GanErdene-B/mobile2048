import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqflite.dart';

Future<void> initSqfliteFfi() async {
  // Initialize database factory based on platform
  try {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop: use FFI
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // On mobile, do not set databaseFactory (let sqflite use its default)
  } catch (_) {
    // initialization is best-effort; callers handle errors from DB usage
  }
}
