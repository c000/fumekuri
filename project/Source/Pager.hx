package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.media.Sound;
import openfl.Assets;

enum State {
	Wait;
	Faint (t : Int);
	Go (t : Int);
}

class Pager extends Sprite {
	private var bitmap : Bitmap;
	private var sound : Sound;
	private var state : State;
	private var collideCount : Int;

	public function new (bitmapData : BitmapData) {
		super ();

		bitmap = new Bitmap (bitmapData);
		addChild (bitmap);
		bitmap.x = -bitmap.width;

		sound = Assets.getSound ("assets/fumekuri.wav");
	}

	public function init () {
		changeState (Wait);
	}

	public function update (condition : Float) {
		condition = Math.pow (condition, 4);

		switch (state) {
		case Wait:
			if (Math.random () < condition) {
				if (x <= 0) {
					x = Config.width + bitmap.width;
				}
				changeState (Go (0));
			} else if (Math.random () < condition * 4) {
				changeState (Faint (0));
			}
		case Faint (t):
			var cycle = t / 60;
			x = Config.width + bitmap.width - 100 * (1 - Math.cos (cycle * Math.PI * 2));
			if (cycle > 1) {
				var r = Math.random ();
				if (r < 0.2) {
					changeState (Go (0));
				} else {
					changeState (Wait);
				}
			} else {
				changeState (Faint (t+1));
			}
		case Go (t):
			var cycle = t / 120;
			x = (1 + Math.cos (cycle * Math.PI)) / 2 * (Config.width + bitmap.width);
			if (cycle > 1) {
				changeState (Wait);
			} else {
				changeState (Go (t+1));
			}
		}

		return { begin: x - width / 2, end: x };
	}

	private function changeState (newState) {
		switch (newState) {
		case Wait:
			x = -1;
		case Go (t):
			if (t == 0) {
				collideCount = 0;
				sound.play ();
			}
		default:
		}

		state = newState;
	}

	public function getCollidePos () {
		return x - 20;
	}

	public function getCollideCount () {
		return ++collideCount;
	}
}
