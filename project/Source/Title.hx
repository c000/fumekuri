package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.text.TextField;
import flash.events.Event;
import openfl.Assets;

class Title extends Scene {
	private var bgm : Sound;
	private var channel : SoundChannel;

	public function new (manager : SceneManager) {
		super (manager);
		bgm = Assets.getMusic ("assets/title.mp3");

		var bg = new Bitmap (Assets.getBitmapData ("assets/logo.png"));
		addChild (bg);
	}

	override function update (input) {
		if (input.isKeyDown (Input.Enter)) {
			return sceneManager.stageSelect;
		}
		return null;
	}

	override function init () {
		channel = bgm.play (0);
	}

	override function terminate () {
		channel.stop ();
	}
}
