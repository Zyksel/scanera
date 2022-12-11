import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:scanera/screen/configuration/configuration_details/configuration_details_screen.dart';
import 'package:scanera/screen/configuration/configuration_screen.dart';
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
        path: '/config/configDetails/:configPath/:configName',
        name: 'configDetails',
        builder: (BuildContext context, GoRouterState state) {
          return ConfigDetailsScreen(
            configPath: state.params["configPath"]!,
            configName: state.params["configName"]!,
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
      // ShellRoute(
      //   builder: (context, state, child) {
      //     final tabs = [
      //       ScaffoldWithNavBarTabItem(
      //         initialLocation: '/bluetooth',
      //         icon: const Icon(Icons.bluetooth),
      //         activeIcon: const Icon(Icons.bluetooth),
      //         label: AppLocalizations.of(context).navBarBluetooth,
      //         type: TabBarItemType.bluetooth,
      //       ),
      //       if (Platform.isAndroid)
      //         ScaffoldWithNavBarTabItem(
      //           initialLocation: '/wifi',
      //           icon: const Icon(Icons.wifi),
      //           activeIcon: const Icon(Icons.wifi),
      //           label: AppLocalizations.of(context).navBarWifi,
      //           type: TabBarItemType.wifi,
      //         ),
      //       ScaffoldWithNavBarTabItem(
      //         initialLocation: '/sensors',
      //         icon: const Icon(Icons.edgesensor_high),
      //         activeIcon: const Icon(Icons.edgesensor_high),
      //         label: AppLocalizations.of(context).navBarSensors,
      //         type: TabBarItemType.sensors,
      //       ),
      //       ScaffoldWithNavBarTabItem(
      //         initialLocation: '/all',
      //         icon: const Icon(Icons.perm_scan_wifi),
      //         activeIcon: const Icon(Icons.perm_scan_wifi),
      //         label: AppLocalizations.of(context).navBarAllScan,
      //         type: TabBarItemType.allScan,
      //       ),
      //     ];
      //
      //     return ScaffoldWithBottomNavBar(tabs: tabs, child: child);
      //   },
      //   routes: [
      //     GoRoute(
      //       path: '/bluetooth',
      //       name: 'bluetooth',
      //       builder: (BuildContext context, GoRouterState state) {
      //         return BluetoothModeScreen();
      //       },
      //     ),
      //     GoRoute(
      //       path: '/wifi',
      //       name: 'wifi',
      //       builder: (BuildContext context, GoRouterState state) {
      //         return WifiModeScreen();
      //       },
      //     ),
      //     GoRoute(
      //       path: '/sensors',
      //       name: 'sensors',
      //       builder: (BuildContext context, GoRouterState state) {
      //         return SensorsModeScreen();
      //       },
      //     ),
      //     GoRoute(
      //       path: '/all',
      //       name: 'all',
      //       builder: (BuildContext context, GoRouterState state) {
      //         return AllModeScreen();
      //       },
      //     ),
      //   ],
      // )
    ],
  );
}
