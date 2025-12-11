import 'package:flutter/material.dart';
import 'package:mobile2048/theme/app_theme.dart';
import 'app_router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile2048/services/sqflite_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize sqlite/ffi on desktop platforms (no-op on web/mobile)
  try {
    await initSqfliteFfi();
  } catch (e) {
    // initialization failed — continue; DatabaseHelper will surface errors if used incorrectly
    debugPrint('sqflite init error: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048 Game',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: AppRouter.routes,
    );
  }
}
