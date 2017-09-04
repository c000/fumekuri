package;

import flash.display.Bitmap;
import openfl.Assets;

class FallingObject extends Character {
	public var start(default,null) : Float;
	public var end(default,null) : Float;
	public var targetY(default,null) : Float;

	public function new (targetY, start, end, bitmapData) {
		var bitmap = new Bitmap (bitmapData);
		super (bitmap);
		this.start = start;
		this.end = end;
		this.targetY = targetY;
	}

	private inline function beginY () {
		return -height / 2;
	}

	private inline function ease (a : Float, s : Float, e : Float) : Float {
		return s + a * (e - s);
	}

	public function update (musicPos : Float) {
		var a = (musicPos - start) / (end - start);
		y = ease (a, beginY (), targetY);
	}
}
