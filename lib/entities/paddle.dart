import 'package:atari_breakout_flutter/entities/gameEntity.dart';

class Paddle extends GameEntity {
  Paddle(double x, double y, double width, double height)
      : super(x, y, width, height);

  void move(double x) {
    this.x = x;
  }

  double getReflectFactor(double xPos) {
    // Get the percentage of the hit x-position of the ball
    double reflectionPercentage = (xPos - x) / width;

    // Avoid negative values
    if (reflectionPercentage < 0) {
      reflectionPercentage = 0;
    }
    return reflectionPercentage;
  }
}
