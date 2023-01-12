import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/widget/button.dart';
import 'package:scanera/widget/dialog/info_dialog.dart';
import 'package:scanera/widget/page_app_bar.dart';
import 'package:scanera/widget/snack_bar_message.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FileManager _fileManager = FileManager();
  final SnackBarMessage _snackBar = SnackBarMessage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PageAppBar(
          title: AppLocalizations.of(context).appBarSettings,
          leftIcon: Icons.arrow_back,
          onLeftTap: () => GoRouter.of(context).pushNamed("home"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 36.0,
          ),
          child: Column(
            children: [
              Image.asset(
                'assets/images/scanera_logo_full.png',
                width: 220,
                height: 220,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                AppLocalizations.of(context).appVersion("1.0.0"),
                style: AppTypography().gray.labelLarge,
              ),
              const SizedBox(
                height: 16,
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
                      text:
                          AppLocalizations.of(context).settingsButtonDeleteLogs,
                      isExpanded: true,
                      onPressed: () async {
                        final result = await _showEraseLogFilesDialog();
                        if (result == true) eraseLogFiles();
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Button.primary(
                      context: context,
                      text: AppLocalizations.of(context)
                          .settingsButtonDeleteConfigs,
                      isExpanded: true,
                      onPressed: () async {
                        final result = await _showEraseConfigFilesDialog();
                        if (result == true) eraseConfigFiles();
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Button.primary(
                      context: context,
                      text: AppLocalizations.of(context).settingsButtonExport,
                      isExpanded: true,
                      onPressed: shareFiles,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showEraseLogFilesDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => InfoDialog(
        label: AppLocalizations.of(context).settingsDialogLabel,
        content: AppLocalizations.of(context).settingsDialogLogContent,
        leftOptionTitle: AppLocalizations.of(context).settingsDialogOptionFirst,
        rightOptionTitle:
            AppLocalizations.of(context).settingsDialogOptionSecond,
      ),
    );
    return result;
  }

  Future<bool?> _showEraseConfigFilesDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => InfoDialog(
        label: AppLocalizations.of(context).settingsDialogLabel,
        content: AppLocalizations.of(context).settingsDialogConfigContent,
        leftOptionTitle: AppLocalizations.of(context).settingsDialogOptionFirst,
        rightOptionTitle:
            AppLocalizations.of(context).settingsDialogOptionSecond,
      ),
    );
    return result;
  }

  Future<void> eraseLogFiles() async {
    final deletedFilesNumber = await _fileManager.clearLogsDirectory();

    if (!mounted) {
      return;
    }

    if (deletedFilesNumber == -1) {
      _snackBar.displaySnackBar(
        context: context,
        message:
            AppLocalizations.of(context).settingsSnackBarFilesEraseErrorMessage,
      );
    } else if (deletedFilesNumber == 0) {
      _snackBar.displaySnackBar(
        context: context,
        message: AppLocalizations.of(context)
            .settingsSnackBarLogEraseNotFoundMessage,
      );
    } else {
      _snackBar.displaySnackBar(
        context: context,
        message: AppLocalizations.of(context)
            .settingsSnackBarLogEraseSuccessMessage(
                deletedFilesNumber.toString()),
      );
    }
  }

  Future<void> eraseConfigFiles() async {
    final deletedFilesNumber = await _fileManager.clearConfigDirectory();

    if (!mounted) {
      return;
    }

    if (deletedFilesNumber == -1) {
      _snackBar.displaySnackBar(
        context: context,
        message:
            AppLocalizations.of(context).settingsSnackBarFilesEraseErrorMessage,
      );
    } else if (deletedFilesNumber == 0) {
      _snackBar.displaySnackBar(
        context: context,
        message: AppLocalizations.of(context)
            .settingsSnackBarConfigEraseNotFoundMessage,
      );
    } else {
      _snackBar.displaySnackBar(
        context: context,
        message: AppLocalizations.of(context)
            .settingsSnackBarConfigEraseSuccessMessage(
                deletedFilesNumber.toString()),
      );
    }
  }

  void shareFiles() async {
    final logFiles = await _fileManager.getLogsFiles();

    List<XFile> files = [];

    for (var element in logFiles) {
      files.add(XFile(element.path));
    }

    await Share.shareXFiles(files);
  }
}
