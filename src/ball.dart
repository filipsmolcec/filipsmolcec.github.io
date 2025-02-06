class Ball {
  Ball({required this.initialSpeedX, required this.initialSpeedY, required this.radius}) {
    speedX = initialSpeedX;
    speedY = initialSpeedY;
  }

  final double radius;
  final double initialSpeedX;
  final double initialSpeedY;

  double speedX = 0;
  double speedY = 0;
  
  double x = 0;
  double y = 0;
}