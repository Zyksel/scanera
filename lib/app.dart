import 'package:flutter/material.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/inject/dependency_injection.dart';
import 'package:scanera/inject/global_provider.dart';
import 'package:scanera/navigation/app_router.dart';
import 'package:scanera/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.appRouterInstance,
    required this.dependencyInjection,
  });

  final AppRouter appRouterInstance;
  final DependencyInjection dependencyInjection;

  @override
  Widget build(BuildContext context) {
    return GlobalProvider(
      dependencyInjection: dependencyInjection,
      builder: _buildApp,
    );
  }

  Widget _buildApp(
    BuildContext context,
  ) {
    final light = ThemeFactory().create();

    const mode = ThemeMode.light;

    final appRouter = appRouterInstance.router;

    return MaterialApp.router(
      onGenerateTitle: (context) => context.strings.appName,
      theme: light.materialThemeData,
      themeMode: mode,
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'root',
    );
  }
}
