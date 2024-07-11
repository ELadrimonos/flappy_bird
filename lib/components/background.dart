import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_bird/game/assets.dart';
import 'package:flappy_bird/game/configuration.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';

class Background extends ParallaxComponent<FlappyBirdGame> with HasGameRef<FlappyBirdGame>{
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(Assets.background);
    size = gameRef.size;
    parallax = Parallax([
      ParallaxLayer(ParallaxImage(background, fill: LayerFill.height)),
    ]);
  }


  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = Config.gameSpeed * 0.5;
  }
}