package;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;
import openfl.Assets;

class Character extends Sprite {
	private var characterGraphics : DisplayObject;
	private var offset : Point;

	public function new (charGraphics : DisplayObject, ?posX : Float, ?posY : Float) {
		super ();
		characterGraphics = charGraphics;
		offset = new Point (0, 0);

		addChild (characterGraphics);
		updateOffsets ();

		if (posX != null) {
			x = posX;
		}
		if (posY != null) {
			y = posY;
		}
	}

	public function move (dx : Float, dy : Float) {
		x += dx;
		y += dy;
	}

	public function updateOffsets () {
		characterGraphics.x = -characterGraphics.width / 2 + offset.x;
		characterGraphics.y = -characterGraphics.height / 2 + offset.y;
	}

	public function setOffset (inX, inY) {
		offset.x = inX;
		offset.y = inY;
		updateOffsets ();
	}
}
