import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/screen/configuration/configuration_controller.dart';
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfigController(),
      builder: (context, child) => Scaffold(
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
          child: Consumer<ConfigController>(
            builder: (context, state, ___) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Button.primary(
                    context: context,
                    text: AppLocalizations.of(context).configButtonAddConfig,
                    isExpanded: true,
                    onPressed: () async {
                      _addConfigurationDialog();
                      await state.getConfigList();
                    },
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: state.state.configFiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            state.state.configFiles[index],
                            style: AppTypography().gray.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onPressed: () {
                          GoRouter.of(context).goNamed('config/configDetails');
                        },
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
