import 'package:flutter/material.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'package:simple_paint_floating_overlay/overlay_main.dart';
import 'package:simple_paint_floating_overlay/constraints.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            elevation: Constraints.appTopBarElevation,
            centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? status = false;
  List<bool> isSelectedMainColor = List.filled(Constraints.settingColorList.length, false);
  List<bool> isSelectedSubColor = List.filled(Constraints.settingColorList.length, false);
  List<bool> isSelectedCanvasColor = List.filled(Constraints.settingColorList.length, false);
  List<bool> isSelectedPenColor = List.filled(Constraints.settingColorList.length, false);
  double? widthPhysics;
  double? heightPhysics;
  double? widthLogical;
  double? heightLogical;

  @override
  void initState() {
    super.initState();
    isSelectedMainColor[Constraints.settingColorList.indexOf(Constraints.overlayWindowMainColor)] = true;
    isSelectedSubColor[Constraints.settingColorList.indexOf(Constraints.overlayWindowSubColor)] = true;
    isSelectedCanvasColor[Constraints.settingColorList.indexOf(Constraints.overlayWindowCanvasColor)] = true;
    isSelectedPenColor[Constraints.settingColorList.indexOf(Constraints.overlayCanvasPenColor)] = true;
    Future(() async {
      status = await FlutterOverlayWindow.isPermissionGranted();
      if (!status!) {
        status = await FlutterOverlayWindow.requestPermission();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    widthPhysics = MediaQuery.sizeOf(context).width * MediaQuery.of(context).devicePixelRatio;
    heightPhysics = MediaQuery.sizeOf(context).height * MediaQuery.of(context).devicePixelRatio;
    widthLogical = MediaQuery.sizeOf(context).width;
    heightLogical = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constraints.applicationTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        const Text('${Constraints.overlayWindowMainColorText} :'),
                        _colorToggleButton(isSelectedMainColor),
                      ]
                  ),
                  Row(
                      children: <Widget>[
                        const Text('${Constraints.overlayWindowSubColorText} :'),
                        _colorToggleButton(isSelectedSubColor),
                      ]
                  ),
                  Row(
                      children: <Widget>[
                        const Text('${Constraints.overlayWindowCanvasColorText} :'),
                        _colorToggleButton(isSelectedCanvasColor),
                      ]
                  ),
                  Row(
                      children: <Widget>[
                        const Text('${Constraints.overlayCanvasPenColorText} :'),
                        _colorToggleButton(isSelectedPenColor),
                      ]
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleOverlay,
        tooltip: 'Show Overlay Window',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _toggleOverlay() async {
    if (status!) {
      if (!(await FlutterOverlayWindow.isActive())) {
        FlutterOverlayWindow.shareData({
          'width': (widthLogical! * Constraints.overlayWidthRatio).toInt(),
          'height': (heightLogical! * Constraints.overlayHeightRatio).toInt(),
          'mainColorIndex': isSelectedMainColor.indexOf(true),
          'subColorIndex': isSelectedSubColor.indexOf(true),
          'canvasColorIndex': isSelectedCanvasColor.indexOf(true),
          'penColorIndex': isSelectedPenColor.indexOf(true),
          'enableDrag': true,
          'minimize': false,
        });
        await FlutterOverlayWindow.showOverlay(
          width: (widthPhysics! * Constraints.overlayWidthRatio).toInt(),
          height: (heightPhysics! * Constraints.overlayHeightRatio).toInt(),
          alignment: OverlayAlignment.topLeft,
          enableDrag: true,
          positionGravity: PositionGravity.none,
          flag: OverlayFlag.defaultFlag,
          startPosition: OverlayPosition(
              widthLogical! * Constraints.overlayXPositionRatio,
              heightLogical! * Constraints.overlayYPositionRatio
          ),
        );
      } else {
        await FlutterOverlayWindow.closeOverlay();
      }
    }
  }

  Widget _colorToggleButton(List<bool> isSelectedList) {
    return ToggleButtons(
        direction: Axis.horizontal,
        constraints: const BoxConstraints.tightFor(
          height: Constraints.settingColorButtonHeight,
          width: Constraints.settingColorButtonWidth,
        ),
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < isSelectedList.length; i++) {
              isSelectedList[i] = (i == index);
            }
          });
        },
        isSelected: isSelectedList,
        renderBorder: false,
        children: <Widget> [
          for (final color in Constraints.settingColorList)
            Container(
              width: Constraints.settingColorButtonIconWidth,
              height: Constraints.settingColorButtonIconHeight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: Constraints.settingColorButtonBorderWidth,
                    color: Constraints.settingColorButtonBorderColor,
                ),
                color: color,
              ),
            ),
        ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    Future(() async {
      if (status!) {
        if (await FlutterOverlayWindow.isActive()) {
          FlutterOverlayWindow.closeOverlay();
        }
      }
    });
  }
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  runApp(const MyOverlayApp());
}
