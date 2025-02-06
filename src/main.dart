import 'dart:html';
import 'ball.dart';
import 'game.dart';
import 'player.dart';

Game? runningGameInstance;
DateTime previousTime = DateTime.now();
bool isRunning = false;
CanvasElement canvas = querySelector("#gameCanvas") as CanvasElement;

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
  int ballSpeed = (querySelector("#ballSpeed") as InputElement).valueAsNumber!.toInt();
  int playerOneHeight = (querySelector("#playerOnePaddleHeight") as InputElement).valueAsNumber!.toInt();
  int playerOneWidth = (querySelector("#playerOnePaddleWidth") as InputElement).valueAsNumber!.toInt();
  int playerTwoHeight = (querySelector("#playerTwoPaddleHeight") as InputElement).valueAsNumber!.toInt();
  int playerTwoWidth = (querySelector("#playerTwoPaddleWidth") as InputElement).valueAsNumber!.toInt();
  Ball ball = Ball(initialSpeedX: ballSpeed as double, initialSpeedY: ballSpeed as double, radius: 10);

  Player playerOne = (querySelector("#playerOneSelect") as SelectElement)
    .selectedIndex == 0 
    ? HumanPlayer(
      keyUpName: 'w', 
      keyDownName: 's', 
      paddleWidth: playerOneWidth as double,
      paddleHeight: playerOneHeight as double, 
      document: document
    )
    : AIPlayer(
      ballRef: ball,
      paddleWidth: playerOneWidth as double,
      paddleHeight: playerOneHeight as double,
    );
  Player playerTwo = (querySelector("#playerTwoSelect") as SelectElement)
    .selectedIndex == 0 
    ? HumanPlayer(
      keyUpName: 'ArrowUp', 
      keyDownName: 'ArrowDown',
      paddleWidth: playerTwoWidth as double,
      paddleHeight: playerTwoHeight as double,
      document: document
    ) 
    : AIPlayer(
      ballRef: ball,
      paddleWidth: playerTwoWidth as double,
      paddleHeight: playerTwoHeight as double
    );
  runningGameInstance = Game(
    ball: ball,
    playerOne: playerOne,
    playerTwo: playerTwo,
    canvas: canvas
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
