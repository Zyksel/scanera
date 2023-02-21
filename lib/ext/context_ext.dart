import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExt on BuildContext {
  AppLocalizations get strings => AppLocalizations.of(this);

  Locale get locale => Localizations.localeOf(this);

  double get systemFooterHeight {
    final mediaQueryData = MediaQuery.of(this);

    final viewPadding = mediaQueryData.viewPadding;
    final viewInsets = mediaQueryData.viewInsets;
    final bottomValue = viewPadding.bottom + viewInsets.bottom;

    return bottomValue;
  }

  EdgeInsetsGeometry systemFooterPadding() =>
      EdgeInsets.only(bottom: systemFooterHeight);
}
