import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:simple_paint_floating_overlay/constraints.dart';

class OverlayController {
  int currentWidth = 0;
  int currentHeight = 0;
  int previousWidth = 0;
  int previousHeight = 0;
  Color mainColor = Constraints.overlayWindowMainColor;
  Color subColor = Constraints.overlayWindowSubColor;
  Color canvasColor = Constraints.overlayWindowCanvasColor;
  Color penColor = Constraints.overlayCanvasPenColor;
  bool currentEnableDrag = false;

  StreamController<Map<String, dynamic>> overlayStreamController = StreamController<Map<String, dynamic>>();

  OverlayController._internal() {
    FlutterOverlayWindow.overlayListener.listen((data) {
      currentWidth = data['width'];
      currentHeight = data['height'];
      currentEnableDrag = data['enableDrag'];
      mainColor = Constraints.settingColorList[data['mainColorIndex']];
      subColor = Constraints.settingColorList[data['subColorIndex']];
      canvasColor = Constraints.settingColorList[data['canvasColorIndex']];
      penColor = Constraints.settingColorList[data['penColorIndex']];
      overlayStreamController.sink.add({
        'mainColor': mainColor,
        'subColor': subColor,
        'canvasColor': canvasColor,
        'penColor': penColor,
      });
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
