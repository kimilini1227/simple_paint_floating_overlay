import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'package:simple_paint_floating_overlay/paint_history.dart';

class Painter extends StatefulWidget {
  final PaintController paintController;

  Painter(
    {
      required this.paintController
    }
  ) : super(key: ValueKey<PaintController>(paintController)) {
    assert(this.paintController != null);
  }

  @override
  State<Painter> createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: CustomPaint(
          willChange: true,
          painter: _CustomPainter(
            widget.paintController._paintHistory,
            repaint: widget.paintController,
          ),
        ),
        onPanStart: _onPaintStart,
        onPanUpdate: _onPaintUpdate,
        onPanEnd: _onPaintEnd,
      ),
      constraints: BoxConstraints.expand(),
    );
  }

  void _onPaintStart(DragStartDetails start) {
    widget.paintController._paintHistory.addPaint(_getGlobalToLocalPosition(start.globalPosition));
    widget.paintController._notifyListeners();
  }

  void _onPaintUpdate(DragUpdateDetails update) {
    widget.paintController._paintHistory.updatePaint(_getGlobalToLocalPosition(update.globalPosition));
    widget.paintController._notifyListeners();
  }

  void _onPaintEnd(DragEndDetails end) {
    widget.paintController._paintHistory.endPaint();
    widget.paintController._notifyListeners();
  }

  Offset _getGlobalToLocalPosition(Offset global) {
    return (context.findRenderObject() as RenderBox).globalToLocal(global);
  }
}

class _CustomPainter extends CustomPainter {

  final PaintHistory _paintHistory;

  _CustomPainter(
    this._paintHistory,
    {
      required Listenable repaint
    }
  ) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _paintHistory.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_CustomPainter oldDelegate) => true;
}

class PaintController extends ChangeNotifier {
  PaintHistory _paintHistory = PaintHistory();
  Color _drawColor = Color.fromARGB(255, 0, 0, 0);
  double _thickness = 5.0;
  Color _backgroundColor = Colors.transparent;

  PaintController() : super() {
    Paint paint = Paint();
    paint.color = _drawColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = _thickness;
    _paintHistory.currentPaint = paint;
    _paintHistory.backgroundColor = _backgroundColor;
  }

  void undo() {
    _paintHistory.undo();
    notifyListeners();
  }

  void redo() {
    _paintHistory.redo();
    notifyListeners();
  }

  bool get canUndo => _paintHistory.canUndo();

  bool get canRedo => _paintHistory.canRedo();

  void _notifyListeners() {
    notifyListeners();
  }

  void clear() {
    _paintHistory.clear();
    notifyListeners();
  }
}