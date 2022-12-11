import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_view/json_view.dart';
import 'package:provider/provider.dart';
import 'package:scanera/screen/configuration/configuration_details/configuration_details_controller.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/widget/page_app_bar.dart';

class ConfigDetailsScreen extends StatefulWidget {
  const ConfigDetailsScreen({
    required this.configName,
    required this.configPath,
    Key? key,
  }) : super(key: key);

  final String configName;
  final String configPath;

  @override
  State<ConfigDetailsScreen> createState() => _ConfigDetailsScreenState();
}

class _ConfigDetailsScreenState extends State<ConfigDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfigDetailsController(
        configName: widget.configPath,
      ),
      builder: (context, child) => Scaffold(
        appBar: PageAppBar(
          title: widget.configName,
          leftIcon: Icons.arrow_back,
          onLeftTap: () => GoRouter.of(context).pop(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 16.0,
          ),
          child: Consumer<ConfigDetailsController>(
            builder: (context, state, ___) => JsonConfig(
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
                json: state.state.jsonConfig,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
