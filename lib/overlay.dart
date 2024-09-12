import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:simple_paint_floating_overlay/constraints.dart';
import 'package:simple_paint_floating_overlay/painter.dart';

class OverlayController with ChangeNotifier {
  final PaintController paintController = PaintController();
  int currentWidth = 0;
  int currentHeight = 0;
  int previousWidth = 0;
  int previousHeight = 0;
  Color mainColor = Constraints.overlayWindowMainColor;
  Color subColor = Constraints.overlayWindowSubColor;
  Color canvasColor = Constraints.overlayWindowCanvasColor;
  Color penColor = Constraints.overlayCanvasPenColor;
  bool currentEnableDrag = false;
  bool isMinimize = false;

  OverlayController._internal() {
    FlutterOverlayWindow.overlayListener.listen((data) {
      currentWidth = data['width'] ?? currentWidth;
      currentHeight = data['height'] ?? currentHeight;
      mainColor = data['mainColorIndex'] != null ? Constraints.settingColorList[data['mainColorIndex']] : Constraints.overlayWindowMainColor;
      subColor = data['subColorIndex'] != null ? Constraints.settingColorList[data['subColorIndex']] : Constraints.overlayWindowSubColor;
      canvasColor = data['canvasColorIndex'] != null ? Constraints.settingColorList[data['canvasColorIndex']] : Constraints.overlayWindowCanvasColor;
      penColor = data['penColorIndex'] != null ? Constraints.settingColorList[data['penColorIndex']] : Constraints.overlayCanvasPenColor;
      currentEnableDrag = data['enableDrag'] ?? currentEnableDrag;
      isMinimize = data['minimize'] ?? currentHeight;
      paintController.clear();
      notifyListeners();
    });
  }

  static final OverlayController _instance = OverlayController._internal();

  factory OverlayController() {
    return _instance;
  }

  Future<bool?> closeOverlay() {
    return FlutterOverlayWindow.closeOverlay();
  }

  Future<void> resizeOverlay(int width, int height) {
    previousWidth = currentWidth;
    previousHeight = currentHeight;
    currentWidth = width;
    currentHeight = height;
    return FlutterOverlayWindow.resizeOverlay(width, height, currentEnableDrag);
  }

  Future<void> updateEnableDrag(bool enableDrag) {
    currentEnableDrag = enableDrag;
    return FlutterOverlayWindow.resizeOverlay(currentWidth, currentHeight, enableDrag);
  }

  void updateIsMinimize(bool isMinimize) {
    this.isMinimize = isMinimize;
    notifyListeners();
  }

  Future<void> showOverlay({
    int height = WindowSize.fullCover,
    int width = WindowSize.matchParent,
    OverlayAlignment alignment = OverlayAlignment.center,
    NotificationVisibility visibility = NotificationVisibility.visibilitySecret,
    OverlayFlag flag = OverlayFlag.defaultFlag,
    String overlayTitle = "overlay activated",
    String? overlayContent,
    bool enableDrag = false,
    PositionGravity positionGravity = PositionGravity.none,
    OverlayPosition? startPosition,
  }) async {
    currentHeight = height;
    currentWidth = width;
    currentEnableDrag = enableDrag;
    return FlutterOverlayWindow.showOverlay(
      height: height,
      width: width,
      alignment: alignment,
      visibility: visibility,
      flag: flag,
      overlayTitle: overlayTitle,
      overlayContent: overlayContent,
      enableDrag: enableDrag,
      positionGravity: PositionGravity.none,
      startPosition: startPosition,
    );
  }
}
