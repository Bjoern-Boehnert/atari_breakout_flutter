import 'dart:ui';

abstract class GameEntity {
  double x, y;
  final double width, height;
  late final Rect rect;

  GameEntity(this.x, this.y, this.width, this.height) {
    rect = Rect.fromLTWH(x, y, width, height);
  }

  bool isIntersecting(GameEntity other) {
    return x < other.x + other.width &&
        other.x < width + x &&
        y < other.height + other.y &&
        other.y < height + y;
  }

}
