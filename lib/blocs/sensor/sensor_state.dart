import 'package:flutter/material.dart';
import 'package:scanera/model/sensor_model.dart';

@immutable
abstract class SensorState {}

class SensorsLoading extends SensorState {
  SensorsLoading();

  @override
  List<Object> get props => [];
}

class SensorsLoaded extends SensorState {
  final List<SensorModel> sensors;

  SensorsLoaded({
    this.sensors = const <SensorModel>[],
  });

  @override
  List<Object> get props => [
        sensors,
      ];
}
