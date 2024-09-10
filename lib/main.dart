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
      title: 'Simple Paint Floating Overlay',
      theme: ThemeData(
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
  double? widthPhysics;
  double? heightPhysics;
  double? widthLogical;
  double? heightLogical;

  @override
  void initState() {
    super.initState();
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Placeholder()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (status!) {
            if (!(await FlutterOverlayWindow.isActive())) {
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
              FlutterOverlayWindow.shareData({
                'width': (widthLogical! * Constraints.overlayWidthRatio).toInt(),
                'height': (heightLogical! * Constraints.overlayHeightRatio).toInt(),
                'enableDrag': true,
              });
            } else {
              await FlutterOverlayWindow.closeOverlay();
            }
          }
        },
        tooltip: 'Show Overlay Window',
        child: const Icon(Icons.add),
      ),
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
