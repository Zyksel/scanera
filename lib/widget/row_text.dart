import 'package:flutter/material.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/text/app_typography.dart';

class ColumnText extends StatefulWidget {
  const ColumnText({
    Key? key,
    required this.label,
    this.time,
    this.xCoordinate,
    this.yCoordinate,
  }) : super(key: key);

  const ColumnText.coordinate({
    Key? key,
    required this.label,
    this.time,
    required this.xCoordinate,
    required this.yCoordinate,
  }) : super(key: key);

  const ColumnText.timer({
    Key? key,
    required this.label,
    required this.time,
    this.xCoordinate,
    this.yCoordinate,
  }) : super(key: key);

  final String label;
  final Duration? time;
  final int? xCoordinate;
  final int? yCoordinate;

  @override
  State<ColumnText> createState() => _ColumnTextState();
}

class _ColumnTextState extends State<ColumnText> {
  String formattedDurationTime(Duration time, BuildContext context) {
    final minutes = "${time.inMinutes.remainder(60)}";
    final seconds = time.inSeconds.remainder(60) < 10
        ? "0${time.inSeconds.remainder(60)}"
        : "${time.inSeconds.remainder(60)}";
    return AppLocalizations.of(context).controllerTime(
      minutes,
      seconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: AppTypography().black.titleMedium,
          ),
          widget.time == null
              ? Text(
                  AppLocalizations.of(context).controllerCoordinates(
                    widget.xCoordinate.toString(),
                    widget.yCoordinate.toString(),
                  ),
                  style: AppTypography().black.titleMedium,
                )
              : Text(
                  formattedDurationTime(widget.time!, context),
                  style: AppTypography().black.titleMedium,
                ),
        ],
      ),
    );
  }
}
