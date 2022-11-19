import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:scanera/app.dart';
import 'package:scanera/inject/dependency_injection.dart';
import 'package:scanera/manager/logger_manager.dart';
import 'package:scanera/navigation/app_router.dart';

Future<void> startApplication() async {
  WidgetsFlutterBinding.ensureInitialized()
      .renderView
      .automaticSystemUiAdjustment = false;

  runZonedGuarded(
    () async {
      runApp(await _prepareApplication());
    },
    (error, stack) {
      Logger('AppZoneLogger').warning('App Zone Error', error, stack);
    },
  );
}

Future<Widget> _prepareApplication() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

  final dependencyInjection = DependencyInjectionImpl(GetIt.I);
  await dependencyInjection.init();

  const isDebugMode = true;

  final router = dependencyInjection.get<AppRouter>();
  final loggerManager = dependencyInjection.get<LoggerManager>();

  await loggerManager.init(
    Level.ALL,
    print: isDebugMode,
    recordErrors: true,
  );

  EquatableConfig.stringify = true;

  return App(
    appRouterInstance: router,
    dependencyInjection: dependencyInjection,
  );
}
