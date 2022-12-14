import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/model/config_storage_model.dart';
import 'package:scanera/screen/scan/home_screen_controller.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';

class ConfigDropdown extends StatefulWidget {
  const ConfigDropdown({
    Key? key,
    required this.configs,
  }) : super(key: key);

  final List<ConfigStorageModel> configs;

  @override
  State<ConfigDropdown> createState() => _ConfigDropdownState();
}

class _ConfigDropdownState extends State<ConfigDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (_, controller, ___) => GestureDetector(
        onTap: () {
          widget.configs.isEmpty
              ? GoRouter.of(context).pushNamed("config")
              : null;
        },
        child: DropdownButtonHideUnderline(
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
            value: controller.state.chosenConfig,
            onChanged: (value) {
              controller.chooseConfig(value as String);
              controller.getScanConfig(controller.state.configs
                  .where((element) => element.name == value)
                  .first);
            },
            hint: Text(
              AppLocalizations.of(context).dropdownPlaceholder,
              style: AppTypography().gray.bodyLarge,
            ),
            items: widget.configs
                .map((item) => DropdownMenuItem<String>(
                    value: item.name,
                    child: Text(
                      item.name,
                      style: AppTypography().gray.bodyLarge,
                    )))
                .toList(),
          ),
        ),
      ),
    );
  }
}
