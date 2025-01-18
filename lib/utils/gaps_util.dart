// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:wan_andriod/utils/theme_util.dart';

class Decorations {
  static Decoration bottom = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        width: 0.5,
        color: ThemeUtils.getThemeData().dividerColor,
      ),
    ),
  );
}

///间隔
class GapsUtil {
  ///上下间隔 5
  static Widget gapH5 = const SizedBox(height: Dimens.gap_dp5);

  ///上下间隔 10
  static Widget gapH10 = const SizedBox(height: Dimens.gap_dp10);

  ///上下间隔 15
  static Widget gapH15 = const SizedBox(height: Dimens.gap_dp15);

  ///左右间隔 5
  static Widget gapW5 = const SizedBox(width: Dimens.gap_dp5);

  ///左右间隔 10
  static Widget gapW10 = const SizedBox(width: Dimens.gap_dp10);

  ///左右间隔 15
  static Widget gapW15 = const SizedBox(width: Dimens.gap_dp15);
}

//不知道弄两次的意义
class Dimens {
  static const double gap_dp5 = 5;
  static const double gap_dp10 = 10;
  static const double gap_dp12 = 12;
  static const double gap_dp15 = 15;
  static const double gap_dp16 = 16;
  static const double gap_dp50 = 50;
}
