import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:simple_paint_floating_overlay/ads_manager.dart';
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
  bool adLoaded = false;
  BannerAd? bannerAd;
  List<bool> isSelectedMainColor = List.filled(Constraints.settingColorList.length, false);
  List<bool> isSelectedSubColor = List.filled(Constraints.settingColorList.length, false);
  List<bool> isSelectedCanvasColor = List.filled(Constraints.settingColorList.length, false);
  List<bool> isSelectedPenColor = List.filled(Constraints.settingColorList.length, false);
  double? widthPhysics;
  double? heightPhysics;
  double? widthLogical;
  double? heightLogical;

  Future<void> _loadAd() async {
    bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => setState(() {
          bannerAd = ad as BannerAd;
          adLoaded = true;
        }),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
    return bannerAd!.load();
  }

  @override
  void initState() {
    super.initState();
    isSelectedMainColor[Constraints.settingColorList.indexOf(Constraints.overlayWindowMainColor)] = true;
    isSelectedSubColor[Constraints.settingColorList.indexOf(Constraints.overlayWindowSubColor)] = true;
    isSelectedCanvasColor[Constraints.settingColorList.indexOf(Constraints.overlayWindowCanvasColor)] = true;
    isSelectedPenColor[Constraints.settingColorList.indexOf(Constraints.overlayCanvasPenColor)] = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    final AdWidget bannerAdWidget = AdWidget(ad: bannerAd!);
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
          Container(
            alignment: Alignment.center,
            width: bannerAd!.size.width.toDouble(),
            height: bannerAd!.size.height.toDouble(),
            child: adLoaded ? bannerAdWidget : const LinearProgressIndicator(),
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
    bool status = await FlutterOverlayWindow.isPermissionGranted();
    if (status) {
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
    } else {
      _showRequestPermissionDialog();
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

  void _showRequestPermissionDialog() async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Lacks necessary permission.',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          content: const Text(
            'Display over other apps permission is required to use this feature.',
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget> [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                FlutterOverlayWindow.requestPermission();
              },
              child: const Text('Open setting'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    Future(() async {
      bool status = await FlutterOverlayWindow.isPermissionGranted();
      if (status) {
        if (await FlutterOverlayWindow.isActive()) {
          FlutterOverlayWindow.closeOverlay();
        }
      }
    });
    bannerAd!.dispose();
  }
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  runApp(const MyOverlayApp());
}
