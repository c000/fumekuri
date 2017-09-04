package;

import flash.media.SoundTransform;
import openfl.Assets;

class GameStage3 extends GameBase {
	public function new (manager) {
		super (manager);
		gameMusic = new ManagedMusic (Assets.getMusic ("assets/KusoNight_v1.mp3"), 128, new SoundTransform (1.0));
	}

	override function getBackgroundImage () {
		return Assets.getBitmapData ("assets/s3.png");
	}
}
