import 'dart:html';

class GameMap {
  GameMap({required this.name, required  this.obstacles});

  final String name;
  final List<Obstacle> obstacles;

  void draw(CanvasRenderingContext2D ctx) {
    for (var obstacle in obstacles) {
      obstacle.draw(ctx);
    }
  }
}

class Obstacle {
  Obstacle(this.getX, this.getY, this.getWidth, this.getHeight);
  
  double Function() getX;
  double Function() getY;
  int Function() getWidth;
  int Function() getHeight;

  void draw(CanvasRenderingContext2D ctx) {
    ctx.fillStyle = 'gray';
    ctx.fillRect(getX(), getY(), getWidth(), getHeight());
  }
}