part of 'signal_bloc.dart';

abstract class SignalState extends Equatable {
  const SignalState();

  @override
  List<Object> get props => [];
}

class SignalLoading extends SignalState {
  const SignalLoading();

  @override
  List<Object> get props => [];
}

class SignalLoaded extends SignalState {
  final List<SignalModel> signals;

  const SignalLoaded({
    this.signals = const <SignalModel>[],
  });

  @override
  List<Object> get props => [
        signals,
      ];
}
