import 'package:auto_size_text/auto_size_text.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:scanera/theme/color/app_colors.dart';
import 'package:scanera/theme/text/app_typography.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PageAppBar({
    super.key,
    required this.title,
    required this.leftIcon,
    this.rightIcon,
    required this.onLeftTap,
    this.onRightIconTap,
    this.isFileView = false,
  });

  final String title;
  final IconData? rightIcon;
  final IconData? leftIcon;
  final Function()? onRightIconTap;
  final Function()? onLeftTap;
  final bool isFileView;

  @override
  Widget build(BuildContext context) {
    return ClipSmoothRect(
      radius: const SmoothBorderRadius.only(
        bottomLeft: SmoothRadius(
          cornerRadius: 20,
          cornerSmoothing: 1,
        ),
        bottomRight: SmoothRadius(
          cornerRadius: 20,
          cornerSmoothing: 1,
        ),
      ),
      child: Container(
        color: AppColors.kPrimaryBlue,
        child: SafeArea(
          child: Container(
            height: 74,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: onLeftTap,
                  child: SizedBox(
                    width: rightIcon != null ? 80 : 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        leftIcon,
                        size: 30,
                        color: AppColors.kWhite,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: AutoSizeText(
                        title,
                        style: AppTypography().white.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 28,
                        minFontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: rightIcon != null ? 80 : 40,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: rightIcon != null
                        ? InkWell(
                            onTap: onRightIconTap,
                            child: Icon(
                              rightIcon,
                              size: 30,
                              color: AppColors.kWhite,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
