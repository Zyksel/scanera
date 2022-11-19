import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/single_child_widget.dart';
import 'package:scanera/inject/dependency_injection.config.dart';

abstract class DependencyInjection {
  bool get isInitialized;

  Future<void> init();

  T get<T extends Object>();

  List<SingleChildWidget> providers();
}

class DependencyInjectionImpl implements DependencyInjection {
  DependencyInjectionImpl(this._getIt);

  final GetIt _getIt;

  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    await _initializeGetIt(
      _getIt,
      dependencyInjection: this,
    );

    _isInitialized = true;
  }

  @override
  T get<T extends Object>() {
    assert(
      _isInitialized,
      '$runtimeType is not initialized yet! Call, and await, init() first!',
    );
    assert(_getIt.isRegistered<T>(), 'Type $T is not registered!');

    return _getIt.get<T>();
  }

  @override
  List<SingleChildWidget> providers() {
    assert(
      _isInitialized,
      '$runtimeType is not initialized yet! Call, and await, init() first!',
    );

    return [
      // Provider.value(value: _getIt.get<FilesManager>()),
    ];
  }
}

@InjectableInit(
  ignoreUnregisteredTypes: [
    DependencyInjection,
  ],
)
Future<void> _initializeGetIt(
  GetIt getIt, {
  required DependencyInjection dependencyInjection,
}) async {
  await getIt.reset();

  getIt.registerSingleton(dependencyInjection);

  $initGetIt(getIt);

  await getIt.allReady();
}
