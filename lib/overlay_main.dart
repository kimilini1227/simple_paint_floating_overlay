import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'package:simple_paint_floating_overlay/painter.dart';

class MyOverlayApp extends StatelessWidget {
  const MyOverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyOverlayPage(),
    );
  }
}

class MyOverlayPage extends StatefulWidget {
  const MyOverlayPage({super.key});

  @override
  State<MyOverlayPage> createState() => _MyOverlayPageState();
}

class _MyOverlayPageState extends State<MyOverlayPage> {
  PaintController _controller = PaintController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.yellow),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton.outlined(
                onPressed: () {
                  if (_controller.canUndo) _controller.undo();
                },
                icon: const Icon(Icons.undo),
              ),
              IconButton.outlined(
                onPressed: () {
                  if (_controller.canRedo) _controller.redo();
                },
                icon: const Icon(Icons.redo),
              ),
              IconButton.outlined(
                onPressed: () {
                  _controller.clear();
                },
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
          Expanded(
            child: Painter(
              paintController: _controller
            ),
          ),
        ],
      ),
    );
  }
}
