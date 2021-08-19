import 'package:atari_breakout_flutter/game_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScoreText {
  final GameController _controller;
  late TextPainter _painter;
  late Offset _position;

  ScoreText(this._controller) {
    _painter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    _position = Offset.zero;
  }

  void render(Canvas canvas) {
    _painter.paint(canvas, _position);
  }

  void update(double t, int score) {
    // Gamescore zeichnen
    // ?? - Null Aware Operator. Wenn null mit empty initialisieren
    if ((_painter.text ?? '') != score) {
      _painter.text = TextSpan(
          text: score.toString(),
          style: TextStyle(color: Colors.black, fontSize: 70.0));
      _painter.layout();
      _position = Offset(_controller.screenSize.width / 2 - _painter.width / 2,
          _controller.screenSize.height * 0.2 / 2 - _painter.height * 0.2 / 2);
    }
  }
}
