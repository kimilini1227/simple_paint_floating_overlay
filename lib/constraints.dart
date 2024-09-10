import 'package:flutter/material.dart';

abstract final class Constraints{
  // Initial overlay's constraint ratio to full screen size.
  static const double overlayWidthRatio = 0.8;
  static const double overlayHeightRatio = 0.8;
  static const double overlayXPositionRatio = 0.1;
  static const double overlayYPositionRatio = 0.1;

  // Overlay theme color
  static const Color overlayWindowMainColor = Colors.yellow;
  static const Color overlayWindowSubColor = Colors.black;

  // Overlay window
  static const double overlayWindowBorderWidth = 1.0;
  static const double overlayWindowMinimumWidth = 250.0;
  static const double overlayWindowMinimumHeight = 50.0;

  // Overlay top bar
  static const double overlayTopBarHeight = 48.0;

  // Overlay minimize button
  static const double overlayMinimizeButtonBorderWidth = 1.0;

  // Overlay lower right edge
  static const double overlayLowerRightEdgeWidth = 12.0;
  static const double overlayLowerRightEdgeHeight = 12.0;
}