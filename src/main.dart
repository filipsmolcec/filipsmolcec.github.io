import 'dart:html';
import 'ball.dart';
import 'game.dart';
import 'player.dart';
import 'player_config.dart';

Game? runningGameInstance;
DateTime previousTime = DateTime.now();
bool isRunning = false;
CanvasElement canvas = querySelector("#gameCanvas") as CanvasElement;

PlayerConfig? playerOneConfig;
PlayerConfig? playerTwoConfig;

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
  playerOneConfig = PlayerConfig(
    name: "Player One",
    parentElement: querySelector("#playerConfig") as HtmlElement, 
    humanMoveUp: "w", 
    humanMoveDown: "s"
  );
  playerTwoConfig = PlayerConfig(
    name: "Player Two",
    parentElement: querySelector("#playerConfig") as HtmlElement, 
    humanMoveUp: "ArrowUp", 
    humanMoveDown: "ArrowDown"
  );
}

void startGame() {
  runningGameInstance = null;
  int ballSpeed = (querySelector("#ballSpeed") as InputElement).valueAsNumber!.toInt();
  String ballColorHex = (querySelector("#ballColor") as InputElement).value!;
  Ball ball = Ball(
    initialSpeedX: ballSpeed as double, 
    initialSpeedY: ballSpeed as double, 
    radius: 10,
    increaseSpeedFactor: 0.25,
    colorHex: ballColorHex
  );

  print(playerOneConfig!.playerType);
  Player playerOne = playerOneConfig!.getPlayer(ball);
  Player playerTwo = playerTwoConfig!.getPlayer(ball);

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
