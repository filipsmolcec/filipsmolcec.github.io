import 'dart:html';
import 'ball.dart';
import 'game.dart';
import 'player.dart';

Game? runningGameInstance;
DateTime previousTime = DateTime.now();
bool isRunning = false;

void main() {
  var startButton = querySelector("#startButton") as ButtonElement;
  startButton.onClick.listen((MouseEvent event) {
    if (event.button == 0) {
      startGame();
    }
  });
  window.onResize.listen((_) {
    runningGameInstance?.resizeGame(window.innerWidth!, window.innerHeight!);
  });
}

void startGame() {
  runningGameInstance = null;
  Ball ball = Ball(speedX: 2, speedY: 2, radius: 10);
  Player playerOne = (querySelector("#playerOneSelect") as SelectElement)
    .selectedIndex == 0 
    ? HumanPlayer(
      keyUpName: 'w', 
      keyDownName: 's',
      paddleWidth: 10,
      paddleHeight: 100, 
      document: document
    )
    : AIPlayer(
      ballRef: ball,
      paddleWidth: 10,
      paddleHeight: 100
    );
  Player playerTwo = (querySelector("#playerTwoSelect") as SelectElement)
    .selectedIndex == 0 
    ? HumanPlayer(
      keyUpName: 'ArrowUp', 
      keyDownName: 'ArrowDown',
      paddleWidth: 10,
      paddleHeight: 100,
      document: document
    ) 
    : AIPlayer(
      ballRef: ball,
      paddleWidth: 10,
      paddleHeight: 100
    );
  runningGameInstance = Game(
    ball: ball,
    playerOne: playerOne,
    playerTwo: playerTwo,
    canvas: querySelector("#gameCanvas") as CanvasElement
  );
  previousTime = DateTime.now();
  runningGameInstance?.resizeGame(window.innerWidth!, window.innerHeight!);
  if (!isRunning) {
    isRunning = true;
    updateGame();
  }
}

void updateGame() {
  DateTime currentTime = DateTime.now();
  double deltaTime = currentTime.difference(previousTime).inMilliseconds / 1000.0;
  previousTime = currentTime;
  window.animationFrame.then((_) {
    updateGame();
  });
  runningGameInstance?.update(deltaTime);
}
