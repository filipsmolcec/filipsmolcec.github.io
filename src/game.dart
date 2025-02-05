import 'dart:html';
import 'ball.dart';
import 'player.dart';

class Game{
  final Player playerOne;
  final Player playerTwo;
  final Ball ball;
  final CanvasElement canvas;

  final int padding = 20;
  final Element playerOneScoreElement = querySelector('#playerOneScore')!;
  final Element playerTwoScoreElement = querySelector('#playerTwoScore')!;
  
  late int canvasWidth;
  late int canvasHeight;

  CanvasRenderingContext2D get ctx => canvas.context2D;
  
  Game({required this.playerOne, required this.playerTwo, required this.ball, required this.canvas}) {
    updateScores();
  }

  void resetBall() {
    ball.x = canvasWidth / 2;
    ball.y = canvasHeight / 2;
    ball.speedX = 2;
    ball.speedY = 2;
  }

  void updateScores() {
    playerOneScoreElement.text = 'Player 1: ${playerOne.score}';
    playerTwoScoreElement.text = 'Player 2: ${playerTwo.score}';
  }

  void resizeGame(int width, int height) {
    canvasWidth = width - 2 * padding;
    canvasHeight = height - 100 - 2 * padding;
    canvas.width = canvasWidth;
    canvas.height = canvasHeight;

    playerOne.paddleX = padding.toDouble();
    playerOne.paddleY = (canvasHeight - playerOne.paddleHeight) / 2;
    playerTwo.paddleX = canvasWidth - playerTwo.paddleWidth - padding.toDouble();
    playerTwo.paddleY = (canvasHeight - playerTwo.paddleHeight) / 2;

    ball.x = canvasWidth / 2;
    ball.y = canvasHeight / 2;
  }

  void update(double deltaTime) {
    playerOne.update(deltaTime);
    playerTwo.update(deltaTime);
    
    ctx.clearRect(0, 0, canvasWidth, canvasHeight);

    ctx.beginPath();
    ctx.arc(ball.x, ball.y, ball.radius, 0, 3.14 * 2);
    ctx.fillStyle = 'white';
    ctx.fill();
    ctx.closePath();

    ctx.fillStyle = 'white';
    ctx.fillRect(playerOne.paddleX, playerOne.paddleY, playerOne.paddleWidth, playerOne.paddleHeight); // Player 1
    ctx.fillRect(playerTwo.paddleX, playerTwo.paddleY, playerTwo.paddleWidth, playerTwo.paddleHeight); // Player 2

    ball.x += ball.speedX;
    ball.y += ball.speedY;

    if (ball.y + ball.radius > canvasHeight || ball.y - ball.radius < 0) {
      ball.speedY = -ball.speedY;
    }

    if (ball.x - ball.radius < playerOne.paddleX + playerOne.paddleWidth &&
        ball.y > playerOne.paddleY &&
        ball.y < playerOne.paddleY + playerOne.paddleHeight) {
      ball.speedX = -ball.speedX;
    }
    if (ball.x + ball.radius > playerTwo.paddleX &&
        ball.y > playerTwo.paddleY &&
        ball.y < playerTwo.paddleY + playerTwo.paddleHeight) {
      ball.speedX = -ball.speedX;
    }

    if (ball.x - ball.radius < 0) {
      playerTwo.score++;
      updateScores();
      resetBall();
    }
    if (ball.x + ball.radius > canvasWidth) {
      playerOne.score++;
      updateScores();
      resetBall();
    }

    // Player 1
    if (playerOne.goingUp && playerOne.paddleY > 0) {
      playerOne.paddleY -= 5;
    }
    if (playerOne.goingDown && playerOne.paddleY + playerOne.paddleHeight < canvasHeight) {
      playerOne.paddleY += 5;
    }

    // Player 2
    if (playerTwo.goingUp && playerTwo.paddleY > 0) {
      playerTwo.paddleY -= 5;
    } 
    if (playerTwo.goingDown && playerTwo.paddleY + playerTwo.paddleHeight < canvasHeight) {
      playerTwo.paddleY += 5;
    }
  }
}
