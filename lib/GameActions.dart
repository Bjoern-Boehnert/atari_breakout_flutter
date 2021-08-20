import 'entities/brick.dart';

abstract class GameActions {
  void changeGameOverMessage(String message);
  void brickCollision(Brick brick);
  void paddleCollision();
}
