package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.media.Sound;
import flash.media.SoundTransform;
import openfl.Assets;

using Lambda;

enum GameState {
	Run (t : Int);
	GameOver (t : Int);
	GameClear (t : Int);
	End (t : Int);
}

class GameBase extends Scene {
	private var playerCharacter : PlayerCharacter;
	private var fumen : FumenBG;
	private var gameMusic : ManagedMusic;
	private var fallingObjectManager : FallingObjectManager;
	private var pager : Pager;
	private var scoreManager : ScoreManager;
	private var life : Life;
	private var gameState : GameState;

	inline static var characterPosY = 350;

	private function getNoteBitmap () {
		return Assets.getBitmapData ("assets/onpu.png");
	}

	private function getPagerBitmap () {
		return Assets.getBitmapData ("assets/fumekuri0.png");
	}

	private function getBackgroundImage () : Null<BitmapData> {
		return null;
	}

	private function getCharacterGraphics () {
		return {
			animation : [
				Assets.getBitmapData ("assets/neko.png"),
				Assets.getBitmapData ("assets/neko2.png"),
			],
			damaged : Assets.getBitmapData ("assets/nekoxxx.png")
		};
	}

	public function new (manager) {
		super (manager);

		var bg = getBackgroundImage ();
		if (bg != null) {
			var backGround = new Bitmap (bg);
			addChild (backGround);
		}

		fumen = new FumenBG ();
		addChild (fumen);

		pager = new Pager (getPagerBitmap ());
		addChild (pager);

		fallingObjectManager = new FallingObjectManager (characterPosY - 100, getNoteBitmap ());
		addChild (fallingObjectManager);

		var charGraphics = getCharacterGraphics ();
		playerCharacter = new PlayerCharacter (charGraphics.animation, charGraphics.damaged);
		addChild (playerCharacter);

		scoreManager = new ScoreManager ();
		addChild (scoreManager);

		life = new Life ();
		addChild (life);
	}

	override function init () {
		playerCharacter.x = Config.width / 2;
		playerCharacter.y = characterPosY;
		playerCharacter.init ();
		initObjectManager (gameMusic.getBeatMax ());
		scoreManager.init ();
		fumen.init ();
		pager.init ();
		life.init ();
		changeGameState (Run (0));
		gameMusic.play ();
	}

	private function initObjectManager (maxBeat : Float) {
		fallingObjectManager.init (6, Math.floor (maxBeat - 8));
	}

	override function update (input) {
		var nextScene = null;
		switch (gameState) {
		case Run (t):
			var nextState = updateRun (input);
			if (nextState == null) {
				changeGameState (Run (t+1));
			} else {
				changeGameState (nextState);
			}
		case GameClear (t):
			pager.update (0);
			var enter = input.getKeyOnce (Input.Enter);
			if (t >= 60 && enter) {
				changeGameState (End (0));
			} else {
				changeGameState (GameClear (t+1));
			}
		case GameOver (t):
			nextScene = sceneManager.stageSelect;
		case End (t):
			changeGameState (End (t+1));
			nextScene = sceneManager.stageSelect;
		}
		return nextScene;
	}

	private function updateRun (input) {
		if (input.isKeyDown (Input.Right)) {
			playerCharacter.moveRight ();
			if (input.getKeyOnce (Input.Left)) {
				input.getKeyOnce (Input.Right);
				scoreManager.invalidMove ();
			}
		}
		if (input.isKeyDown (Input.Left)) {
			playerCharacter.moveLeft ();
			if (input.getKeyOnce (Input.Right)) {
				input.getKeyOnce (Input.Left);
				scoreManager.invalidMove ();
			}
		}
		if (input.isKeyDown (Input.Right) || input.isKeyDown (Input.Left)) {
			playerCharacter.moveAnimation ();
		}
		if (input.getKeyOnce (Input.Enter)) {
			if (playerCharacter.jump ()) {
				scoreManager.jump ();
			}
		}
		playerCharacter.update ();

		var removed = fallingObjectManager.update (gameMusic.getBeatPos ());
		collideSound (removed);
		collideFumekuri ();

		scoreManager.update ();
		var wipeArea = pager.update (pagerFactor (fumen.numObjects ()));
		fumen.wipe (wipeArea);

		if (life.lifePoint <= 0) {
			return GameOver (0);
		} else if (gameMusic.isPlaying ()) {
			return null;
		} else {
			return GameClear (0);
		}
	}

	private function pagerFactor (objectNum : Float) : Float {
		return objectNum / 30;
	}

	private function collideSound (note : Array<FallingObject>) {
		note.iter (function (o) {
			if (playerCharacter.hitTestPoint (o.x, o.y)) {
				scoreManager.success (o.x, o.y);
				fumen.success (o.x);
			} else {
				scoreManager.fail ();
				fumen.fail (o.x);
			}
		});
	}

	private function collideFumekuri () {
		var collidePos = pager.getCollidePos ();
		var hit : Bool = playerCharacter.hitTestPoint (collidePos, playerCharacter.y);
		if (hit) {
			var count = pager.getCollideCount ();
			if (count == 1) {
				if (playerCharacter.isJumping ()) {
					scoreManager.pagerSuccess ();
				} else {
					scoreManager.pagerFail ();
					playerCharacter.damage ();
					--life.lifePoint;
				}
			}
		}
	}

	private function changeGameState (newGameState) {
		switch (newGameState) {
			case GameClear (0):
				scoreManager.showResult ();
			case End (0):
				scoreManager.saveHighScore ();
			default:
		}
		gameState = newGameState;
	}

	override function terminate () {
		gameMusic.stop ();
		fumen.init ();
		fallingObjectManager.init (6, Math.floor (gameMusic.getBeatMax () - 8));
	}
}
