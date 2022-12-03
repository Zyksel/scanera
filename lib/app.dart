import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanera/blocs/signal/signal_bloc.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/navigation/app_router.dart';
import 'package:scanera/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.appRouterInstance,
  });

  final AppRouter appRouterInstance;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignalBloc()),
      ],
      child: _buildApp(context),
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
