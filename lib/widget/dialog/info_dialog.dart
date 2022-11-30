import 'package:flutter/material.dart';
import 'package:scanera/theme/text/app_typography.dart';

class InfoDialog extends StatefulWidget {
  const InfoDialog({
    super.key,
    required this.label,
    this.content,
    required this.rightOptionTitle,
    required this.leftOptionTitle,
  });

  final String label;
  final String? content;
  final String rightOptionTitle;
  final String leftOptionTitle;

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.label,
      ),
      content: widget.content != null
          ? Text(
              widget.content!,
              style: AppTypography().gray.bodyLarge,
            )
          : null,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      contentPadding: const EdgeInsets.fromLTRB(26, 16, 26, 16),
      actions: [
        TextButton(
          onPressed: () => _onLeft(),
          child: Text(
            widget.leftOptionTitle,
            style: AppTypography().error.titleSmall,
          ),
        ),
        TextButton(
          onPressed: () => _onRight(),
          child: Text(
            widget.rightOptionTitle,
            style: AppTypography().primary.titleSmall,
          ),
        ),
      ],
    );
  }

  void _onLeft() {
    Navigator.of(context).pop(false);
  }

  void _onRight() {
    Navigator.of(context).pop(true);
  }
}
