import 'package:bloc/bloc.dart';
import 'package:scanera/blocs/sensor/sensor_event.dart';
import 'package:scanera/blocs/sensor/sensor_state.dart';
import 'package:scanera/model/sensor_model.dart';

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  SensorBloc() : super(const SensorsLoading()) {
    on<LoadSensors>(_onLoadSensors);
    on<AddSensor>(_onAddSensor);
    on<UpdateSensor>(_onUpdateSignal);
    on<RemoveSensor>(_onRemoveSignal);
    on<LoadingSensors>(_onLoadingSensors);
  }

  void _onLoadingSensors(LoadingSensors event, Emitter<SensorState> emit) {
    emit(const SensorsLoading());
  }

  void _onLoadSensors(LoadSensors event, Emitter<SensorState> emit) {
    emit(SensorsLoaded(sensors: event.sensorModel));
  }

  void _onAddSensor(AddSensor event, Emitter<SensorState> emit) {
    final state = this.state;
    if (state is SensorsLoaded) {
      emit(SensorsLoaded(
        sensors: List.from(state.sensors)..add(event.sensorModel),
      ));
    }
  }

  void _onUpdateSignal(UpdateSensor event, Emitter<SensorState> emit) {
    final state = this.state;
    if (state is SensorsLoaded) {
      List<SensorModel> sensors = event.sensorModels;
      emit(
        SensorsLoaded(
          sensors: sensors.isEmpty ? state.sensors : sensors,
        ),
      );
    }
  }

  void _onRemoveSignal(RemoveSensor event, Emitter<SensorState> emit) {
    emit(
      const SensorsLoaded(sensors: []),
    );
  }
}
