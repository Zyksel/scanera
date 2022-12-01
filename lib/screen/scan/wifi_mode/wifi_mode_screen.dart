import 'package:flutter/material.dart';

class WifiModeScreen extends StatefulWidget {
  const WifiModeScreen({Key? key}) : super(key: key);

  @override
  State<WifiModeScreen> createState() => _WifiModeScreenState();
}

class _WifiModeScreenState extends State<WifiModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'wifi mode',
        ),
      ),
    );
  }
}
