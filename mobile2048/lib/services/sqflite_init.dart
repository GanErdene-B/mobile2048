// This file conditionally selects the correct implementation for initializing
// sqflite_common_ffi so importing it on web does not pull in desktop-only code.
import 'sqflite_init_io.dart' if (dart.library.html) 'sqflite_init_stub.dart' as impl;

Future<void> initSqfliteFfi() => impl.initSqfliteFfi();
