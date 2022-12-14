import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:scanera/model/config_storage_model.dart';
import 'package:scanera/screen/configuration/configuration_details/configuration_details_screen.dart';
import 'package:scanera/screen/configuration/configuration_screen.dart';
import 'package:scanera/screen/logs/logs_details/logs_details_screen.dart';
import 'package:scanera/screen/logs/logs_screen.dart';
import 'package:scanera/screen/scan/home_screen.dart';
import 'package:scanera/screen/settings/settings_screen.dart';

@singleton
class AppRouter {
  final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/home',
    restorationScopeId: 'root_navigator',
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/config',
        name: 'config',
        builder: (BuildContext context, GoRouterState state) {
          return const ConfigScreen();
        },
      ),
      GoRoute(
        path: '/config/configDetails',
        name: 'configDetails',
        builder: (BuildContext context, GoRouterState state) {
          return ConfigDetailsScreen(
            configStorageModel: state.extra as ConfigStorageModel,
          );
        },
      ),
      GoRoute(
        path: '/logs/logDetails/:logPath',
        name: 'logDetails',
        builder: (BuildContext context, GoRouterState state) {
          return LogDetailsScreen(
            logPath: state.params["logPath"]!,
          );
        },
      ),
      GoRoute(
        path: '/logs',
        name: 'logs',
        builder: (BuildContext context, GoRouterState state) {
          return const LogsScreen();
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsScreen();
        },
      ),
    ],
  );
}
