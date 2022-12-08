import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/manager/files_manager.dart';
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
  final FileManager _fileManager = FileManager();

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
                    onPressed: () async {
                      final result = await _showEraseFilesDialog();
                      if (result == true) eraseLogFiles();
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Button.primary(
                    context: context,
                    text: AppLocalizations.of(context)
                        .settingsButtonChangeLocation,
                    isExpanded: true,

                    /// TODO: replace function

                    onPressed: saveFileTest,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Button.primary(
                    context: context,
                    text: AppLocalizations.of(context).settingsButtonReport,
                    isExpanded: true,
                    onPressed: getFilesList,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showEraseFilesDialog() async {
    final result = await showDialog<bool>(
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

  Future<void> eraseLogFiles() async {
    await _fileManager.clearLogsDirectory();
  }

  /// TODO: move this functions to location where they should be

  Future<void> saveFileTest() async {
    const String data =
        '{"time": "00:00:01:45","data": [{"type": "bluetooth","time": "00:00:01:45","SSID": "Beacon (1)","BSID": "0a766574-ee7a-4d43-b717-7f51ccad3ff6","signal": "-50"},{"type": "bluetooth","time": "00:00:01:52","SSID": "Beacon (2)","BSID": "0a766574-ee7a-4d43-b717-7f51ccadsad1","signal": "-56"},{"type": "bluetooth","time": "00:00:02:14","SSID": "Beacon (1)","BSID": "0a766574-ee7a-4d43-b717-7f51ccad3ff6","signal": "-52"}]}';
    await _fileManager.saveLogFile(scanType: "bluetooth", data: data);
  }

  Future<void> getFilesList() async {
    final result = await _fileManager.getLogsFiles();

    for (var file in result) {
      print(await _fileManager.readLogContent(file));
      print(path.basename(file.path));
    }
  }
}
