import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/components/pipe.dart';
import 'package:flappy_bird/game/configuration.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';
import 'package:flappy_bird/game/pipe_position.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final _random = Random();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;
    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = 170 + _random.nextDouble() * (heightMinusGround / 4);
    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing);

    addAll([
      Pipe(height: (centerY - spacing / 2), pipePosition: PipePosition.top),
      Pipe(
          height: (heightMinusGround - (centerY + spacing / 2)),
          pipePosition: PipePosition.bottom)
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < 8 && position.x > 3) {
      updateScore();
    }

    if (position.x < -50) {
      removeFromParent();
    }



    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }

  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play('fly.wav');
  }
}