import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/widget/button.dart';
import 'package:scanera/widget/dialog/configuration_dialog.dart';
import 'package:scanera/widget/page_app_bar.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  List<String> configs = [
    "Configuration 1",
    "Configuration 2",
    "Configuration 3",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: AppLocalizations.of(context).appBarConfig,
        leftIcon: Icons.arrow_back,
        onLeftTap: () => GoRouter.of(context).pop(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 18.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Button.primary(
                context: context,
                text: AppLocalizations.of(context).configButtonAddConfig,
                isExpanded: true,
                onPressed: _addConfigurationDialog,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: configs.length,
                itemBuilder: (BuildContext context, int index) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        configs[index],
                        style: AppTypography().gray.bodyLarge,
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
          ],
        ),
      ),
    );
  }

  Future<void> _addConfigurationDialog() async {
    final result = await showDialog<void>(
      context: context,
      builder: (_) => const ConfigDialog(),
    );
    return result;
  }
}
