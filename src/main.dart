import 'dart:html';
import 'ball.dart';
import 'game.dart';
import 'player.dart';
import 'player_config.dart';
import 'game_map_definitions.dart';

Game? runningGameInstance;
DateTime previousTime = DateTime.now();
bool isRunning = false;
CanvasElement canvas = querySelector("#gameCanvas") as CanvasElement;

PlayerConfig? playerOneConfig;
PlayerConfig? playerTwoConfig;

var maps = getMaps(canvas);

void main() {
  var startButton = querySelector("#startButton") as ButtonElement;
  var pauseButton = querySelector("#pauseButton") as ButtonElement;
  createMapOptions();
  startButton.onClick.listen((MouseEvent event) {
    if (event.button == 0) {
      startNewGame();
    }
  });
  pauseButton.onClick.listen((MouseEvent event) {
    if (event.button == 0) {
      if (isRunning) {
        pauseGame();
      } else {
        unpauseGame();
      }
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
  loadCookies();
}

void createMapOptions() {
  var mapSelect = querySelector("#mapSelect") as SelectElement;
  for (var entry in maps.entries) {
    var option = OptionElement(data: entry.value.name, value: entry.key);
    mapSelect.append(option);
  }
}

String getSelectedMapKey() {
  var mapSelect = querySelector("#mapSelect") as SelectElement;
  return mapSelect.selectedOptions[0].value;
}

void startNewGame() {
  int ballSpeed = (querySelector("#ballSpeed") as InputElement).valueAsNumber!.toInt();
  String ballColorHex = (querySelector("#ballColor") as InputElement).value!;
  Ball ball = Ball(
    initialSpeedX: ballSpeed as double, 
    initialSpeedY: ballSpeed as double, 
    radius: 10,
    increaseSpeedFactor: 0.05,
    colorHex: ballColorHex
  );

  Player playerOne = playerOneConfig!.getPlayer(ball);
  Player playerTwo = playerTwoConfig!.getPlayer(ball);

  runningGameInstance = Game(
    ball: ball,
    playerOne: playerOne,
    playerTwo: playerTwo,
    map: maps[getSelectedMapKey()]!,
    canvas: canvas,
    onPlayerScore: (playerWhoScored) {
      addScoreCookie(
        playerOneScoreAdd: playerWhoScored == playerOne ? 1 : 0,
        playerTwoScoreAdd: playerWhoScored == playerTwo ? 1 : 0
      );
      loadCookies();
    }
  );
  
  previousTime = DateTime.now();
  runningGameInstance?.resizeGame(window.innerWidth!, window.innerHeight!);
  if (!isRunning) {
    isRunning = true;
    updateGame();
  }
}

void unpauseGame() {
  isRunning = true;
  updateGame();
}

void pauseGame() {
  isRunning = false;
}

void updateGame() {
  if (!isRunning) {
    return;
  }
  DateTime currentTime = DateTime.now();
  double deltaTime = currentTime.difference(previousTime).inMilliseconds / 1000.0;
  previousTime = currentTime;
  window.animationFrame.then((_) {
    updateGame();
  });
  runningGameInstance?.update(deltaTime);
}

int getScoreFromCookie(String key) {
  List<String> cookies = document.cookie!.split(";");
  for (String cookie in cookies) {
    List<String> cookieParts = cookie.split("=");
    if (cookieParts[0].trim() == key) {
      return int.parse(cookieParts[1]);
    }
  }
  return 0;
}

void addScoreCookie({required int playerOneScoreAdd, required int playerTwoScoreAdd}) {
  if (runningGameInstance != null) {
    int playerOneScore = getScoreFromCookie("playerOneScore") + playerOneScoreAdd;
    int playerTwoScore = getScoreFromCookie("playerTwoScore") + playerTwoScoreAdd;
    document.cookie = "playerOneScore=$playerOneScore; path=/";
    document.cookie = "playerTwoScore=$playerTwoScore; path=/";
  }
}

void loadCookies() {
  List<String> cookies = document.cookie!.split(";");
  for (String cookie in cookies) {
    List<String> cookieParts = cookie.split("=");
    if (cookieParts[0].trim() == "playerOneScore") {
      (querySelector("#playerOneStats") as SpanElement).text = cookieParts[1];
    } else if (cookieParts[0].trim() == "playerTwoScore") {
      (querySelector("#playerTwoStats") as SpanElement).text = cookieParts[1];
    }
  }
}