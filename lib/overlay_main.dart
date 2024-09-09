import 'package:flutter/material.dart';

import 'package:simple_paint_floating_overlay/painter.dart';

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
  final PaintController _controller = PaintController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.yellow),
      ),
      child: Column(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints.expand(height: 48),
            color: Colors.yellow,
            child: Row(
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
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: Painter(
                  paintController: _controller
              ),
            ),
          ),
        ],
      ),
    );
  }
}
