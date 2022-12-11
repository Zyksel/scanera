import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/model/config_model.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/util/keyboard_visibility.dart';

class ConfigDialog extends StatefulWidget {
  const ConfigDialog({
    super.key,
  });

  @override
  State<ConfigDialog> createState() => _ConfigDialogState();
}

class _ConfigDialogState extends State<ConfigDialog> {
  final TextEditingController _controller = TextEditingController();
  final FileManager _fileManager = FileManager();
  bool visible = true;

  /// TODO: IMPROVE THIS IMPLEMENTATION

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        if (isKeyboardVisible) {
          return _dialog2();
        } else {
          return _dialog();
        }
      },
      child: Container(),
    );
  }

  Widget _dialog() {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).configDialogLabel,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          visible
              ? Text(AppLocalizations.of(context).configDialogContent)
              : Text(AppLocalizations.of(context).configDialogContentShrunk),
          const SizedBox(
            height: 12,
          ),
          TextField(
            maxLines: 5,
            controller: _controller,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.kOnSurfaceVariant,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.kOnSurfaceVariant,
                  width: 1.0,
                ),
              ),
              hintText:
                  AppLocalizations.of(context).configDialogTextFieldPlaceholder,
              hintStyle: AppTypography().gray.bodyMedium,
            ),
          )
        ],
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      actionsPadding: const EdgeInsets.only(
        right: 26,
        bottom: 8,
      ),
      contentPadding: const EdgeInsets.fromLTRB(26, 16, 26, 16),
      actions: [
        TextButton(
          onPressed: () => _onAbort(),
          child: Text(
            AppLocalizations.of(context).configDialogOptionFirst,
            style: AppTypography().error.titleSmall,
          ),
        ),
        TextButton(
          onPressed: () => _onSave(),
          child: Text(
            AppLocalizations.of(context).configDialogOptionSecond,
            style: AppTypography().primary.titleSmall,
          ),
        ),
      ],
    );
  }

  Widget _dialog2() {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).configDialogLabel,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context).configDialogContentShrunk),
          const SizedBox(
            height: 12,
          ),
          TextField(
            maxLines: 5,
            controller: _controller,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r"\n")),
            ],
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.kOnSurfaceVariant,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.kOnSurfaceVariant,
                  width: 1.0,
                ),
              ),
              hintText:
                  AppLocalizations.of(context).configDialogTextFieldPlaceholder,
              hintStyle: AppTypography().gray.bodyMedium,
            ),
          )
        ],
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      actionsPadding: const EdgeInsets.only(
        right: 26,
        bottom: 8,
      ),
      contentPadding: const EdgeInsets.fromLTRB(26, 16, 26, 16),
      actions: [
        TextButton(
          onPressed: () => _onAbort(),
          child: Text(
            AppLocalizations.of(context).configDialogOptionFirst,
            style: AppTypography().error.titleSmall,
          ),
        ),
        TextButton(
          onPressed: () => _onSave(),
          child: Text(
            AppLocalizations.of(context).configDialogOptionSecond,
            style: AppTypography().primary.titleSmall,
          ),
        ),
      ],
    );
  }

  void _onSave() {
    if (_controller.text.isEmpty) return;

    final configParts =
        _controller.text.replaceAll(' ', '').split(',').toList();

    final List<CoordinatesModel> coordinates = [];

    for (int i = 1; i < configParts.length; i++) {
      coordinates.add(
        CoordinatesModel(
          x: configParts[i].substring(0, 1),
          y: configParts[i].substring(2, 3),
        ),
      );
    }

    _fileManager.saveConfigFile(
      model: ConfigModel(
        name: configParts[0],
        coords: coordinates,
      ),
    );

    Navigator.of(context).pop();
  }

  void _onAbort() {
    print("Aborting!");
    Navigator.of(context).pop();
  }
}
