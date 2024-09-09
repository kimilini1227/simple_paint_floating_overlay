import 'package:flutter/material.dart';

class _PaintData {
  _PaintData({
    required this.path,
  }) : super();

  Path path;
}

class PaintHistory {
  final List<MapEntry<_PaintData, Paint>> _paintList = List<MapEntry<_PaintData, Paint>>.empty(growable: true);
  final List<MapEntry<_PaintData, Paint>> _undoneList = List<MapEntry<_PaintData, Paint>>.empty(growable: true);
  final Paint _backgroundPaint = Paint();
  bool _inDrag = false;
  Paint? currentPaint;

  bool canUndo() => _paintList.isNotEmpty;

  bool canRedo() => _undoneList.isNotEmpty;

  void undo() {
    if (!_inDrag && canUndo()) {
      _undoneList.add(_paintList.removeLast());
    }
  }

  void redo() {
    if (!_inDrag && canRedo()) {
      _paintList.add(_undoneList.removeLast());
    }
  }

  void clear() {
    if (!_inDrag) {
      _paintList.clear();
      _undoneList.clear();
    }
  }

  set backgroundColor(color) => _backgroundPaint.color = color;

  void addPaint(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;
      Path path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      _PaintData data = _PaintData(path: path);
      _paintList.add(MapEntry<_PaintData, Paint>(data, currentPaint!));
    }
  }

  void updatePaint(Offset nextPoint) {

    if (_inDrag) {
      _PaintData data = _paintList.last.key;
      Path path = data.path;
      path.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endPaint() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(
        0.0,
        0.0,
        size.width,
        size.height,
      ),
      _backgroundPaint,
    );

    for (MapEntry<_PaintData, Paint> data in _paintList) {
      canvas.drawPath(data.key.path, data.value);
    }
  }
}