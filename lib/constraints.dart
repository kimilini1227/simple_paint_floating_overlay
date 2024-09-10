import 'package:flutter/material.dart';

abstract final class Constraints{
  static const double overlayWidthRatio = 0.8;
  static const double overlayHeightRatio = 0.8;
  static const double overlayXPositionRatio = 0.1;
  static const double overlayYPositionRatio = 0.1;

  static const Color overlayWindowMainColor = Colors.yellow;
  static const Color overlayWindowSubColor = Colors.black;

  static const double overlayWindowBorderWidth = 1.0;
  static const double overlayTopBarHeight = 48.0;

  static const double overlayMinimizeButtonBorderWidth = 1.0;

  static const double overlayLowerRightEdgeWidth = 12.0;
  static const double overlayLowerRightEdgeHeight = 12.0;
}