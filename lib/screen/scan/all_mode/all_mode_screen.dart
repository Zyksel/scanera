import 'package:flutter/material.dart';

class AllModeScreen extends StatefulWidget {
  const AllModeScreen({Key? key}) : super(key: key);

  @override
  State<AllModeScreen> createState() => _AllModeScreenState();
}

class _AllModeScreenState extends State<AllModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'all mode',
        ),
      ),
    );
  }
}
