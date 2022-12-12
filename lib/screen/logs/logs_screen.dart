import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/screen/logs/logs_controller.dart';
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
    return ChangeNotifierProvider(
      create: (_) => LogsController(),
      builder: (context, child) => Scaffold(
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
          child: Consumer<LogsController>(
            builder: (context, state, ___) => ListView.separated(
              itemCount: state.state.logsPaths.length,
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => GoRouter.of(context).pushNamed(
                    "logDetails",
                    params: {
                      "logPath": state.state.logsPaths[index],
                    },
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      state.state.logsPaths[index],
                      style: AppTypography().gray.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
        ),
      ),
    );
  }
}
