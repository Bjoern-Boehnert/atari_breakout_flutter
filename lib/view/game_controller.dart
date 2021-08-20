import 'dart:ui';

import 'package:atari_breakout_flutter/GameActions.dart';
import 'package:atari_breakout_flutter/entities/brick.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

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
  String _message = "Starten drücken";

  // Colors
  final Paint _bgColor = Paint()..color = Colors.grey;
  final Paint _ballColor = Paint()..color = Colors.blue;
  final Paint _brickColor = Paint()..color = Colors.red;
  final Paint _paddleColor = Paint()..color = Colors.green;

  void init() async {
    _board = GameBoard(size.x, size.y, this)..initComponents();
    createGameComponents();
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
  void movePaddle(double val) {
    _board.movePaddle(val);
    Paddle paddle = _board.paddle;
    _paddleRect =
        Rect.fromLTWH(paddle.x, paddle.y, paddle.width, paddle.height);
  }

  // Rectangles für Blöcke erstellen
  void createBricks() {
    _bricksRect.clear();
    _board.bricks.forEach(
        (e) => _bricksRect.add(Rect.fromLTWH(e.x, e.y, e.width, e.height)));
  }

  // Rectangles für alle Game Komponenten erstellen
  void createGameComponents() {
    Ball ball = _board.ball;
    Paddle paddle = _board.paddle;

    _background = Rect.fromLTWH(0, 0, size.x, size.y);
    _ballRect = Rect.fromLTWH(ball.x, ball.y, ball.width, ball.height);
    _paddleRect =
        Rect.fromLTWH(paddle.x, paddle.y, paddle.width, paddle.height);

    createBricks();
  }

  void restartGame() {
    init();
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
      movePaddle(details.eventPosition.global.x);
    }
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo details) {
    if (_state == GameState.playing) {
      movePaddle(details.eventPosition.global.x);
    }
  }

  @override
  void onHorizontalDragDown(DragDownInfo details) {
    // NOP
  }

  @override
  void onResize(Vector2 size) {
    super.onResize(size);
    init();
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
    FlameAudio.play('brickdestroyed.mp3', volume: 1);
  }

  @override
  void paddleCollision() {
    // Sound spielen
    FlameAudio.play('paddlehit.mp3', volume: 1);
  }
}
