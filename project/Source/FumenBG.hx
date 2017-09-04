package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.media.Sound;
import openfl.Assets;

using Lambda;

class FumenBG extends Sprite {
	private var backGround : Bitmap;
	private var successBitmapData : BitmapData;
	private var failBitmapData : BitmapData;
	private var successSound : Sound;
	private var failSound : Sound;

	private var drawings : Array<Character>;

	private static var noteY = [for (x in 0...11) 471 + x * 13];

	public function new () {
		super ();
		backGround = new Bitmap (Assets.getBitmapData ("assets/fumen.png"));
		addChild (backGround);

		successBitmapData = Assets.getBitmapData ("assets/getonpu.png");
		failBitmapData = Assets.getBitmapData ("assets/miss.png");
		successSound = Assets.getSound ("assets/good.wav");
		failSound = Assets.getSound ("assets/bad.wav");
		drawings = new Array ();
	}

	public function init () {
		drawings.iter (function (e) {
			removeChild (e);
		});
		drawings = new Array ();
	}

	private inline function addNote (pos : Float, bitmapData : BitmapData) {
		var ny = noteY[Math.floor (noteY.length * Math.random ())];
		var c = new Character (new Bitmap (bitmapData), pos, ny);
		drawings.push (c);
		addChild (c);
	}

	public function success (pos : Float) {
		successSound.play ();
		addNote (pos, successBitmapData);
	}

	public function fail (pos : Float) {
		failSound.play ();
		addNote (pos, failBitmapData);
	}

	public function wipe (area) {
		drawings.filter (function (e) {
			return area.begin <= e.x && e.x <= area.end;
		}).iter (function (e) {
			drawings.remove (e);
			removeChild (e);
		});
	}

	public function numObjects () {
		return drawings.length;
	}
}
