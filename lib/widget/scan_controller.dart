import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/widget/button.dart';
import 'package:scanera/widget/row_text.dart';
import 'package:scanera/widget/snack_bar_message.dart';

class ScanController extends StatefulWidget {
  const ScanController({
    required this.onPressedSecond,
    required this.coordinates,
    required this.passCoordinates,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPressedSecond;
  final Function passCoordinates;
  final List<List<int>> coordinates;

  @override
  State<ScanController> createState() => _ScanControllerState();
}

class _ScanControllerState extends State<ScanController> {
  int cordIndex = 0;
  Timer? _durationTimer;
  Duration _duration = Duration.zero;
  bool _isScanRunning = true;
  final _snackBar = SnackBarMessage();

  @override
  void initState() {
    startTimer();
    widget.passCoordinates(widget.coordinates[0]);
    super.initState();
  }

  void startTimer() {
    _durationTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    if (mounted) {
      setState(() {
        final seconds = _duration.inSeconds + 1;
        _duration = Duration(seconds: seconds);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: AppColors.kPrimary90,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColumnText.coordinate(
                label: AppLocalizations.of(context).controllerCoordinatesLabel,
                xCoordinate: widget.coordinates[cordIndex][0],
                yCoordinate: widget.coordinates[cordIndex][1],
              ),
              const SizedBox(
                height: 4,
              ),
              Button.primary(
                context: context,
                text: AppLocalizations.of(context).controllerButtonLabelNext,
                onPressed: () {
                  if (widget.coordinates.length != cordIndex + 1) {
                    setState(() {
                      cordIndex += 1;
                    });
                    widget.passCoordinates(widget.coordinates[cordIndex]);
                  } else {
                    _snackBar.displaySnackBar(
                      context: context,
                      message: AppLocalizations.of(context).errorNoMorePlaces,
                      warningStyle: true,
                    );
                  }
                },
                // isExpanded: true,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColumnText.timer(
                label: AppLocalizations.of(context).controllerTimeLabel,
                time: _duration,
              ),
              const SizedBox(
                height: 4,
              ),
              Button.tertiary(
                context: context,
                text: _isScanRunning
                    ? AppLocalizations.of(context).controllerButtonLabelPause
                    : AppLocalizations.of(context).controllerButtonLabelResume,
                onPressed: () {
                  widget.onPressedSecond();
                  _isScanRunning ? _durationTimer?.cancel() : startTimer();
                  setState(() {
                    _isScanRunning = !_isScanRunning;
                  });
                },
                // isExpanded: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
