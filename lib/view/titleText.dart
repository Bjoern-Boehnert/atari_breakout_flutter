import 'package:atari_breakout_flutter/view/game_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleText {
  final GameController _controller;
  late TextPainter _painter;

  TitleText(this._controller) {
    _painter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
  }

  void render(Canvas canvas, String message) {
    _painter.text = TextSpan(
        text: message, style: TextStyle(color: Colors.black, fontSize: 30.0));
    _painter.layout();
    Offset position = Offset(_controller.screenSize.width / 2 - _painter.width / 2,
        _controller.screenSize.height * 0.2 / 2 - _painter.height * 0.2 / 2);
    _painter.paint(canvas, position);
  }
}
