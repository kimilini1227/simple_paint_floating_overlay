import 'package:flutter/material.dart';

abstract final class Constraints{
  // Application General Information
  static const String applicationTitle = 'Simple Paint Floating Overlay';

  // App top bar
  static const double appTopBarElevation = 2.0;

  // Setting color
  static const List<Color> settingColorList =  [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.black,
    Colors.white,
    Colors.transparent,
  ];
  static const double settingColorButtonWidth = 32.0;
  static const double settingColorButtonHeight = 32.0;
  static const double settingColorButtonIconWidth = 24.0;
  static const double settingColorButtonIconHeight = 24.0;
  static const double settingColorButtonBorderWidth = 1.0;
  static const Color settingColorButtonBorderColor = Colors.black;

  // Initial overlay's constraint ratio to full screen size.
  static const double overlayWidthRatio = 0.8;
  static const double overlayHeightRatio = 0.8;
  static const double overlayXPositionRatio = 0.1;
  static const double overlayYPositionRatio = 0.1;

  // Overlay color
  static const Color overlayWindowMainColor = Colors.yellow;
  static const String overlayWindowMainColorText = 'Main color';
  static const Color overlayWindowSubColor = Colors.black;
  static const String overlayWindowSubColorText = 'Sub color';
  static const Color overlayWindowCanvasColor = Colors.transparent;
  static const String overlayWindowCanvasColorText = 'Canvas color';

  // Overlay window
  static const double overlayWindowBorderWidth = 1.0;
  static const double overlayWindowMinimumWidth = 250.0;
  static const double overlayWindowMinimumHeight = 51.0;

  // Overlay top bar
  static const double overlayTopBarHeight = 48.0;
  static const double overlayUndoButtonBorderWidth = 1.0;
  static const double overlayRedoButtonBorderWidth = 1.0;
  static const double overlayClearButtonBorderWidth = 1.0;
  static const double overlayMinimizeButtonBorderWidth = 1.0;

  // Overlay lower right edge
  static const double overlayLowerRightEdgeWidth = 12.0;
  static const double overlayLowerRightEdgeHeight = 12.0;

  // Overlay canvas
  static const Color overlayCanvasPenColor = Colors.black;
  static const String overlayCanvasPenColorText = 'Pen color';
  static const double overlayCanvasPenWidth = 5.0;
}