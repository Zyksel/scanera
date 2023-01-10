import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/screen/configuration/configuration_controller.dart';
import 'package:scanera/theme/text/app_typography.dart';
import 'package:scanera/widget/button.dart';
import 'package:scanera/widget/dialog/configuration_dialog.dart';
import 'package:scanera/widget/empty_files_placeholder.dart';
import 'package:scanera/widget/page_app_bar.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ChangeNotifierProvider(
        create: (_) => ConfigController(),
        builder: (context, child) => Scaffold(
          appBar: PageAppBar(
            title: AppLocalizations.of(context).appBarConfig,
            leftIcon: Icons.arrow_back,
            onLeftTap: () => GoRouter.of(context).pushNamed("home"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 18.0,
            ),
            child: Consumer<ConfigController>(
              builder: (context, controller, ___) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Button.primary(
                        context: context,
                        text:
                            AppLocalizations.of(context).configButtonAddConfig,
                        isExpanded: true,
                        onPressed: () async {
                          final result = await _addConfigurationDialog();
                          if (result == true) {
                            await controller.getConfigList();
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    controller.state.configStorageModel.isNotEmpty
                        ? Expanded(
                            child: ListView.separated(
                              itemCount:
                                  controller.state.configStorageModel.length,
                              itemBuilder: (BuildContext context, int index) {
                                return TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.state
                                            .configStorageModel[index].name,
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
                                  onPressed: () =>
                                      GoRouter.of(context).pushNamed(
                                    'configDetails',
                                    extra: controller
                                        .state.configStorageModel[index],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider(
                                  thickness: 0.6,
                                );
                              },
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(
                              top: 36.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: EmptyFilesPlaceholder(
                              text: context.strings.emptyConfigsPlaceholderText,
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _addConfigurationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfigDialog(),
    );

    return result;
  }
}
