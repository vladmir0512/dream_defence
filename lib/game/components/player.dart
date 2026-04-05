import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  static const double speed = 300.0;
  static const double playerSize = 40.0;

  int heroCount = 1; // Количество героев

  Player({required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(playerSize),
        anchor: Anchor.center,
      );

  @override
  void render(Canvas canvas) {
    // Рисуем героя (простой треугольник)
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(width / 2, 0)
      ..lineTo(0, height)
      ..lineTo(width, height)
      ..close();

    canvas.drawPath(path, paint);

    // Рисуем количество героев
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'x$heroCount',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(width / 2 - textPainter.width / 2, height + 5),
    );
  }

  void moveToX(double targetX, double gameWidth) {
    position.x = targetX.clamp(width / 2, gameWidth - width / 2);
  }

  void addHeroes(int count) {
    heroCount += count;
    if (heroCount < 1) heroCount = 1;
  }
}
