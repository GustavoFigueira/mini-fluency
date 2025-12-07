import 'package:flutter/material.dart';

/// Fluency Academy spacing system using 4px base unit
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double massive = 48;
  static const double giant = 64;

  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets horizontalXXL = EdgeInsets.symmetric(horizontal: xxl);

  static const EdgeInsets verticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets verticalXXL = EdgeInsets.symmetric(vertical: xxl);

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: lg,
  );

  static const double borderRadiusSM = 8;
  static const double borderRadiusMD = 12;
  static const double borderRadiusLG = 16;
  static const double borderRadiusXL = 20;
  static const double borderRadiusXXL = 24;
  static const double borderRadiusFull = 999;

  static const SizedBox gapXXS = SizedBox(width: xxs, height: xxs);
  static const SizedBox gapXS = SizedBox(width: xs, height: xs);
  static const SizedBox gapSM = SizedBox(width: sm, height: sm);
  static const SizedBox gapMD = SizedBox(width: md, height: md);
  static const SizedBox gapLG = SizedBox(width: lg, height: lg);
  static const SizedBox gapXL = SizedBox(width: xl, height: xl);
  static const SizedBox gapXXL = SizedBox(width: xxl, height: xxl);
  static const SizedBox gapXXXL = SizedBox(width: xxxl, height: xxxl);

  static const SizedBox horizontalGapXS = SizedBox(width: xs);
  static const SizedBox horizontalGapSM = SizedBox(width: sm);
  static const SizedBox horizontalGapMD = SizedBox(width: md);
  static const SizedBox horizontalGapLG = SizedBox(width: lg);
  static const SizedBox horizontalGapXL = SizedBox(width: xl);

  static const SizedBox verticalGapXS = SizedBox(height: xs);
  static const SizedBox verticalGapSM = SizedBox(height: sm);
  static const SizedBox verticalGapMD = SizedBox(height: md);
  static const SizedBox verticalGapLG = SizedBox(height: lg);
  static const SizedBox verticalGapXL = SizedBox(height: xl);
  static const SizedBox verticalGapXXL = SizedBox(height: xxl);
}
