import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/widget/button.dart';
import 'package:scanera/widget/dialog/info_dialog.dart';
import 'package:scanera/widget/page_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: AppLocalizations.of(context).appBarSettings,
        leftIcon: Icons.arrow_back,
        onLeftTap: () => GoRouter.of(context).pop(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 36.0,
        ),
        child: Column(
          children: [
            Container(
              color: Colors.red,
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              AppLocalizations.of(context).appVersion("1.0.0"),
              style: AppTypography().gray.labelLarge,
            ),
            const SizedBox(
              height: 32,
            ),
            const Divider(
              thickness: 1,
              color: AppColors.kBlack,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Column(
                children: [
                  Button.primary(
                    context: context,
                    text: AppLocalizations.of(context).settingsButtonDeleteLogs,
                    isExpanded: true,
                    onPressed: _showEraseFilesDialog,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Button.primary(
                    context: context,
                    text: AppLocalizations.of(context)
                        .settingsButtonChangeLocation,
                    isExpanded: true,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Button.primary(
                    context: context,
                    text: AppLocalizations.of(context).settingsButtonReport,
                    isExpanded: true,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEraseFilesDialog() async {
    final result = await showDialog<void>(
      context: context,
      builder: (_) => InfoDialog(
        label: AppLocalizations.of(context).settingsDialogLabel,
        content: AppLocalizations.of(context).settingsDialogContent,
        leftOptionTitle: AppLocalizations.of(context).settingsDialogOptionFirst,
        rightOptionTitle:
            AppLocalizations.of(context).settingsDialogOptionSecond,
      ),
    );
    return result;
  }
}
