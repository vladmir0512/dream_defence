import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Boss extends PositionComponent with CollisionCallbacks {
  static const double speed = 40.0;
  static const double bossWidth = 80.0;
  static const double bossHeight = 100.0;

  int health = 50;
  final int maxHealth = 50;

  Boss({required Vector2 position})
    : super(
        position: position,
        size: Vector2(bossWidth, bossHeight),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    // Рисуем босса (большой страшный прямоугольник)
    final paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    // Рисуем глаза
    final eyePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(width * 0.3, height * 0.3), 8, eyePaint);
    canvas.drawCircle(Offset(width * 0.7, height * 0.3), 8, eyePaint);

    // Рисуем рога
    final hornPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final hornPath = Path()
      ..moveTo(width * 0.2, 0)
      ..lineTo(width * 0.15, -20)
      ..lineTo(width * 0.25, 0)
      ..close();
    canvas.drawPath(hornPath, hornPaint);

    final hornPath2 = Path()
      ..moveTo(width * 0.8, 0)
      ..lineTo(width * 0.85, -20)
      ..lineTo(width * 0.75, 0)
      ..close();
    canvas.drawPath(hornPath2, hornPaint);

    // Полоска здоровья
    final healthBarWidth = width;
    final healthBarHeight = 10.0;
    final healthBarY = height + 5;

    final bgPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, healthBarY, healthBarWidth, healthBarHeight),
      bgPaint,
    );

    final healthPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final healthWidth = (health / maxHealth) * healthBarWidth;
    canvas.drawRect(
      Rect.fromLTWH(0, healthBarY, healthWidth, healthBarHeight),
      healthPaint,
    );

    // Текст "БОСС"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'БОСС',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(width / 2 - textPainter.width / 2, -25));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Движение вниз к игроку
    position.y += speed * dt;

    // Удаляем босса если он вышел за экран
    if (position.y > 1000) {
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
