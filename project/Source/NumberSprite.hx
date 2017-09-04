package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import openfl.Assets;

using Lambda;

class NumberSprite extends Sprite {
	private var numberMap : Map<String,BitmapData>;

	public var value(default,set_value) : Int;
	private var numbers : Array<Bitmap>;

	public function new () {
		super ();

		numberMap = new Map ();
		for (n in 0...10) {
			numberMap.set ('$n', Assets.getBitmapData ('assets/${n}.png'));
		}
		numbers = new Array ();
		value = 0;
	}

	public function getHeight () : Float {
		return numberMap.iterator ().next ().height;
	}

	public function getWidth () : Float {
		return numbers.filter (function (e) {
			return e.visible;
		}).fold (function (e, acc) {
			return acc + e.width;
		}, 0);
	}

	private function update () {
		var string = '$value';
		adjustNumbers (string.length);
		setNumberBitmap (string);
		adjustPosition (string.length);
	}

	private inline function adjustNumbers (length : Int) {
		while (numbers.length < length) {
			var bitmap = new Bitmap ();
			bitmap.y = 0;
			numbers.push (bitmap);
			addChild (bitmap);
		}
	}

	private inline function setNumberBitmap (string : String) {
		var arrString = string.split ("");
		arrString.reverse ();
		for (i in 0...arrString.length) {
			var char = numberMap.get (arrString[i]);
			if (char != null) {
				numbers[i].bitmapData = char;
			}
		}
	}

	private inline function adjustPosition (length : Int) {
		var charX : Float = 0;
		for (i in 0...numbers.length) {
			if (i < length) {
				charX -= numbers[i].width;
				numbers[i].x = charX;
				numbers[i].visible = true;
			} else {
				numbers[i].visible = false;
			}
		}
	}

	public function set_value (v) {
		value = v;
		update ();
		return value;
	}
}
