import 'package:flutter/material.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';

class OptionsBottomSheet extends StatefulWidget {
  const OptionsBottomSheet({
    super.key,
    required this.onOptionTap,
    required this.options,
  });

  final Function(int index) onOptionTap;
  final List<String> options;

  @override
  State<OptionsBottomSheet> createState() => _OptionsBottomSheetState();
}

class _OptionsBottomSheetState extends State<OptionsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: widget.options.length * 56,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.options.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        widget.onOptionTap(index);
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            Text(
                              widget.options[index],
                              style: AppTypography()
                                  .primary
                                  .headlineSmall
                                  .copyWith(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: context.systemFooterHeight,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
