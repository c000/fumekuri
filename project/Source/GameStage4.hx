package;

import flash.media.SoundTransform;
import openfl.Assets;

class GameStage4 extends GameBase {
	public function new (manager) {
		super (manager);
		gameMusic = new ManagedMusic (Assets.getMusic ("assets/kusonemi.mp3"), 140, new SoundTransform (1.0));
	}

	override function getPagerBitmap () {
		return Assets.getBitmapData ("assets/sheep.png");
	}

	override function getNoteBitmap () {
		return Assets.getBitmapData ("assets/4_onpu.png");
	}

	override function getCharacterGraphics () {
		return {
			animation : [
				Assets.getBitmapData ("assets/4_neko1.png"),
				Assets.getBitmapData ("assets/4_neko2.png"),
			],
			damaged : Assets.getBitmapData ("assets/4_nekoxxx.png")
		};
	}

	override function getBackgroundImage () {
		return Assets.getBitmapData ("assets/s4.png");
	}
}
