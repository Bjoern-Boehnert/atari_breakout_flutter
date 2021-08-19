import 'dart:ui';

import 'package:atari_breakout_flutter/entities/gameBoard.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

import 'entities/ball.dart';
import 'entities/brick.dart';
import 'entities/paddle.dart';

class GameController extends Game implements HorizontalDragDetector {
  late Size screenSize;
  late double tileSize;
  late GameBoard board;
  late Rect background;

  Paint bgColor = Paint()..color = Colors.grey;
  Paint ballColor = Paint()..color = Colors.blue;
  Paint brickColor = Paint()..color = Colors.red;
  Paint paddleColor = Paint()..color = Colors.green;

  GameController() {
    init();
  }

  void init() async {
    resize(await Flame.util.initialDimensions());
  }

  @override
  void render(Canvas canvas) {
    // Background
    canvas.drawRect(background, bgColor);

    //Paddle
    Paddle paddle = board.paddle;
    canvas.drawRect(
        Rect.fromLTWH(paddle.x, paddle.y, paddle.width, paddle.height),
        paddleColor);

    // Ball
    Ball ball = board.ball;
    canvas.drawRect(
        Rect.fromLTWH(ball.x, ball.y, ball.width, ball.height), ballColor);

    for (Brick brick in board.bricks) {
      if (!brick.destroyed) {
        canvas.drawRect(
            Rect.fromLTWH(brick.x, brick.y, brick.width, brick.height),
            brickColor);
      }
    }
  }

  void restartGame() {
    board.restartGame();
  }

  @override
  void update(double t) {
    board.doRoundAction();
  }

  void resize(Size size) {
    screenSize = size;
    print("Size: " + screenSize.toString());
    board = GameBoard(screenSize.width, screenSize.height);
    board.initComponents();
    background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
  }

  @override
  void onHorizontalDragCancel() {
    // NOP
  }

  @override
  void onHorizontalDragDown(DragDownDetails details) {
    // NOP
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    // NOP
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    board.restartGame();
  }

  @override
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    movePaddle(details.globalPosition.dx);
  }

  void movePaddle(double val) {
    board.movePaddle(val);
  }
}
