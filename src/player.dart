import 'dart:html';
import 'dart:math';
import 'ball.dart';

abstract class Player {
  int score = 0;

  final int paddleWidth;
  final int paddleHeight;
  final String paddleColorHex;

  double paddleX = 0;
  late double paddleY;

  bool goingUp = false;
  bool goingDown = false;

  Player({required this.paddleWidth, required this.paddleHeight, required this.paddleColorHex});

  void update(double deltaTime);
}

class HumanPlayer extends Player {
  final String keyUpName;
  final String keyDownName;
  final HtmlDocument document;

  HumanPlayer({required this.document, required this.keyUpName, required this.keyDownName, required super.paddleWidth, required super.paddleHeight, required super.paddleColorHex}) {
    document.onKeyUp.listen((KeyboardEvent event) {
      if (event.key == keyUpName) {
        goingUp = false;
      } else if (event.key == keyDownName) {
        goingDown = false;
      }
    });

    document.onKeyDown.listen((KeyboardEvent event) {
      if (event.key == keyUpName) {
        goingUp = true;
      } else if (event.key == keyDownName) {
        goingDown = true;
      }
    });
  }
  
  @override
  void update(double deltaTime) {}
}

class AIPlayer extends Player {
  final Ball ballRef;
  
  double secondsPassed = 0;
  Random random = Random();
  double seconds = 0;
  int randInt = 0;

  AIPlayer({required this.ballRef, required super.paddleWidth, required super.paddleHeight, required super.paddleColorHex});

  double unboundedLerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  @override
  void update(double deltaTime) {
    seconds += deltaTime;
    if (randInt < 9) {
      paddleY = unboundedLerp(paddleY, ballRef.y - paddleHeight / 2, 5 * deltaTime);
    }
    if (seconds > 0.2) {
      seconds = 0;
      randInt = random.nextInt(10);
    }
  }
}