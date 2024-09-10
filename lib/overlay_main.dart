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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: Constraints.overlayWindowBorderWidth, color: Colors.yellow),
      ),
      child: Column(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints.expand(height: Constraints.overlayTopBarHeight),
            color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton.outlined(
                      onPressed: () {
                        if (_paintController.canUndo) _paintController.undo();
                      },
                      icon: const Icon(Icons.undo),
                    ),
                    IconButton.outlined(
                      onPressed: () {
                        if (_paintController.canRedo) _paintController.redo();
                      },
                      icon: const Icon(Icons.redo),
                    ),
                    IconButton.outlined(
                      onPressed: () {
                        _paintController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton.outlined(
                      onPressed: () {
                        _overlayController!.resizeOverlay(
                            _overlayController!.currentWidth,
                            isMinimize ? _overlayController!.previousHeight
                                : (Constraints.overlayTopBarHeight + 2 * Constraints.overlayWindowBorderWidth).toInt(),
                        );
                        setState(() {
                          isMinimize = !isMinimize;
                        });
                      },
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
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
                  color: Colors.yellow,
                  width: 12.0,
                  height: 12.0,
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
  }

  void _onDragLowerRightEdgeStart(DragStartDetails details) async {
    final double xPos = details.globalPosition.dx;
    final double yPos = details.globalPosition.dy;
    await _overlayController!.updateEnableDrag(false);
    await _overlayController!.resizeOverlay(xPos.toInt(), yPos.toInt());
  }

  void _onDragLowerRightEdgeUpdate(DragUpdateDetails details) async {
    final double xPos = details.globalPosition.dx;
    final double yPos = details.globalPosition.dy;
    await _overlayController!.updateEnableDrag(false);
    await _overlayController!.resizeOverlay(xPos.toInt(), yPos.toInt());
  }

  void _onDragLowerRightEdgeEnd(DragEndDetails details) async {
    final double xPos = details.globalPosition.dx;
    final double yPos = details.globalPosition.dy;
    await _overlayController!.updateEnableDrag(true);
    await _overlayController!.resizeOverlay(xPos.toInt(), yPos.toInt());
  }
}
