package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.media.Sound;
import flash.media.SoundTransform;
import openfl.Assets;

class PlayerCharacter extends Character {
	private static inline var moveSpeed = 16;
	private static inline var jumpPixel = -200;
	private static inline var damageTimeMax = 60;
	private var kage : Character;
	private var jumpProgress : Float;
	private var jumpDirection : Float;
	private var jumpSound : Sound;
	private var jumpSoundTransform : SoundTransform;
	private var damageSound : Sound;
	private var damageTime : Int;
	private var bitmap : Bitmap;
	private var bitmaps : Array<BitmapData>;
	private var damageBitmap : BitmapData;
	private var distance = 0;

	public function new (characterBitmap : Array<BitmapData>, damageBitmap : BitmapData) {
		bitmaps = characterBitmap;
		this.damageBitmap = damageBitmap;
		bitmap = new Bitmap (bitmaps[0]);
		super (bitmap);
		kage = new Character (new Bitmap (Assets.getBitmapData ("assets/kage.png")));
		jumpSound = Assets.getSound ("assets/jump.wav");
		jumpSoundTransform = new SoundTransform (0.5);
		damageSound = Assets.getSound ("assets/ng.wav");

		addChild (kage);
		kage.y = height / 2;
	}

	public function init () {
		jumpProgress = 0;
		jumpDirection = 0;
		damageTime = 0;
		distance = 0;
	}

	public function moveRight () {
		move (moveSpeed, 0);
		scaleX = 1;
		limitDirection ();
	}

	public function moveLeft () {
		move (-moveSpeed, 0);
		scaleX = -1;
		limitDirection ();
	}

	public function moveAnimation () {
		++distance;
	}

	private function updateAnimation () {
		if (0 < damageTime && damageBitmap != null) {
			bitmap.bitmapData = damageBitmap;
		} else {
			bitmap.bitmapData = bitmaps[Math.floor (distance / 2) % bitmaps.length];
		}
	}

	private inline function limitDirection () {
		if (x < 0 + width / 2) {
			x = 0 + width / 2;
		}
		if (Config.width - width / 2 < x) {
			x = Config.width - width / 2;
		}
	}

	public function jump () : Bool {
		if (jumpDirection == 0) {
			jumpDirection = 1 / 30;
			jumpSound.play (0, 1, jumpSoundTransform);
			return true;
		}
		return false;
	}

	public function isJumping () {
		return 0 < jumpProgress && jumpProgress < 1;
	}

	public function damage () {
		damageSound.play ();
		damageTime = damageTimeMax;
	}

	public function update () {
		jumpProgress += jumpDirection;
		if (jumpProgress > 1) {
			jumpDirection = 0;
			jumpProgress = 0;
			setOffset (0, 0);
		} else if (jumpProgress > 0) {
			setOffset (0, (-jumpProgress * jumpProgress + jumpProgress) * 4 * jumpPixel);
		}

		updateAnimation ();
		if (0 < damageTime) {
			--damageTime;
		}
	}
}
