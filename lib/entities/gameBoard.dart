import 'package:atari_breakout_flutter/entities/paddle.dart';

import 'ball.dart';
import 'brick.dart';
import 'paddle.dart';

class GameBoard {
  final double _width, _height;
  late Ball _ball;
  late Paddle _paddle;
  late List<Brick> _bricks = [];
  bool _isStarted = false;
  int _gameScore = 0;

  GameBoard(this._width, this._height);

  void initComponents() {
    // Init Ball
    this._ball = new Ball(_width / 2, _height / 2, _width / 32);

    // Init Paddle
    double paddleHeight = _height / 16;
    this._paddle = new Paddle(
        _width / 3, _height - paddleHeight, _width / 3, paddleHeight);

    // Init Bricks
    int brickInRow = 6;
    int rowsCount = 4;

    double spacing = _width / 256;
    double margin = _width / 3;
    double brickWidth = _width / brickInRow - margin / brickInRow;
    double brickHeight = _height / 8 - margin / rowsCount;

    for (int i = 0; i < rowsCount; i++) {
      for (int j = 0; j < brickInRow; j++) {
        _bricks.add(new Brick(
            j * brickWidth + margin / 2,
            i * brickHeight + margin,
            brickWidth - spacing,
            brickHeight - spacing));
      }
    }
  }

  bool isWin() {
    for (Brick brick in _bricks) {
      if (!brick.destroyed) {
        return false;
      }
    }
    return true;
  }

  bool isDestroyBrick() {
    for (Brick brick in _bricks) {
      if (!brick.destroyed && brick.isIntersecting(_ball)) {
        brick.destroyed = true;
        return true;
      }
    }
    return false;
  }

  void doRoundAction() {
    if (!_isStarted) {
      return null;
    }

    if (isWin()) {
      // Gewonnen
      _isStarted = false;
    } else if (_ball.y + _ball.width > _height) {
      // Verloren
      _isStarted = false;
    } else if (_ball.x < 0 || (_ball.x + _ball.width) > _width) {
      _ball.reflectX();
    } else if (_ball.y < 0) {
      _ball.reflectY();
    } else if (isDestroyBrick()) {
      _ball.reflectY();
      _gameScore++;
    } else if (_paddle.isIntersecting(_ball)) {
      // Is reflected by paddle
      _ball.reflectY();
      double reflectingPos = paddle.getReflectFactor(ball.x + ball.width / 2);
      ball.reflectByPaddle(reflectingPos);
    }
    _ball.move();
  }

  void movePaddle(double touchPos) {
    // Position the paddle always centrally
    double xPos = touchPos - _paddle.width / 2;

    if (xPos < 0) {
      // Exceeds left limit
      _paddle.move(0);
    } else if (xPos + _paddle.width > _width) {
      // Exceeds Right limit
      _paddle.move(_width - _paddle.width);
    } else {
      _paddle.move(xPos);
    }
  }

  void restartGame() {
    _isStarted = true;
    _gameScore = 0;
    initComponents();
  }

  double get height => _height;

  double get width => _width;

  int get gameScore => _gameScore;

  bool get isStarted => _isStarted;

  List<Brick> get bricks => _bricks;

  Paddle get paddle => _paddle;

  Ball get ball => _ball;
}
