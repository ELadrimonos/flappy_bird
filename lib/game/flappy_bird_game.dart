
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/components/components.dart';

import 'configuration.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection{
  late Bird bird;
  late TextComponent score;

  Timer interval = Timer(Config.pipeInterval, repeat:true);

  bool isHit = false;

  @override
  Future<void> onLoad() async {
    addAll([
      Background(),
      Ground(),
      bird = Bird(),
      score = buildScore(),
    ]);

    interval.onTick = () => add(PipeGroup());
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);

    score.text = 'Score: ${bird.score}';
  }

  TextComponent buildScore() {
    return TextComponent(
      text: 'Score: 0',
      anchor: Anchor.center,
      position: Vector2(size.x /2, size.y /2 * 0.2),
    );
  }

  @override
  void onTap() {
    super.onTap();
    bird.fly();
  }
}