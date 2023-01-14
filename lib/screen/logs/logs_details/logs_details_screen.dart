import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_view/json_view.dart';
import 'package:provider/provider.dart';
import 'package:scanera/screen/logs/logs_details/logs_details_controller.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/widget/page_app_bar.dart';

class LogDetailsScreen extends StatefulWidget {
  const LogDetailsScreen({
    required this.logPath,
    Key? key,
  }) : super(key: key);

  final String logPath;

  @override
  State<LogDetailsScreen> createState() => _LogDetailsScreenState();
}

class _LogDetailsScreenState extends State<LogDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LogsDetailsController(
        logName: widget.logPath,
      ),
      builder: (context, child) => Scaffold(
        appBar: PageAppBar(
          title: widget.logPath,
          leftIcon: Icons.arrow_back,
          onLeftTap: () => GoRouter.of(context).pop(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 16.0,
          ),
          child: Consumer<LogsDetailsController>(
            builder: (context, state, ___) => JsonConfig(
              data: JsonConfigData(
                gap: 100,
                style: const JsonStyleScheme(
                  openAtStart: false,
                  arrow: Icon(Icons.arrow_forward),
                  depth: 2,
                ),
                color: const JsonColorScheme(
                  stringColor: AppColors.kBlack,
                ),
              ),
              child: JsonView(
                json: state.state.jsonConfig,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
