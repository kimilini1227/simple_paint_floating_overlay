import 'dart:math';

import 'package:flutter/material.dart';

import 'package:simple_paint_floating_overlay/overlay.dart';
import 'package:simple_paint_floating_overlay/painter.dart';
import 'package:simple_paint_floating_overlay/constraints.dart';

class MyOverlayApp extends StatelessWidget {
  const MyOverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyOverlayPage(),
    );
  }
}

class MyOverlayPage extends StatefulWidget {
  const MyOverlayPage({super.key});

  @override
  State<MyOverlayPage> createState() => _MyOverlayPageState();
}

class _MyOverlayPageState extends State<MyOverlayPage> {
  OverlayController? _overlayController;
  final PaintController _paintController = PaintController();
  bool isMinimize = false;

  @override
  void initState() {
    super.initState();
    _overlayController = OverlayController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _overlayController!.overlayStreamController.stream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        Color mainColor = _overlayController!.mainColor;
        Color subColor = _overlayController!.subColor;
        Color canvasColor = _overlayController!.canvasColor;
        Color penColor = _overlayController!.penColor;
        if (snapshot.hasData) {
          final Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
          mainColor = data['mainColor'];
          subColor = data['subColor'];
          canvasColor = data['canvasColor'];
          penColor = data['penColor'];
        }
        _paintController.updateCanvasBackgroundColor(canvasColor);
        _paintController.updateCanvasPenColor(penColor);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: Constraints.overlayWindowBorderWidth,
              color: mainColor,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                constraints: const BoxConstraints.expand(height: Constraints.overlayTopBarHeight),
                color: mainColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            if (_paintController.canUndo) _paintController.undo();
                          },
                          color: subColor,
                          style: IconButton.styleFrom(
                            side: BorderSide(color: subColor, width: Constraints.overlayUndoButtonBorderWidth),
                          ),
                          icon: const Icon(Icons.undo),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_paintController.canRedo) _paintController.redo();
                          },
                          color: subColor,
                          style: IconButton.styleFrom(
                            side: BorderSide(color: subColor, width: Constraints.overlayRedoButtonBorderWidth),
                          ),
                          icon: const Icon(Icons.redo),
                        ),
                        IconButton(
                          onPressed: () {
                            _paintController.clear();
                          },
                          color: subColor,
                          style: IconButton.styleFrom(
                            side: BorderSide(color: subColor, width: Constraints.overlayClearButtonBorderWidth),
                          ),
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            _overlayController!.resizeOverlay(
                              _overlayController!.currentWidth,
                              isMinimize ? _overlayController!.previousHeight
                                  : Constraints.overlayWindowMinimumHeight.toInt(),
                            );
                            setState(() {
                              isMinimize = !isMinimize;
                            });
                          },
                          color: subColor,
                          style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: subColor,
                                  width: Constraints.overlayMinimizeButtonBorderWidth,
                                ),
                              )
                          ),
                          icon: isMinimize ? const Icon(Icons.maximize) : const Icon(Icons.minimize),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: !isMinimize ? Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: <Widget>[
                    Container(
                      constraints: const BoxConstraints.expand(),
                      child: Painter(
                        overlayController: _overlayController!,
                        paintController: _paintController,
                      ),
                    ),
                    Container(
                      color: mainColor,
                      width: Constraints.overlayLowerRightEdgeWidth,
                      height: Constraints.overlayLowerRightEdgeHeight,
                      child: GestureDetector(
                        onPanStart: _onDragLowerRightEdgeStart,
                        onPanUpdate: _onDragLowerRightEdgeUpdate,
                        onPanEnd: _onDragLowerRightEdgeEnd,
                      ),
                    ),
                  ],
                ) : Container(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onDragLowerRightEdgeStart(DragStartDetails details) async {
    await _overlayController!.updateEnableDrag(false);
  }

  void _onDragLowerRightEdgeUpdate(DragUpdateDetails details) async {
    final double xPos = max(details.globalPosition.dx, Constraints.overlayWindowMinimumWidth);
    final double yPos = max(details.globalPosition.dy, Constraints.overlayWindowMinimumHeight + Constraints.overlayLowerRightEdgeHeight);
    await _overlayController!.updateEnableDrag(false);
    await _overlayController!.resizeOverlay(xPos.toInt(), yPos.toInt());
  }

  void _onDragLowerRightEdgeEnd(DragEndDetails details) async {
    final double xPos = max(details.globalPosition.dx, Constraints.overlayWindowMinimumWidth);
    final double yPos = max(details.globalPosition.dy, Constraints.overlayWindowMinimumHeight + Constraints.overlayLowerRightEdgeHeight);
    await _overlayController!.updateEnableDrag(true);
    await _overlayController!.resizeOverlay(xPos.toInt(), yPos.toInt());
  }
}
