import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scanera/model/sensor_model.dart';

@immutable
abstract class SensorState extends Equatable {
  const SensorState();

  @override
  List<Object> get props => [];
}

class SensorsLoading extends SensorState {
  const SensorsLoading();

  @override
  List<Object> get props => [];
}

class SensorsLoaded extends SensorState {
  final List<SensorModel> sensors;

  const SensorsLoaded({
    this.sensors = const <SensorModel>[],
  });

  @override
  List<Object> get props => [
        sensors,
      ];
}
