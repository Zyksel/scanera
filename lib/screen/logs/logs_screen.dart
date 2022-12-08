import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanera/theme/text/app_typography.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 36.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'logfilenumer1234dsf618s7f639s.json',
              style: AppTypography().gray.bodyLarge,
            ),
            const SizedBox(
              height: 2,
            ),
            const Divider(
              thickness: 0.6,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'logfilenumer1234dsf618s7f639s.json',
              style: AppTypography().gray.bodyLarge,
            ),
            const SizedBox(
              height: 2,
            ),
            const Divider(
              thickness: 0.6,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'logfilenumer1234dsf618s7f639s.json',
              style: AppTypography().gray.bodyLarge,
            ),
            const SizedBox(
              height: 2,
            ),
            const Divider(
              thickness: 0.6,
            ),
          ],
        ),
      ),
    );
  }
}
