import 'package:concentrador_delpim/app/core/ui/extensions/color_ex.dart';
import 'package:flutter/material.dart';

extension ThemeEx on BuildContext {
  Color get primaryColor => Theme.of(this).brightness == Brightness.light ? ColorEx.primaryLight : ColorEx.primaryDark;
  Color get secondaryColor =>
      Theme.of(this).brightness == Brightness.light ? ColorEx.secondaryLight : ColorEx.secondaryDark;
  Color get tertiaryColor =>
      Theme.of(this).brightness == Brightness.light ? ColorEx.tertiaryLight : ColorEx.tertiaryDark;
  Color get alternateColor =>
      Theme.of(this).brightness == Brightness.light ? ColorEx.alternateLight : ColorEx.alternateDark;
  Color get primaryBackgroundColor =>
      Theme.of(this).brightness == Brightness.light ? ColorEx.primaryBackgroundLight : ColorEx.primaryBackgroundDark;
  Color get secondaryBackgroundColor => Theme.of(this).brightness == Brightness.light
      ? ColorEx.secondaryBackgroundLight
      : ColorEx.secondaryBackgroundDark;
  Color get primaryTextColor =>
      Theme.of(this).brightness == Brightness.light ? ColorEx.primaryTextLight : ColorEx.primaryTextLight;
  Color get secondaryTextColor =>
      Theme.of(this).brightness == Brightness.light ? ColorEx.secondaryTextLight : ColorEx.secondaryTextDark;
}
