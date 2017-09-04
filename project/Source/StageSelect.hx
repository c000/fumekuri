package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.geom.Point;
import flash.text.TextField;
import openfl.Assets;
import motion.Actuate;

using Lambda;

enum SelectState {
	Run;
	ShowSprite (sp : DisplayObject);
}

class StageSelect extends Scene {
	private static inline var stageNum = 6;
	private var selectBanner : Array<Point>;
	private var playerCharacter : PlayerCharacter;
	private var selectedStage : Int;
	private var state : SelectState;

	private var whiteScreen : Sprite;
	private var howto : DisplayObject;
	private var credit : DisplayObject;

	private var bgm : Sound;
	private var channel : SoundChannel;

	public function new (manager) {
		super (manager);

		var banner = new Bitmap (Assets.getBitmapData ("assets/top.png"));
		addChild (banner);

		playerCharacter = new PlayerCharacter ([Assets.getBitmapData ("assets/neko.png")], null);
		addChild (playerCharacter);
		bgm = Assets.getMusic ("assets/kusoloop.mp3");

		selectBanner = [
			new Point (133, 320),
			new Point (290, 320),
			new Point (464, 320),
			new Point (635, 320),
			new Point (810, 320),
			new Point (1011, 320),
		];
		selectedStage = 1;

		whiteScreen = new Sprite ();
		whiteScreen.graphics.beginFill (0xFFFFFF);
		whiteScreen.graphics.drawRect (0, 0, Config.width, Config.height);
		whiteScreen.graphics.endFill ();
		whiteScreen.alpha = 0;
		addChild (whiteScreen);
		howto = new Bitmap (Assets.getBitmapData ("assets/howto.png"));
		howto.alpha = 0;
		addChild (howto);
		credit = new Bitmap (Assets.getBitmapData ("assets/staff.png"));
		credit.alpha = 0;
		addChild (credit);

		state = Run;
	}

	override function init () {
		playerCharacter.x = selectBanner[selectedStage].x;
		playerCharacter.y = selectBanner[selectedStage].y;
		channel = bgm.play (0, 255);
		changeState (Run);
	}

	private function changeState (newState) {
		switch (state) {
		case ShowSprite (object):
			Actuate.stop (whiteScreen);
			Actuate.stop (object);
			Actuate.tween (whiteScreen, 1, {alpha : 0});
			Actuate.tween (object, 1, {alpha : 0});
		default:
		}

		state = newState;

		switch (state) {
		case ShowSprite (object):
			Actuate.stop (whiteScreen);
			Actuate.stop (object);
			Actuate.tween (whiteScreen, 1, {alpha : 1});
			Actuate.tween (object, 1, {alpha : 1});
		default:
		}
	}

	override function update (input) {
		var nextScene = null;
		switch (state) {
		case Run:
			if (input.getKeyOnce (Input.Right)) {
				selectedStage = (selectedStage + 1) % stageNum;
			}
			if (input.getKeyOnce (Input.Left)) {
				selectedStage = (selectedStage - 1);
				while (selectedStage < 0) {
					selectedStage += stageNum;
				}
			}

			if (input.getKeyOnce (Input.Enter)) {
				if (selectedStage == 0) {
					changeState (ShowSprite (howto));
				} else if (selectedStage == 1) {
					nextScene = sceneManager.game1;
				} else if (selectedStage == 2) {
					nextScene = sceneManager.game2;
				} else if (selectedStage == 3) {
					nextScene = sceneManager.game3;
				} else if (selectedStage == 4) {
					nextScene = sceneManager.game4;
				} else if (selectedStage == 5) {
					changeState (ShowSprite (credit));
				}
			}
		case ShowSprite (sprite):
			if (input.getKeyOnce (Input.Enter)) {
				changeState (Run);
			}
		}

		var dr = new Point (selectBanner[selectedStage].x - playerCharacter.x, selectBanner[selectedStage].y - playerCharacter.y);
		if (0 < dr.x) {
			playerCharacter.scaleX = 1;
		} else if (dr.x < 0) {
			playerCharacter.scaleX = -1;
		}
		playerCharacter.move (dr.x / 10, dr.y / 10);

		return nextScene;
	}

	override function terminate () {
		channel.stop ();
	}
}
