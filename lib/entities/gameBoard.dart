import 'package:atari_breakout_flutter/GameActions.dart';
import 'package:atari_breakout_flutter/entities/paddle.dart';

import 'ball.dart';
import 'brick.dart';
import 'paddle.dart';

class GameBoard {
  final double _width, _height;
  late Ball ball;
  late Paddle paddle;
  late List<Brick> bricks = [];
  bool _isStarted = false;
  int gameScore = 0;

  final GameActions _listener;

  GameBoard(this._width, this._height, this._listener);

  void initComponents() {
    // Init Ball
    this.ball = new Ball(_width / 2, _height / 2, _width / 32);

    // Init Paddle
    double paddleHeight = _height / 16;
    this.paddle = new Paddle(
        _width / 3, _height - paddleHeight, _width / 3, paddleHeight);

    // Init Bricks
    int brickInRow = 6;
    int rowsCount = 4;

    double spacing = _width / 256;
    double xMargin = _width / 3;
    double yMargin = _height / 3;
    double brickWidth = _width / brickInRow - xMargin / brickInRow;
    double brickHeight = _height / 8 - yMargin / rowsCount;

    bricks.clear();
    for (int i = 0; i < rowsCount; i++) {
      for (int j = 0; j < brickInRow; j++) {
        bricks.add(new Brick(
            j * brickWidth + xMargin / 2,
            i * brickHeight + yMargin / 2,
            brickWidth - spacing,
            brickHeight - spacing));
      }
    }
  }

  bool _isWin() {
    for (Brick brick in bricks) {
      if (!brick.destroyed) {
        return false;
      }
    }
    return true;
  }

  bool _isDestroyBrick() {
    for (Brick brick in bricks) {
      if (!brick.destroyed && brick.isIntersecting(ball)) {
        brick.destroyed = true;
        _listener.brickCollision(brick);
        return true;
      }
    }
    return false;
  }

  void doRoundAction() {
    if (!_isStarted) {
      return null;
    }

    if (_isWin()) {
      // Gewonnen
      _isStarted = false;
      _listener.changeGameOverMessage("Gewonnen");
    } else if (ball.y + ball.width > _height) {
      // Verloren
      _isStarted = false;
      _listener.changeGameOverMessage("Verloren");
    } else if (ball.x < 0 || (ball.x + ball.width) > _width) {
      ball.reflectX();
    } else if (ball.y < 0) {
      ball.reflectY();
    } else if (_isDestroyBrick()) {
      bricks.removeWhere((brick) => brick.destroyed);
      ball.reflectY();
      gameScore++;


    } else if (paddle.isIntersecting(ball)) {
      // Is reflected by paddle
      ball.reflectY();
      double reflectingPos = paddle.getReflectFactor(ball.x + ball.width / 2);
      ball.reflectByPaddle(reflectingPos);
      _listener.paddleCollision();
    }
    ball.move();
  }

  void movePaddle(double touchPos) {
    // Position the paddle always centrally
    double xPos = touchPos - paddle.width / 2;

    if (xPos < 0) {
      // Exceeds left limit
      paddle.move(0);
    } else if (xPos + paddle.width > _width) {
      // Exceeds Right limit
      paddle.move(_width - paddle.width);
    } else {
      paddle.move(xPos);
    }
  }

  void restartGame() {
    _isStarted = true;
    gameScore = 0;
  }
}
