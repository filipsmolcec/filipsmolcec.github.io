import 'dart:html';
import 'game_map.dart';

Map<String, GameMap> getMaps(CanvasElement canvas) {
  return {
    "classic": GameMap(
      name: "Classic",
      obstacles: []
    ),
    "double_slit": GameMap(
      name: "Double Slit",
      obstacles: [
        Obstacle(() => canvas.width! / 4, () => canvas.height! / 4, () => 20, () => 100),
        Obstacle(() => 3 * canvas.width! / 4 - 20, () => 3 * canvas.height! / 4 - 100, () => 20, () => 100)
      ]
    ),
    "zig_zag": GameMap(
      name: "Zig Zag",
      obstacles: [
        Obstacle(() => canvas.width! / 4, () => canvas.height! / 4, () => 20, () => 100),
        Obstacle(() => 3 * canvas.width! / 4 - 20, () => canvas.height! / 4, () => 20, () => 100),
        Obstacle(() => canvas.width! / 2 - 10, () => 3 * canvas.height! / 4 - 50, () => 20, () => 100)
      ]
    )
  };
}