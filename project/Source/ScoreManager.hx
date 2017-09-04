package;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Sprite;
import motion.Actuate;
import openfl.Assets;

using Lambda;

class ScoreManager extends Sprite {
	public var score(default,null) : Int;
	public var chain(default,null) : Int;
	public var highScore(default,null) : Null<Int>;
	private var scoreNumber : NumberSprite;
	private var scoreString : DisplayObject;
	private var hoverSprites : Array<DisplayObject>;
	private var resultSprite : ResultSprite;

	public function new () {
		super ();

		highScore = null;

		scoreNumber = new NumberSprite ();
		scoreNumber.x = Config.width;
		scoreNumber.y = 0;
		addChild (scoreNumber);

		scoreString = new Bitmap (Assets.getBitmapData ("assets/score.png"));
		scoreString.y = scoreNumber.getHeight () - scoreString.height;
		addChild (scoreString);

		hoverSprites = new Array ();

		resultSprite = new ResultSprite ();
		resultSprite.y = 1.5 * scoreNumber.getHeight ();
		addChild (resultSprite);
	}

	private function updateText () {
		scoreNumber.value = score;
		scoreString.x = Config.width - scoreNumber.getWidth () - scoreString.width;
	}

	public function init () {
		score = 0;
		chain = 0;
		updateText ();

		hoverSprites.iter (function (e) {
			removeChild (e);
		});
		hoverSprites = new Array ();

		resultSprite.visible = false;
	}

	private function chainBonus () {
		if (0 < chain && chain % 10 == 0) {
			score += 1000;
		}
	}

	public function saveHighScore () {
		if (highScore == null) {
			highScore = score;
		} else if (highScore < score) {
			highScore = score;
		}
	}

	private function addHoverSprite (posX : Float, posY : Float, score : Int) {
		var newSprite = new NumberSprite ();
		newSprite.value = score;
		newSprite.x = posX + newSprite.width / 2;
		newSprite.y = posY;
		hoverSprites.push (newSprite);
		addChild (newSprite);
		Actuate.tween (newSprite, 2, {y : posY - 200, alpha : 0});
	}

	public function update () {
		updateText ();
		hoverSprites.filter (function (e) {
			return e.alpha <= 0;
		}).iter (function (e) {
			removeChild (e);
			hoverSprites.remove (e);
		});
	}

	public inline function success (posX : Float, posY : Float) {
		++chain;
		chainBonus ();
		score += 100;
		if (chain > 0) {
			addHoverSprite (posX, posY, chain);
		}
	}

	public inline function fail () {
		chain = 0;
	}

	public inline function pagerSuccess () {
	}

	public inline function pagerFail () {
		score = 0;
	}

	public inline function jump () {
		score += 3;
	}

	public inline function invalidMove () {
		score += 1;
	}

	public inline function showResult () {
		resultSprite.setScore (score, highScore);
		resultSprite.x = (Config.width + resultSprite.getWidth ()) / 2;
		resultSprite.show ();
	}
}
