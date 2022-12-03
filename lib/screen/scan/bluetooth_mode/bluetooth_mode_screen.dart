import 'package:flutter/material.dart';

class BluetoothModeScreen extends StatefulWidget {
  const BluetoothModeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BluetoothModeScreen> createState() => _BluetoothModeScreenState();
}

class _BluetoothModeScreenState extends State<BluetoothModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'bluetooth mode',
        ),
      ),
    );
  }
}
