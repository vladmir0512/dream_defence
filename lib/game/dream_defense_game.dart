import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:dream_defense/game/components/player.dart';
import 'package:dream_defense/game/components/projectile.dart';
import 'package:dream_defense/game/components/enemy.dart';
import 'package:dream_defense/game/components/power_up_gate.dart';
import 'package:dream_defense/game/components/princess.dart';
import 'package:dream_defense/game/components/boss.dart';
import 'dart:math';

class DreamDefenseGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Player player;
  late Princess princess;
  Boss? boss;

  double shootTimer = 0;
  double spawnTimer = 0;
  double gateTimer = 0;
  int currentWave = 1;
  int enemiesSpawnedInWave = 0;
  bool bossSpawned = false;

  static const double shootInterval = 0.3;
  static const double spawnInterval = 2.0;
  static const double gateInterval = 5.0;
  static const int enemiesPerWave = 10;
  static const int bossWave = 3; // Босс появляется на 3 волне

  final Random random = Random();

  @override
  Color backgroundColor() => const Color(0xFF2C1810);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Создаем игрока внизу экрана по центру
    player = Player(position: Vector2(size.x / 2, size.y - 100));
    add(player);

    // Создаем принцессу вверху по центру
    princess = Princess(position: Vector2(size.x / 2, 100));
    add(princess);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Автоматическая стрельба
    shootTimer += dt;
    if (shootTimer >= shootInterval) {
      shootTimer = 0;
      shoot();
    }

    // Спавн врагов
    if (enemiesSpawnedInWave < enemiesPerWave) {
      spawnTimer += dt;
      if (spawnTimer >= spawnInterval) {
        spawnTimer = 0;
        spawnEnemy();
        enemiesSpawnedInWave++;
      }
    } else {
      // Проверяем, все ли враги убиты
      final enemies = children.whereType<Enemy>().toList();
      if (enemies.isEmpty && boss == null) {
        // Начинаем новую волну
        currentWave++;
        enemiesSpawnedInWave = 0;
        bossSpawned = false;

        // Спавним босса на определенной волне
        if (currentWave == bossWave) {
          spawnBoss();
        }
      }
    }

    // Спавн ворот усиления
    gateTimer += dt;
    if (gateTimer >= gateInterval) {
      gateTimer = 0;
      spawnPowerUpGate();
    }

    // Проверка коллизий
    checkCollisions();
    checkPlayerGateCollisions();
    checkPrincessShots();

    // Проверка победы/поражения
    if (princess.isFreed()) {
      // Победа! Принцесса освобождена
      // TODO: Показать экран победы
    }
  }

  void shoot() {
    // Создаем снаряды в зависимости от количества героев
    for (int i = 0; i < player.heroCount; i++) {
      final offsetX = (i - player.heroCount / 2 + 0.5) * 15;
      final projectile = Projectile(
        position: Vector2(player.position.x + offsetX, player.position.y - 20),
      );
      add(projectile);
    }
  }

  void spawnEnemy() {
    // Выбираем случайный ряд (0, 1, 2)
    final row = random.nextInt(3);

    // Позиция X зависит от ряда
    final rowPositions = [
      size.x * 0.25, // Левый ряд
      size.x * 0.5, // Центральный ряд
      size.x * 0.75, // Правый ряд
    ];

    final enemy = Enemy(position: Vector2(rowPositions[row], -50), row: row);
    add(enemy);
  }

  void spawnBoss() {
    if (!bossSpawned) {
      boss = Boss(position: Vector2(size.x / 2, -100));
      add(boss!);
      bossSpawned = true;
    }
  }

  void spawnPowerUpGate() {
    // Случайный ряд
    final row = random.nextInt(3);

    final rowPositions = [size.x * 0.25, size.x * 0.5, size.x * 0.75];

    // Случайное значение: 70% шанс на +1, 20% на +2, 10% на -1
    int value;
    final chance = random.nextDouble();
    if (chance < 0.7) {
      value = 1;
    } else if (chance < 0.9) {
      value = 2;
    } else {
      value = -1;
    }

    final gate = PowerUpGate(
      position: Vector2(rowPositions[row], -50),
      value: value,
    );
    add(gate);
  }

  void checkCollisions() {
    final projectiles = children.whereType<Projectile>().toList();
    final enemies = children.whereType<Enemy>().toList();

    for (final projectile in projectiles) {
      for (final enemy in enemies) {
        final distance = projectile.position.distanceTo(enemy.position);
        if (distance < 25) {
          enemy.takeDamage(1);
          projectile.removeFromParent();
          break;
        }
      }

      // Проверка попадания в босса
      if (boss != null) {
        final distance = projectile.position.distanceTo(boss!.position);
        if (distance < 50) {
          boss!.takeDamage(1);
          projectile.removeFromParent();
          if (boss!.health <= 0) {
            boss = null;
          }
        }
      }
    }
  }

  void checkPlayerGateCollisions() {
    final gates = children.whereType<PowerUpGate>().toList();

    for (final gate in gates) {
      final distance = player.position.distanceTo(gate.position);
      if (distance < 50) {
        player.addHeroes(gate.value);
        gate.removeFromParent();
      }
    }
  }

  void checkPrincessShots() {
    // Снаряды могут попадать в оковы принцессы
    final projectiles = children.whereType<Projectile>().toList();

    for (final projectile in projectiles) {
      final distance = projectile.position.distanceTo(princess.position);
      if (distance < 40) {
        princess.takeDamage(1); // Каждый выстрел ослабляет оковы
        projectile.removeFromParent();
      }
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // Движение игрока влево-вправо
    player.moveToX(info.eventPosition.global.x, size.x);
  }
}
