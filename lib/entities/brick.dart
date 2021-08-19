import 'package:atari_breakout_flutter/entities/gameEntity.dart';

class Brick extends GameEntity {
  bool destroyed = false;

  Brick(double x, double y, double width, double height)
      : super(x, y, width, height);

}
