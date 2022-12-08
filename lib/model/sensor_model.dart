import 'package:equatable/equatable.dart';

class SensorModel extends Equatable {
  const SensorModel({
    required this.x,
    required this.y,
    required this.z,
  });

  final double x;
  final double y;
  final double z;

  SensorModel copyWith({
    double? x,
    double? y,
    double? z,
  }) {
    return SensorModel(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
    );
  }

  @override
  List<Object?> get props => [
        x,
        y,
        z,
      ];
}
