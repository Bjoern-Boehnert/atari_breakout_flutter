import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  _PainterState createState() => _PainterState();
}

class _PainterState extends State<Game> with SingleTickerProviderStateMixin {
  var val = 10;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(child: Container(), painter: Painter());
  }
}
// Statt den Painter zu verwenden kann auch das flame-package verwendet werden.
// Damit hätten wir auch direkt einen game cycle
class Painter extends CustomPainter {
  double _val = 30;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(_val, _val, 30, 30);
    Paint paint = Paint();
    canvas.drawRect(rect, paint);
    _val += 30;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
