import 'package:atari_breakout_flutter/view/game_controller.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final GameController controller = GameController();

void main() {
  Flame.device.fullScreen();
  Flame.device.setOrientation(DeviceOrientation.portraitUp);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 8,
              child: GameWidget(game: controller),
            ),
            MainMenu(),
          ],
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        onPressed: startGame,
        child: Text(
          'Spiel starten',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

void startGame() {
  controller.restartGame();
}
