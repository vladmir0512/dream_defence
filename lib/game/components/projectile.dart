import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Projectile extends PositionComponent {
  static const double speed = 400.0;
  static const double projectileSize = 8.0;

  Projectile({required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(projectileSize),
        anchor: Anchor.center,
      );

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(width / 2, height / 2), projectileSize / 2, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Движение вверх
    position.y -= speed * dt;

    // Удаляем снаряд если он вышел за экран
    if (position.y < -height) {
      removeFromParent();
    }
  }
}
