import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/game/assets.dart';
import 'package:flappy_bird/game/configuration.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';
import 'package:flappy_bird/screens/game_over_screen.dart';
import 'package:flutter/animation.dart';

class Bird extends SpriteComponent with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;
  double velocity = 0;

  @override
  Future<void> onLoad() async {
    final bird = await gameRef.images.load(Assets.bird);
    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    sprite = Sprite(bird);
    add(CircleHitbox());
    anchor = Anchor.center;
  }

  void fly() {
    velocity = Config.flyUpwardForce;
    FlameAudio.play(Assets.fly);
  }

  void reset() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    score = 0;
    velocity = 0;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    gameOver();
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    gameRef.overlays.add(GameOverScreen.id);
    gameRef.pauseEngine();
    gameRef.isHit = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocity += dt * Config.gravity;
    final birdNewY = position.y + velocity * dt;
    position = Vector2(position.x, birdNewY);

    // Limita la posición para que no salga de la pantalla (opcional)
    if (position.y > gameRef.size.y - size.y) {
      position.y = gameRef.size.y - size.y;
    }

    final newAngle = clampDouble(velocity / 180, -pi * 0.25, pi * 0.25);
    angle = newAngle;
  }
}
