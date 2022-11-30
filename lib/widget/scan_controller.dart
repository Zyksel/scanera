import 'package:flutter/material.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/widget/button.dart';
import 'package:scanera/widget/row_text.dart';

class ScanController extends StatefulWidget {
  const ScanController({
    required this.onPressedFirst,
    required this.onPressedSecond,
    required this.time,
    required this.coordinates,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressedFirst;
  final VoidCallback onPressedSecond;
  final Duration time;
  final List<int> coordinates;

  @override
  State<ScanController> createState() => _ScanControllerState();
}

class _ScanControllerState extends State<ScanController> {
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
                xCoordinate: widget.coordinates[0],
                yCoordinate: widget.coordinates[1],
              ),
              const SizedBox(
                height: 4,
              ),
              Button.primary(
                context: context,
                text: AppLocalizations.of(context).controllerButtonLabelNext,
                onPressed: widget.onPressedFirst,
                // isExpanded: true,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColumnText.timer(
                label: AppLocalizations.of(context).controllerTimeLabel,
                time: widget.time,
              ),
              const SizedBox(
                height: 4,
              ),
              Button.tertiary(
                context: context,
                text: AppLocalizations.of(context).controllerButtonLabelPause,
                onPressed: widget.onPressedSecond,
                // isExpanded: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
