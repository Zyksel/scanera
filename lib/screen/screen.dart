import 'package:flutter/material.dart';
import 'package:scanera/theme/text/app_typography.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: AppTypography().white.headlineLarge,
        ),
      ),
      body: Center(
        child: Text(
          'Scanera',
          style: AppTypography().black.headlineLarge,
        ),
      ),
    );
  }
}
