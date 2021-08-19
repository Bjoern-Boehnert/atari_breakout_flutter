import 'package:atari_breakout_flutter/view/game_controller.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final GameController controller = GameController();

void main() {
  Flame.device.fullScreen();
  Flame.device.setOrientation(DeviceOrientation.portraitUp);
  GameController controller = GameController();

  runApp(GameWidget(game: controller));
}
