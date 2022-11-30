import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:scanera/theme/text/app_typography.dart';

const int _defaultElevation = 0;
const double _defaultCornerRadius = 16;
const double _defaultHeight = 56;

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.text,
    this.textStyle,
    this.height,
    this.width,
    this.onPressed,
    required this.isEnabled,
    this.color,
    this.padding,
    this.shape,
    this.coloredShadow,
    this.elevation,
    required this.highlightElevation,
  });

  Button.primary({
    super.key,
    required BuildContext context,
    required this.text,
    double cornerRadius = _defaultCornerRadius,
    bool isExpanded = false,
    this.elevation = _defaultElevation,
    this.coloredShadow = false,
    this.onPressed,
    this.padding = const EdgeInsets.all(8),
    this.isEnabled = true,
  })  : height = _defaultHeight,
        highlightElevation = 8,
        width = isExpanded
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.43,
        color = Theme.of(context).colorScheme.primaryContainer,
        textStyle = AppTypography().white.titleMedium,
        shape = SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: cornerRadius,
            cornerSmoothing: 1,
          ),
          side: BorderSide.none,
        );

  Button.tertiary({
    super.key,
    required BuildContext context,
    required this.text,
    double cornerRadius = _defaultCornerRadius,
    bool isExpanded = false,
    this.elevation = _defaultElevation,
    this.coloredShadow = false,
    this.onPressed,
    this.padding = const EdgeInsets.all(8),
    this.isEnabled = true,
  })  : height = _defaultHeight,
        highlightElevation = 8,
        width = isExpanded
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.43,
        color = Theme.of(context).colorScheme.onErrorContainer,
        textStyle = AppTypography().white.titleMedium,
        shape = SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: cornerRadius,
            cornerSmoothing: 1,
          ),
          side: BorderSide.none,
        );

  final String? text;
  final TextStyle? textStyle;
  final double? height;
  final double? width;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final SmoothRectangleBorder? shape;
  final bool? coloredShadow;
  final int? elevation;
  final double highlightElevation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: MaterialButton(
        height: height,
        minWidth: 0,
        elevation: 0,
        onPressed: isEnabled ? onPressed : null,
        color: color,
        disabledColor: Theme.of(context).colorScheme.secondaryContainer,
        padding: padding,
        shape: shape,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          text ?? '',
          style: textStyle ??
              textTheme.caption?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
