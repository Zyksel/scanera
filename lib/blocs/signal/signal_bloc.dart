import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:scanera/model/signal_model.dart';

part 'signal_event.dart';
part 'signal_state.dart';

class SignalBloc extends Bloc<SignalEvent, SignalState> {
  SignalBloc() : super(const SignalLoaded()) {
    on<LoadSignals>(_onLoadSignals);
    on<AddSignal>(_onAddSignal);
    on<UpdateSignal>(_onUpdateSignal);
    on<RemoveSignal>(_onRemoveSignal);
  }

  void _onLoadSignals(LoadSignals event, Emitter<SignalState> emit) {
    emit(SignalLoaded(signals: event.signalModel));
  }

  void _onAddSignal(AddSignal event, Emitter<SignalState> emit) {
    final state = this.state;
    if (state is SignalLoaded) {
      emit(SignalLoaded(
        signals: List.from(state.signals)..add(event.signalModel),
      ));
    }
  }

  void _onUpdateSignal(UpdateSignal event, Emitter<SignalState> emit) {
    final state = this.state;
    if (state is SignalLoaded) {
      List<SignalModel> signals = event.signalModels;
      emit(
        SignalLoaded(signals: signals),
      );
    }
  }

  void _onRemoveSignal(RemoveSignal event, Emitter<SignalState> emit) {}
}
