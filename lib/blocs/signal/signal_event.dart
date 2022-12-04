part of 'signal_bloc.dart';

@immutable
abstract class SignalEvent extends Equatable {
  const SignalEvent();

  @override
  List<Object> get props => [];
}

class LoadSignals extends SignalEvent {
  final List<SignalModel> signalModel;

  const LoadSignals({
    required this.signalModel,
  });

  @override
  List<Object> get props => [
        signalModel,
      ];
}

class UpdateSignal extends SignalEvent {
  final List<SignalModel> signalModels;

  const UpdateSignal({
    required this.signalModels,
  });

  @override
  List<Object> get props => [
        signalModels,
      ];
}

class AddSignal extends SignalEvent {
  final SignalModel signalModel;

  const AddSignal({
    required this.signalModel,
  });

  @override
  List<Object> get props => [
        signalModel,
      ];
}

class RemoveSignal extends SignalEvent {
  const RemoveSignal();

  @override
  List<Object> get props => [];
}

class LoadingSignals extends SignalEvent {
  const LoadingSignals();

  @override
  List<Object> get props => [];
}
