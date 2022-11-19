import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/screen/screen.dart';

@singleton
class AppRouter {
  final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/home',
    routes: <GoRoute>[
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return MyHomePage(
            title: AppLocalizations.of(context).appName,
          );
        },
      ),
    ],
  );
}
