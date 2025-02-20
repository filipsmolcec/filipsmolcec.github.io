import 'dart:html';
import 'game_map.dart';

Map<String, GameMap> getMaps(CanvasElement canvas) {
  return {
    "classic": GameMap(
      name: "Classic",
      obstacles: []
    ),
    "pipes": GameMap(
      name: "Pipes",
      obstacles: [
        Obstacle(
          () => canvas.width! / 2 - 10, 
          () => canvas.height! / 3 - 75,
          () => 20,
          () => (canvas.height! / 8).toInt()
        ),
        Obstacle(
          () => canvas.width! / 2 - 10,
          () => 2 * canvas.height! / 3 + 75,
          () => 20,
          () => (canvas.height! / 8).toInt()
        )
      ]
    ),
    "zig_zag": GameMap(
      name: "Zig Zag",
      obstacles: [
        Obstacle(() => canvas.width! / 4, () => canvas.height! / 4, () => 20, () => 100),
        Obstacle(() => 3 * canvas.width! / 4 - 20, () => canvas.height! / 4, () => 20, () => 100),
        Obstacle(() => canvas.width! / 2 - 10, () => 3 * canvas.height! / 4 - 50, () => 20, () => 100)
      ]
    ),
    "stairs": GameMap(
      name: "Stairs",
      obstacles: [
        Obstacle(() => canvas.width! / 5, () => canvas.height! / 5, () => 20, () => 150),
        Obstacle(() => 2 * canvas.width! / 5, () => 2 * canvas.height! / 5, () => 20, () => 150),
        Obstacle(() => 3 * canvas.width! / 5, () => 3 * canvas.height! / 5, () => 20, () => 150),
        Obstacle(() => 4 * canvas.width! / 5, () => 4 * canvas.height! / 5, () => 20, () => 150)
      ]
    )
  };
}