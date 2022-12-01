import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/widget/options_bottom_sheet.dart';

class BluetoothModeScreen extends StatefulWidget {
  const BluetoothModeScreen({Key? key}) : super(key: key);

  @override
  State<BluetoothModeScreen> createState() => _BluetoothModeScreenState();
}

class _BluetoothModeScreenState extends State<BluetoothModeScreen> {
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'bluetooth modeaaaasdasdasdasdasdasdasdasdasd',
        ),
      ),
    );
  }

  Future<void> openOptions() async {
    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (BuildContext context) => OptionsBottomSheet(
        onOptionTap: (int index) => GoRouter.of(context).pushNamed('logs'),
        options: [
          AppLocalizations.of(context).homeBottomSheetOptionFirst,
          AppLocalizations.of(context).homeBottomSheetOptionSecond,
          AppLocalizations.of(context).homeBottomSheetOptionThird,
        ],
      ),
    );
  }

  void toggleScan() {
    setState(() {
      isScanning = !isScanning;
    });
  }
}
