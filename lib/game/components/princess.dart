import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Princess extends PositionComponent {
  static const double princessSize = 50.0;

  double health = 100.0;
  double maxHealth = 100.0;

  Princess({required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(princessSize),
        anchor: Anchor.center,
      );

  @override
  void render(Canvas canvas) {
    // Рисуем эльфийку (простой круг)
    final paint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(width / 2, height / 2), princessSize / 2, paint);

    // Рисуем оковы (цепи)
    final chainPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Левая цепь
    canvas.drawLine(
      Offset(width / 4, height / 2),
      Offset(0, height),
      chainPaint,
    );

    // Правая цепь
    canvas.drawLine(
      Offset(width * 3 / 4, height / 2),
      Offset(width, height),
      chainPaint,
    );

    // Рисуем полоску здоровья оков
    final healthBarWidth = width;
    final healthBarHeight = 8.0;
    final healthBarY = height + 10;

    // Фон полоски
    final bgPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, healthBarY, healthBarWidth, healthBarHeight),
      bgPaint,
    );

    // Текущее здоровье
    final healthPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final healthWidth = (health / maxHealth) * healthBarWidth;
    canvas.drawRect(
      Rect.fromLTWH(0, healthBarY, healthWidth, healthBarHeight),
      healthPaint,
    );

    // Текст "СПАСИТЕ!"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'СПАСИТЕ!',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(width / 2 - textPainter.width / 2, -20));
  }

  void takeDamage(double damage) {
    health -= damage;
    if (health < 0) health = 0;
  }

  void heal(double amount) {
    health += amount;
    if (health > maxHealth) health = maxHealth;
  }

  bool isFreed() {
    return health <= 0;
  }
}
