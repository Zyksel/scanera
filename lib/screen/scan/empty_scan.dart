import 'package:flutter/material.dart';

class EmptyScanScreen extends StatefulWidget {
  const EmptyScanScreen({Key? key}) : super(key: key);

  @override
  State<EmptyScanScreen> createState() => _EmptyScanScreenState();
}

class _EmptyScanScreenState extends State<EmptyScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Start the scan!',
        ),
      ),
    );
  }
}
