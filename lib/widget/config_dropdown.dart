import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/manager/files_manager.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';

class ConfigDropdown extends StatefulWidget {
  const ConfigDropdown({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigDropdown> createState() => _ConfigDropdownState();
}

class _ConfigDropdownState extends State<ConfigDropdown> {
  final FileManager _fileManager = FileManager();
  List<String> _configs = [];
  String? selectedValue;

  @override
  void initState() {
    fetchConfigs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        buttonPadding: const EdgeInsets.only(
          top: 12,
          right: 12,
          left: 16,
          bottom: 8,
        ),
        buttonHeight: 50,
        buttonWidth: 300,
        itemHeight: 40,
        icon: const Icon(
          Icons.arrow_drop_down,
        ),
        iconSize: 32,
        offset: const Offset(0, -6),
        buttonSplashColor: AppColors.kPrimary95,
        buttonHighlightColor: AppColors.kPrimary95,
        buttonDecoration: const BoxDecoration(
          color: AppColors.kPrimary95,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        dropdownElevation: 0,
        dropdownDecoration: const BoxDecoration(
          color: AppColors.kPrimary95,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
        },
        hint: Text(
          AppLocalizations.of(context).dropdownPlaceholder,
          style: AppTypography().gray.bodyLarge,
        ),
        items: _configs
            .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: AppTypography().gray.bodyLarge,
                )))
            .toList(),
      ),
    );
  }

  Future<void> fetchConfigs() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final configs = await _fileManager.getConfigFiles();
      for (final file in configs) {
        final configName = path.basename(file.path).split('_');
        _configs.add(configName[1]);
      }
    });
  }
}
