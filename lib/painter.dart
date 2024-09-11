import 'package:flutter/material.dart';

import 'package:simple_paint_floating_overlay/overlay.dart';
import 'package:simple_paint_floating_overlay/paint_history.dart';
import 'package:simple_paint_floating_overlay/constraints.dart';

class Painter extends StatefulWidget {
  final OverlayController overlayController;
  final PaintController paintController;

  const Painter({
    required this.overlayController,
    required this.paintController,
    super.key
  });

  @override
  State<Painter> createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPaintStart,
      onPanUpdate: _onPaintUpdate,
      onPanEnd: _onPaintEnd,
      child: CustomPaint(
        willChange: true,
        painter: _CustomPainter(
          widget.paintController._paintHistory,
          repaint: widget.paintController,
        ),
      ),
    );
  }

  void _onPaintStart(DragStartDetails start) async {
    await widget.overlayController.updateEnableDrag(false);
    widget.paintController._paintHistory.addPaint(_getGlobalToLocalPosition(start.globalPosition));
    widget.paintController._notifyListeners();
  }

  void _onPaintUpdate(DragUpdateDetails update) {
    widget.paintController._paintHistory.updatePaint(_getGlobalToLocalPosition(update.globalPosition));
    widget.paintController._notifyListeners();
  }

  void _onPaintEnd(DragEndDetails end) async {
    await widget.overlayController.updateEnableDrag(true);
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
  final PaintHistory _paintHistory = PaintHistory();

  PaintController() : super() {
    Paint paint = Paint();
    paint.color = Constraints.overlayCanvasPenColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = Constraints.overlayCanvasPenWidth;
    _paintHistory.currentPaint = paint;
    _paintHistory.backgroundColor = Constraints.overlayWindowCanvasColor;
  }

  void updateCanvasBackgroundColor(Color color) {
    _paintHistory.backgroundColor = color;
  }

  void updateCanvasPenColor(Color color) {
    _paintHistory.currentPaint!.color = color;
  }

  void updateCanvasPenWidth(double width) {
    _paintHistory.currentPaint!.strokeWidth = width;
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