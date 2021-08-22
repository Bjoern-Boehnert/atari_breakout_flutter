import 'dart:math';
import 'dart:ui';

import 'package:atari_breakout_flutter/GameActions.dart';
import 'package:atari_breakout_flutter/entities/brick.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../entities/ball.dart';
import '../entities/gameBoard.dart';
import '../entities/paddle.dart';
import '../view/gameState.dart';
import '../view/titleText.dart';

class GameController extends Game
    implements HorizontalDragDetector, GameActions {
  // Game Objects
  late GameBoard _board;
  late Rect _background, _ballRect, _paddleRect;
  late TitleText _titleText = TitleText(this);
  GameState _state = GameState.menu;
  List<Rect> _bricksRect = [];
  String _message = "Zum Starten tippen";

  // Colors
  Paint _bgColor = Paint()..color = Colors.grey;
  Paint _ballColor = Paint()..color = Colors.blue;
  Paint _brickColor = Paint()..color = Colors.red;
  Paint _paddleColor = Paint()..color = Colors.green;

  int _rows = 4, _columns = 4, _margin = 16, _spacing = 256;

  void _init() async {
    _board = GameBoard(size.x, size.y, this);
    _board.setRowCount(_rows);
    _board.setColumnCount(_columns);
    _board.setMargin(_margin);
    _board.setSpacing(_spacing);
    _board.initComponents();
    _createGameComponents();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(_background, _bgColor);
    canvas.drawRect(_ballRect, _ballColor);
    canvas.drawRect(_paddleRect, _paddleColor);
    _bricksRect.forEach((e) => canvas.drawRect(e, _brickColor));

    if (_state == GameState.menu) {
      // Spiel noch nicht gestartet - Hinweis anzeigen
      _titleText.render(canvas, _message);
    } else {
      // Punktezahl updaten
      _titleText.render(canvas, "Score: " + _board.gameScore.toString());
    }
  }

  @override
  void update(double t) {
    if (_state == GameState.menu) {
      // TODO: Highscore in Shared Preferences abspeichern
    } else {
      // Rundenaktionen ausführen
      _board.doRoundAction();

      // Ball neu rendern
      _ballRect = Rect.fromLTWH(
          _board.ball.x, _board.ball.y, _board.ball.width, _board.ball.height);
    }
  }

  // Paddle bewegen
  void _movePaddle(double val) {
    _board.movePaddle(val);
    Paddle paddle = _board.paddle;
    _paddleRect =
        Rect.fromLTWH(paddle.x, paddle.y, paddle.width, paddle.height);
  }

  // Rectangles für Blöcke erstellen
  void _createBricks() {
    _bricksRect.clear();
    _board.bricks.forEach(
        (e) => _bricksRect.add(Rect.fromLTWH(e.x, e.y, e.width, e.height)));
  }

  // Rectangles für alle Game Komponenten erstellen
  void _createGameComponents() {
    Ball ball = _board.ball;
    Paddle paddle = _board.paddle;

    _background = Rect.fromLTWH(0, 0, size.x, size.y);
    _ballRect = Rect.fromLTWH(ball.x, ball.y, ball.width, ball.height);
    _paddleRect =
        Rect.fromLTWH(paddle.x, paddle.y, paddle.width, paddle.height);

    _createBricks();
  }

  void _restartGame() {
    _init();
    _state = GameState.playing;
    _board.restartGame();
  }

  @override
  void onHorizontalDragCancel() {
    // NOP
  }

  @override
  void onHorizontalDragEnd(DragEndInfo details) {
    // NOP
  }

  @override
  void onHorizontalDragStart(DragStartInfo details) {
    if (_state == GameState.playing) {
      _movePaddle(details.eventPosition.global.x);
    }
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo details) {
    if (_state == GameState.playing) {
      _movePaddle(details.eventPosition.global.x);
    } else {
      _restartGame();
    }
  }

  @override
  void onHorizontalDragDown(DragDownInfo details) {
    // NOP
  }

  @override
  void onResize(Vector2 size) {
    super.onResize(size);
    _init();
  }

  @override
  void changeGameOverMessage(String message) {
    _message = message;

    // Zu Menu wechseln, wenn Spiel vorbei
    _state = GameState.menu;
  }

  @override
  void brickCollision(Brick brick) {
    // Brick entfernen
    _bricksRect.removeWhere((e) => e.left == brick.x && e.top == brick.y);

    // Sound spielen
    FlameAudio.play('brickdestroyed.mp3');
  }

  @override
  void paddleCollision() {
    // Sound spielen
    FlameAudio.play('paddlehit.mp3');
  }

  void stopGame() {
    _state = GameState.menu;
    _message = "Zum Starten tippen";
  }

  void applySettings() {
    _paddleColor = _convertColorToPaint('paddleColor');
    _brickColor = _convertColorToPaint('brickColor');
    _ballColor = _convertColorToPaint('ballColor');

    _rows = Settings.getValue('rowCount', 0.0).toInt();
    _columns = Settings.getValue('columnCount', 0.0).toInt();

    _margin = pow(2, Settings.getValue('margin', 0.0)).toInt();
    _spacing = 10 * Settings.getValue('spacing', 0.0).toInt();
    _init();
  }

  Paint _convertColorToPaint(String key) {
    Color color = ConversionUtils.colorFromString(Settings.getValue(key, ""));
    return Paint()..color = color;
  }
}
