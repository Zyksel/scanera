import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_view/json_view.dart';
import 'package:provider/provider.dart';
import 'package:scanera/model/config_storage_model.dart';
import 'package:scanera/screen/configuration/configuration_details/configuration_details_controller.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/widget/page_app_bar.dart';

class ConfigDetailsScreen extends StatefulWidget {
  const ConfigDetailsScreen({
    required this.configStorageModel,
    Key? key,
  }) : super(key: key);

  final ConfigStorageModel configStorageModel;

  @override
  State<ConfigDetailsScreen> createState() => _ConfigDetailsScreenState();
}

class _ConfigDetailsScreenState extends State<ConfigDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfigDetailsController(
        configName: widget.configStorageModel.path,
      ),
      builder: (context, child) => Scaffold(
        appBar: PageAppBar(
          title: widget.configStorageModel.name,
          leftIcon: Icons.arrow_back,
          onLeftTap: () => GoRouter.of(context).pop(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 16.0,
          ),
          child: Consumer<ConfigDetailsController>(
            builder: (context, controller, ___) => JsonConfig(
              data: JsonConfigData(
                gap: 100,
                style: const JsonStyleScheme(
                  openAtStart: false,
                  arrow: Icon(Icons.arrow_forward),
                  // too large depth will cause performance issue
                  depth: 2,
                ),
                color: const JsonColorScheme(
                  stringColor: AppColors.kBlack,
                ),
              ),
              child: JsonView(
                json: controller.state.jsonConfig,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
