class Ball {
  Ball({
    required this.initialSpeedX,
    required this.initialSpeedY,
    required this.radius,
    required this.increaseSpeedFactor,
    required this.colorHex
  }) {
    speedX = initialSpeedX;
    speedY = initialSpeedY;
  }

  final double radius;
  final double initialSpeedX;
  final double initialSpeedY;
  final double increaseSpeedFactor;
  final String colorHex;

  double speedX = 0;
  double speedY = 0;
  
  double x = 0;
  double y = 0;

  void increaseSpeed() {
    speedX = speedX < 0 ? speedX - increaseSpeedFactor : speedX + increaseSpeedFactor;
    speedY = speedY < 0 ? speedY - increaseSpeedFactor : speedY + increaseSpeedFactor;
  }
}