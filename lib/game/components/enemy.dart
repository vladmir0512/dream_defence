import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Enemy extends PositionComponent with CollisionCallbacks {
  static const double speed = 80.0;
  static const double enemySize = 35.0;

  int health = 3;
  final int row; // 0, 1, или 2 (три ряда)

  Enemy({required Vector2 position, required this.row})
    : super(
        position: position,
        size: Vector2.all(enemySize),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    // Рисуем врага (простой квадрат с цветом в зависимости от ряда)
    final colors = [Colors.red, Colors.orange, Colors.purple];
    final paint = Paint()
      ..color = colors[row % 3]
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    // Рисуем здоровье
    final healthPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < health; i++) {
      canvas.drawCircle(
        Offset(width / 2 + (i - 1) * 8, height / 2),
        3,
        healthPaint,
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Движение вниз к игроку
    position.y += speed * dt;

    // Удаляем врага если он вышел за экран (проверяем через gameRef)
    if (parent != null && position.y > 1000) {
      // Временное значение
      removeFromParent();
    }
  }

  void takeDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      removeFromParent();
    }
  }
}
