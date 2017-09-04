package;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Sprite;
import openfl.Assets;

class ResultSprite extends Sprite {
	private var score : Int;
	private var highScore : Null<Int>;
	private var scoreSprite : NumberSprite;
	private var highScoreSprite : NumberSprite;
	private var scoreString : DisplayObject;
	private var hiscoreString : DisplayObject;

	public function new () {
		super ();

		scoreSprite = new NumberSprite ();
		addChild (scoreSprite);

		highScoreSprite = new NumberSprite ();
		highScoreSprite.y = scoreSprite.getHeight ();
		addChild (highScoreSprite);

		scoreString = new Bitmap (Assets.getBitmapData ("assets/score.png"));
		addChild (scoreString);
		hiscoreString = new Bitmap (Assets.getBitmapData ("assets/hiscore.png"));
		addChild (hiscoreString);
	}

	public function setScore (score, ?highScore) {
		this.score = score;
		this.highScore = highScore;
		updateSprites ();
	}

	private function updateSprites () {
		scoreSprite.value = score;
		scoreSprite.visible = true;
		scoreString.visible = true;
		if (highScore != null) {
			highScoreSprite.value = highScore;
			highScoreSprite.visible = true;
			hiscoreString.visible = true;
		} else {
			highScoreSprite.visible = false;
			hiscoreString.visible = false;
		}

		var maxWidth = Math.max (scoreSprite.getWidth (), highScoreSprite.getWidth ());
		scoreString.y = scoreSprite.y + scoreSprite.getHeight () - scoreString.height;
		scoreString.x = -maxWidth - hiscoreString.width;
		hiscoreString.y = highScoreSprite.y + highScoreSprite.getHeight () - hiscoreString.height;
		hiscoreString.x = -maxWidth - hiscoreString.width;
	}

	public function getWidth () : Float {
		return hiscoreString.width + Math.max (scoreSprite.getWidth(), highScoreSprite.getWidth ());
	}

	public function show () {
		visible = true;
	}
}
