import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PowerUpGate extends PositionComponent {
  static const double speed = 100.0;
  static const double gateWidth = 80.0;
  static const double gateHeight = 60.0;

  final int value; // +1, +2, -1 и т.д.

  PowerUpGate({required Vector2 position, required this.value})
    : super(
        position: position,
        size: Vector2(gateWidth, gateHeight),
        anchor: Anchor.center,
      );

  @override
  void render(Canvas canvas) {
    // Рисуем полупрозрачную стену
    final paint = Paint()
      ..color = value > 0
          ? Colors.green.withOpacity(0.5)
          : Colors.red.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    // Рисуем рамку
    final borderPaint = Paint()
      ..color = value > 0 ? Colors.green : Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), borderPaint);

    // Рисуем текст со значением
    final textPainter = TextPainter(
      text: TextSpan(
        text: value > 0 ? '+$value' : '$value',
        style: TextStyle(
          color: value > 0 ? Colors.green : Colors.red,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        width / 2 - textPainter.width / 2,
        height / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Движение вниз
    position.y += speed * dt;

    // Удаляем если вышли за экран
    if (position.y > 1000) {
      removeFromParent();
    }
  }
}
