import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/screen/logs/logs_controller.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/widget/empty_files_placeholder.dart';
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
        body: Consumer<LogsController>(
          builder: (context, controller, ___) {
            if (controller.state.logsPaths.isEmpty) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: EmptyFilesPlaceholder(
                  text: context.strings.emptyConfigsPlaceholderText,
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 36.0,
              ),
              itemCount: controller.state.logsPaths.length,
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => GoRouter.of(context).pushNamed(
                    "logDetails",
                    params: {
                      "logPath": controller.state.logsPaths[index],
                    },
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.state.logsPaths[index],
                        style: AppTypography().gray.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  thickness: 0.6,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
