import 'package:atari_breakout_flutter/entities/gameEntity.dart';
import 'dart:math';

class Ball extends GameEntity {
  final int _STEP_SIZE = 5;
  late double _dx, _dy, _speed;

  Ball(double x, double y, double size) : super(x, y, size, size) {
    _dx = 1;
    _dy = 1;
    _speed = 1;
  }

  void move() {
    this.x += _STEP_SIZE * _dx * _speed;
    this.y += _STEP_SIZE * _dy;
  }

  void reflectY() {
    _dy *= -1;
  }

  void reflectX() {
    _dx *= -1;
  }

  void reflectByPaddle(double factor) {
    double value = cos(factor * pi);
    if (value <= 0) {
      value = value * -1;
    }
    _speed = value;

    //Change reflecting direction on paddle
    if (factor >= 0.5) {
      _dx = 1;
    } else {
      _dx = -1;
    }
  }
}
