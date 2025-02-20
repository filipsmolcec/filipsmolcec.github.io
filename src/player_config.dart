import 'dart:html';
import 'ball.dart';
import 'player.dart';

class PlayerConfig {
  final String name;
  final HtmlElement parentElement;
  final String humanMoveUp;
  final String humanMoveDown;

  int playerType = 0;
  int paddleHeight = 100;
  int paddleWidth = 10;
  String paddleColorHex = "#ffffff";

  PlayerConfig({
    required this.name,
    required this.parentElement,
    required this.humanMoveUp,
    required this.humanMoveDown
  }) {
    DivElement parent = DivElement();
    parent.className = "mb-2";
    parent.append(
      HeadingElement.h3()
      ..text = name
      ..style.color = "white"
    );
    
    parent.append(
      DivElement()
      ..className = "mb-2"
      ..append(
        SelectElement()
          ..className = "form-select"
          ..selectedIndex = playerType
          ..append(OptionElement(data: "Human", value: "human"))
          ..append(OptionElement(data: "AI", value: "ai"))
          ..onChange.listen((Event event) {
            SelectElement select = event.target as SelectElement;
            playerType = select.selectedIndex!;
          })
      )
    );

    parent.append(
      DivElement()
      ..className = "mb-2"
      ..append(
        createLabelForm("Paddle Height: ")
      )
      ..append(InputElement()
        ..className = "form-control"
        ..type = "number"
        ..value = paddleHeight.toString()
        ..min = "1"
        ..max = "600"
        ..onChange.listen((Event event) {
          InputElement input = event.target as InputElement;
          paddleHeight = int.parse(input.value!);
        })
      )
    );

    parent.append(
      DivElement()
      ..className = "mb-2"
      ..append(
        createLabelForm("Paddle Width: ")
      )
      ..append(InputElement()
        ..className = "form-control"
        ..type = "number"
        ..value = paddleWidth.toString()
        ..min = "1"
        ..max = "200"
        ..onChange.listen((Event event) {
          InputElement input = event.target as InputElement;
          paddleWidth = int.parse(input.value!);
        })
      )
    );

    parent.append(
      DivElement()
        ..className = "mb-2"
        ..append(
          createLabelForm("Paddle Color: ")
        )
        ..append(InputElement()
          ..className = "form-control"
          ..type = "color"
          ..value = paddleColorHex
          ..onChange.listen((Event event) {
            InputElement input = event.target as InputElement;
            paddleColorHex = input.value!;
          })
        )
    );

    parentElement.append(parent);
    parentElement.append(HRElement()..style.color = "white");
  }

  LabelElement createLabelForm(String text) {
    LabelElement label = LabelElement();
    label.append(Text(text));
    label.style.color = "white";
    label.className = "form-label";
    return label;
  }

  Player getPlayer(Ball ball) {
    if (playerType == 0) {
      return HumanPlayer(
        keyUpName: humanMoveUp,
        keyDownName: humanMoveDown,
        paddleWidth: paddleWidth,
        paddleHeight: paddleHeight,
        paddleColorHex: paddleColorHex,
        document: document
      );
    } else {
      return AIPlayer(
        ballRef: ball,
        paddleWidth: paddleWidth,
        paddleHeight: paddleHeight,
        paddleColorHex: paddleColorHex
      );
    }
  }
}