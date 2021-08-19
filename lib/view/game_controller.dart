import 'dart:ui';

import 'package:atari_breakout_flutter/view/titleText.dart';
import 'package:atari_breakout_flutter/entities/gameBoard.dart';
import 'package:atari_breakout_flutter/view/gameState.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../entities/ball.dart';
import '../entities/brick.dart';
import '../entities/paddle.dart';

class GameController extends Game implements HorizontalDragDetector {
  // Game Objects
  late GameBoard _board;
  late Rect _background, _ballRect, _paddleRect;
  late List<Rect> _bricksRect = [];
  late GameState _state;

  // Colors
  final Paint _bgColor = Paint()..color = Colors.grey;
  final Paint _ballColor = Paint()..color = Colors.blue;
  final Paint _brickColor = Paint()..color = Colors.red;
  final Paint _paddleColor = Paint()..color = Colors.green;

  String _message = "Antippen zum Starten";
  late Size screenSize;
  late TitleText _titleText;

  late bool isInitialised;

  GameController() {
    init();
  }

  void init() async {
    resize(await Flame.util.initialDimensions());

    _titleText = TitleText(this);
    _board = GameBoard(screenSize.width, screenSize.height);
    _board.initComponents();

    _state = GameState.menu;
    createGameComponents();
    isInitialised = true;
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
      // Spiel gestartet
      // Show Game Over
      if (!_board.isStarted) {
        isInitialised = false;
        _titleText.render(canvas, _message);
        _state = GameState.menu;
        return;
      }
      _titleText.render(canvas, _board.gameScore.toString());
    }
  }

  @override
  void update(double t) {
    if (_state == GameState.menu) {
    } else {
      if (!_board.isStarted) {
        return;
      }

      // Rundenaktionen ausführen
      _board.doRoundAction();

      // GameOver Nachricht
      if (_board.isWin()) {
        _message = "Gewonnen";
      } else {
        _message = "Verloren";
      }

      // Ball neu rendern
      Ball ball = _board.ball;
      _ballRect = Rect.fromLTWH(ball.x, ball.y, ball.width, ball.height);

      // Brick neuzeichnen - wenn zerstört
      if (_bricksRect.length > _board.bricks.length) {
        createBricks();
      }
    }
  }

  void resize(Size size) {
    screenSize = size;
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
    for (Brick brick in _board.bricks) {
      _bricksRect
          .add(Rect.fromLTWH(brick.x, brick.y, brick.width, brick.height));
    }
  }

  // Rectangles für alle Game Komponenten erstellen
  void createGameComponents() {
    Ball ball = _board.ball;
    Paddle paddle = _board.paddle;

    _background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    _ballRect = Rect.fromLTWH(ball.x, ball.y, ball.width, ball.height);
    _paddleRect =
        Rect.fromLTWH(paddle.x, paddle.y, paddle.width, paddle.height);

    createBricks();
  }

  void restartGame() {
    if (!isInitialised) {
      init();
    }
    _state = GameState.playing;
    _board.restartGame();
  }

  @override
  void onHorizontalDragCancel() {
    // NOP
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    // NOP
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    if (_state == GameState.menu) {
      restartGame();
    } else {
      movePaddle(details.globalPosition.dx);
    }
  }

  @override
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_state == GameState.menu) {
      restartGame();
    } else {
      movePaddle(details.globalPosition.dx);
    }
  }

  @override
  void onHorizontalDragDown(DragDownDetails details) {
    // NOP
  }
}
