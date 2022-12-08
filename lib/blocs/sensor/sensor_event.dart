import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scanera/model/sensor_model.dart';

@immutable
abstract class SensorEvent extends Equatable {
  const SensorEvent();

  @override
  List<Object> get props => [];
}

class LoadSensors extends SensorEvent {
  final List<SensorModel> sensorModel;

  const LoadSensors({
    required this.sensorModel,
  });

  @override
  List<Object> get props => [
        SensorModel,
      ];
}

class UpdateSensor extends SensorEvent {
  final List<SensorModel> sensorModels;

  const UpdateSensor({
    required this.sensorModels,
  });

  @override
  List<Object> get props => [
        sensorModels,
      ];
}

class AddSensor extends SensorEvent {
  final SensorModel sensorModel;

  const AddSensor({
    required this.sensorModel,
  });

  @override
  List<Object> get props => [
        SensorModel,
      ];
}

class RemoveSensor extends SensorEvent {
  const RemoveSensor();

  @override
  List<Object> get props => [];
}

class LoadingSensors extends SensorEvent {
  const LoadingSensors();

  @override
  List<Object> get props => [];
}
