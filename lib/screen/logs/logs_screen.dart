import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanera/widget/page_app_bar.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: 'Logs',
        leftIcon: Icons.arrow_back,
        onLeftTap: () => GoRouter.of(context).pop(),
      ),
      body: const Center(
        child: Text(
          'No tu beda logi',
        ),
      ),
    );
  }
}
