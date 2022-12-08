import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/widget/page_app_bar.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<String> logs = [
    'logfilenumer1234dsf618s7f639s.json',
    'logfilenumer1234dsf618s7f639s.json',
    'logfilenumer1234dsf618s7f639s.json',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: AppLocalizations.of(context).appBarLogs,
        leftIcon: Icons.arrow_back,
        onLeftTap: () => GoRouter.of(context).pop(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 36.0,
        ),
        child: ListView.separated(
          itemCount: logs.length,
          itemBuilder: (BuildContext context, int index) {
            return TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  logs[index],
                  style: AppTypography().gray.bodyLarge,
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              thickness: 0.6,
            );
          },
        ),
      ),
    );
  }
}
