import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../entities/ball.dart';
import '../entities/gameBoard.dart';
import '../entities/paddle.dart';
import '../view/gameState.dart';
import '../view/titleText.dart';

class GameController extends Game implements HorizontalDragDetector {
  // Game Objects
  late GameBoard _board;
  late Rect _background, _ballRect, _paddleRect;
  late GameState _state;
  late TitleText _titleText;
  List<Rect> _bricksRect = [];
  String _message = "Antippen zum Starten";

  // Colors
  final Paint _bgColor = Paint()..color = Colors.grey;
  final Paint _ballColor = Paint()..color = Colors.blue;
  final Paint _brickColor = Paint()..color = Colors.red;
  final Paint _paddleColor = Paint()..color = Colors.green;

  late Vector2 screenSize;

  void init() async {
    _titleText = TitleText(this);
    _board = GameBoard(screenSize.x, screenSize.y)..initComponents();
    _state = GameState.menu;
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
      // Spiel gestartet - Show Game Over
      if (!_board.isStarted) {
        _titleText.render(canvas, _message);
        _state = GameState.menu;
        return;
      }
      // Punktezahl updaten
      _titleText.render(canvas, "Score: " + _board.gameScore.toString());
    }
  }

  @override
  void update(double t) {

    if (_state == GameState.menu) {
      // TODO: Highscore in Shared Preferences abspeichern
    } else {
      if (!_board.isStarted) {
        return;
      }

      // Rundenaktionen ausführen
      _board.doRoundAction();

      // GameOver Nachricht - Tenary Operator
      _message = _board.isWin() ? "Gewonnen" : "Verloren";

      // Ball neu rendern
      Ball ball = _board.ball;
      _ballRect = Rect.fromLTWH(ball.x, ball.y, ball.width, ball.height);

      // Brick neuzeichnen - wenn zerstört
      if (_bricksRect.length > _board.bricks.length) {
        createBricks();
      }
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

    _background = Rect.fromLTWH(0, 0, screenSize.x, screenSize.y);
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
    screenSize = size;
    init();
  }
}
