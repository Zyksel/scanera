import 'package:equatable/equatable.dart';

class SignalModel extends Equatable {
  const SignalModel({
    required this.SSID,
    required this.BSSID,
    required this.level,
  });

  final String SSID;
  final String BSSID;
  final int level;

  SignalModel copyWith({
    String? SSID,
    String? BSSID,
    int? level,
  }) {
    return SignalModel(
      SSID: SSID ?? this.SSID,
      BSSID: BSSID ?? this.BSSID,
      level: level ?? this.level,
    );
  }

  @override
  List<Object?> get props => [
        SSID,
        BSSID,
        level,
      ];
}
