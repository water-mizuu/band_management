import 'dart:io';
import 'dart:ui';

import 'package:band_management/router.dart';
import 'package:band_management/state/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scroll_animator/scroll_animator.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:watch_it/watch_it.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// This should only run if we're running on desktop.
  if (!(kIsWeb || Platform.isAndroid || Platform.isIOS)) {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();

    await windowManager.ensureInitialized();

    const Size recommendedSize = Size(400, 700);
    const WindowOptions options = WindowOptions(
      minimumSize: recommendedSize,
      maximumSize: recommendedSize,
      size: recommendedSize,
    );

    await windowManager.waitUntilReadyToShow(options);
  }

  AppState appState = AppState();
  await appState.initialize();

  di.registerSingleton<AppState>(appState);

  runApp(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,

      /// This allows scrolling by dragging with the mouse.
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: <PointerDeviceKind>{
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),

      /// This is required for the [AnimatedScrollController] to work.
      actions: <Type, Action<Intent>>{
        ...WidgetsApp.defaultActions,
        ScrollIntent: AnimatedScrollAction(),
      },
    ),
  );
}
