import 'dart:ui';

abstract class GameEntity {
  double _x, _y;
  final double width, height;
  late final Rect rect;

  GameEntity(this._x, this._y, this.width, this.height) {
    rect = Rect.fromLTWH(_x, _y, width, height);
  }

  bool isIntersecting(GameEntity other) {
    return x < other.x + other.width &&
        other.x < width + x &&
        y < other.height + other.y &&
        other.y < height + y;
  }

  double get x => _x;

  double get y => _y;

  set y(value) {
    _y = value;
  }

  set x(double value) {
    _x = value;
  }
}
