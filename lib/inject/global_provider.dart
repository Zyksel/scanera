import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanera/inject/dependency_injection.dart';

class GlobalProvider extends StatelessWidget {
  const GlobalProvider({
    super.key,
    required this.dependencyInjection,
    required this.builder,
  });

  final DependencyInjection dependencyInjection;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final providers = dependencyInjection.providers();

    if (providers.isEmpty) {
      return builder(context);
    }

    return MultiProvider(
      key: const ValueKey('GlobalMultiProvider'),
      providers: providers,
      child: Builder(builder: builder),
    );
  }
}
