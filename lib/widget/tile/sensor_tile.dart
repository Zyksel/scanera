import 'package:flutter/material.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';

class SensorTile extends StatefulWidget {
  const SensorTile({
    required this.label,
    required this.data,
    Key? key,
  }) : super(key: key);

  final String label;
  final List<int> data;

  @override
  State<SensorTile> createState() => _SensorTileState();
}

class _SensorTileState extends State<SensorTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.kPrimary95,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(
          color: AppColors.kPrimary95,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColumnData(
                label: AppLocalizations.of(context).sensorsModeX,
                data: widget.data[0].toString(),
              ),
              _buildColumnData(
                label: AppLocalizations.of(context).sensorsModeY,
                data: widget.data[1].toString(),
              ),
              _buildColumnData(
                label: AppLocalizations.of(context).sensorsModeZ,
                data: widget.data[2].toString(),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 30,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.kPrimaryBlue,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: AppTypography().white.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnData({
    required String label,
    required String data,
  }) {
    return Column(
      children: [
        Container(
          height: 36,
          width: 48,
          decoration: const BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              data,
              style: AppTypography().black.displaySmall,
            ),
          ),
        ),
        Text(
          label,
          style: AppTypography().black.bodyLarge,
        ),
      ],
    );
  }
}
