package;

import flash.display.Bitmap;
import flash.display.Sprite;
import openfl.Assets;

class LifeGauge extends Sprite {
	private var emptyHeart : Bitmap;
	private var filledHeart : Bitmap;

	public function new () {
		super ();
		emptyHeart = new Bitmap (Assets.getBitmapData ("assets/h0.png"));
		filledHeart = new Bitmap (Assets.getBitmapData ("assets/h1.png"));
		setFill ();
	}

	public function setFill () {
		if (contains (emptyHeart)) {
			removeChild (emptyHeart);
		}
		addChild (filledHeart);
	}

	public function setEmpty () {
		if (contains (filledHeart)) {
			removeChild (filledHeart);
		}
		addChild (emptyHeart);
	}
}

class Life extends Sprite {
	public var lifePoint(default,set_lifePoint) : Int;
	private var gauges : Array<LifeGauge>;
	private inline static var lifeMax = 3;

	public function new () {
		super ();
		gauges = new Array ();
		for (i in 0...lifeMax) {
			var gauge = new LifeGauge ();
			gauge.x = gauge.width * i;
			gauges.push (gauge);
			addChild (gauge);
		}
	}

	public function init () {
		lifePoint = lifeMax;
	}

	public function set_lifePoint (l) {
		if (0 <= l && l <= lifeMax) {
			lifePoint = l;
			updateLife ();
		}
		return lifePoint;
	}

	private function updateLife () {
		for (i in 0...lifeMax) {
			if (i < lifePoint) {
				gauges[i].setFill ();
			} else {
				gauges[i].setEmpty ();
			}
		}
	}
}
