package;

import flash.media.SoundTransform;
import openfl.Assets;

class GameStage2 extends GameBase {
	public function new (manager) {
		super (manager);
		gameMusic = new ManagedMusic (Assets.getMusic ("assets/yuruaco.mp3"), 170, new SoundTransform (0.8));
	}

	override function getBackgroundImage () {
		return Assets.getBitmapData ("assets/s2.png");
	}
}
