import 'package:flutter/material.dart';

class SensorsModeScreen extends StatefulWidget {
  const SensorsModeScreen({Key? key}) : super(key: key);

  @override
  State<SensorsModeScreen> createState() => _SensorsModeScreenState();
}

class _SensorsModeScreenState extends State<SensorsModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'sensors mode',
        ),
      ),
    );
  }
}
