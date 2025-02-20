import 'dart:html';
import 'dart:math';
import 'ball.dart';
import 'game_map.dart';
import 'player.dart';

class Game{
  final Player playerOne;
  final Player playerTwo;
  final Ball ball;
  final CanvasElement canvas;
  final Function(Player) onPlayerScore;
  final GameMap map;

  final int padding = 20;
  final Element playerOneScoreElement = querySelector('#playerOneScore')!;
  final Element playerTwoScoreElement = querySelector('#playerTwoScore')!;

  late int canvasWidth;
  late int canvasHeight;

  CanvasRenderingContext2D get ctx => canvas.context2D;
  
  Game({
    required this.playerOne,
    required this.playerTwo,
    required this.ball,
    required this.canvas,
    required this.map,
    required this.onPlayerScore
  }) {
    updateScores();
  }

  void resetGame(Player playerWhoScored) {
    Random rand = Random();
    ball.x = canvasWidth / 2;
    ball.y = canvasHeight / 2;
    ball.speedX = rand.nextInt(2) == 0 ? ball.initialSpeedX : ball.initialSpeedX * -1;
    ball.speedY = rand.nextInt(2) == 0 ? ball.initialSpeedY : ball.initialSpeedY * -1;
    onPlayerScore(playerWhoScored);
  }

  void updateScores() {
    playerOneScoreElement.text = '${playerOne.score}';
    playerTwoScoreElement.text = '${playerTwo.score}';
  }

  void resizeGame(int width, int height) {
    canvasWidth = width;
    canvasHeight = height;
    
    canvas.width = canvasWidth;
    canvas.height = canvasHeight;

    playerOne.paddleX = padding.toDouble();
    playerOne.paddleY = (canvasHeight - playerOne.paddleHeight) / 2;
    playerTwo.paddleX = canvasWidth - playerTwo.paddleWidth - padding.toDouble();
    playerTwo.paddleY = (canvasHeight - playerTwo.paddleHeight) / 2;

    ball.x = canvasWidth / 2;
    ball.y = canvasHeight / 2;
  }

  void handleBallCollision(double x, double y, int width, int height) {
    double closestX = (ball.x < x) ? x : (ball.x > x + width) ? x + width : ball.x;
    double closestY = (ball.y < y) ? y : (ball.y > y + height) ? y + height : ball.y;

    double distanceX = ball.x - closestX;
    double distanceY = ball.y - closestY;

    bool collision = (distanceX * distanceX + distanceY * distanceY) < (ball.radius * ball.radius);

    if (collision) {
      if (ball.x < x || ball.x > x + width) {
        ball.speedX = -ball.speedX;
        ball.increaseSpeed();
      }
      if (ball.y < y || ball.y > y + height) {
        ball.speedY = -ball.speedY;
        ball.increaseSpeed();
      }
    }
  }

  void update(double deltaTime) {
    playerOne.update(deltaTime);
    playerTwo.update(deltaTime);
    
    ctx.clearRect(0, 0, canvasWidth, canvasHeight);

    ctx.beginPath();
    ctx.arc(ball.x, ball.y, ball.radius, 0, 3.14 * 2);
    ctx.fillStyle = ball.colorHex;
    ctx.fill();
    ctx.closePath();

    ctx.fillStyle = 'white';
    ctx.setLineDash([5, 15]);
    ctx.beginPath();
    ctx.moveTo(canvasWidth / 2, 0);
    ctx.lineTo(canvasWidth / 2, canvasHeight);
    ctx.strokeStyle = 'white';
    ctx.stroke();
    ctx.setLineDash([]);

    ctx.fillStyle = playerOne.paddleColorHex;
    ctx.fillRect(playerOne.paddleX, playerOne.paddleY, playerOne.paddleWidth, playerOne.paddleHeight); // Player 1
    ctx.fillStyle = playerTwo.paddleColorHex;
    ctx.fillRect(playerTwo.paddleX, playerTwo.paddleY, playerTwo.paddleWidth, playerTwo.paddleHeight); // Player 2

    ball.x += ball.speedX;
    ball.y += ball.speedY;

    map.draw(ctx);
    for (var obstacle in map.obstacles) {
      handleBallCollision(obstacle.getX(), obstacle.getY(), obstacle.getWidth(), obstacle.getHeight());
    }

    handleBallCollision(playerOne.paddleX, playerOne.paddleY, playerOne.paddleWidth, playerOne.paddleHeight);
    handleBallCollision(playerTwo.paddleX, playerTwo.paddleY, playerTwo.paddleWidth, playerTwo.paddleHeight);

    if (ball.y + ball.radius > canvasHeight || ball.y - ball.radius < 0) {
      ball.speedY = -ball.speedY;
    }

    if (ball.x - ball.radius < 0) {
      playerTwo.score++; 
      updateScores();
      resetGame(playerTwo);
    }
    if (ball.x + ball.radius > canvasWidth) {
      playerOne.score++;
      updateScores();
      resetGame(playerOne);
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
