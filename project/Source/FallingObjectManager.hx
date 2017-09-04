package;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

using Lambda;

class FallingObjectManager extends Sprite {
	private var collection : Array<FallingObject>;
	private var hitPointY : Float;
	private var fallingBeats : Array<Int>;
	private static var fallingTime = 4.0;
	private inline static var notes = 0.5;
	private var noteBitmap : BitmapData;

	public function new (hitPointY : Float, bitmap : BitmapData) {
		super ();
		collection = new Array ();
		this.hitPointY = hitPointY;
		this.noteBitmap = bitmap;
	}

	public function init (start : Int, end : Int) {
		generateBeats (notes, start, end);
	}

	private inline function random (max : Int) : Int {
		return Math.floor (max * Math.random());
	}

	private function generateBeats (nodeDensity : Float, start : Int, end : Int) {
		var seeds = [for (x in start ... Math.floor ((end+1) / 2)) 2 * x];
		var count = Math.floor (nodeDensity * seeds.length);
		fallingBeats = new Array ();
		for (c in 0...count) {
			var i = random (seeds.length);
			var elem = seeds[i];
			fallingBeats.push (elem);
			seeds.remove (elem);
		}
		fallingBeats.sort (function (x, y) { return y - x; });
	}

	public function iterator () {
		return collection.iterator ();
	}

	private function add (targetPos : Float) {
		var newObject = new FallingObject (hitPointY, targetPos - fallingTime, targetPos, noteBitmap);
		newObject.x = Utils.lerp (Math.random (), 120, Config.width - 70);
		addChild (newObject);
		collection.push (newObject);
	}

	public function remove (object : FallingObject) {
		removeChild (object);
		collection.remove (object);
	}

	public function removeAll () {
		collection.iter (function (object) {
			removeChild (object);
		});
		collection = new Array ();
	}

	public function update (musicBeat : Float) {
		var fallPos = fallingBeats.pop ();
		if (fallPos != null) {
			if (fallPos - fallingTime <= musicBeat) {
				add (fallPos);
			} else {
				fallingBeats.push (fallPos);
			}
		}
		collection.iter (function (e) {
			e.update (musicBeat);
		});

		var removed = collection.filter (function (e) {
			return e.end < musicBeat ;
		});
		removed.iter (function (e) {
			remove (e);
		});
		return removed;
	}
}
