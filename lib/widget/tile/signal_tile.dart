// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';

class SignalTile extends StatefulWidget {
  const SignalTile({
    Key? key,
    required this.SSID,
    required this.BSSID,
    required this.level,
  }) : super(key: key);

  final String SSID;
  final String BSSID;
  final int level;

  @override
  State<SignalTile> createState() => _SignalTileState();
}

class _SignalTileState extends State<SignalTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      title: Text(widget.SSID),
      subtitle: Text(
        widget.BSSID,
        style: AppTypography().gray.bodyMedium,
      ),
      tileColor: AppColors.kPrimary95,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      trailing: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.kWhite,
        ),
        child: Center(
          child: Text(
            widget.level.toString(),
            style: AppTypography().black.displayMedium,
          ),
        ),
      ),
    );
  }
}
