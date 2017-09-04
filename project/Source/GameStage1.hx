package;

import flash.media.SoundTransform;
import openfl.Assets;

class GameStage1 extends GameBase {
	public function new (manager) {
		super (manager);
		gameMusic = new ManagedMusic (Assets.getMusic ("assets/kusoge_stage1_v1.mp3"), 140, new SoundTransform (1.0));
	}

	override function getBackgroundImage () {
		return Assets.getBitmapData ("assets/s1.png");
	}
}
