package;

import flash.display.Sprite;

class Scene extends Sprite {
	private var sceneManager : SceneManager;
	public var fading(default,null) : Bool;
	private var fadeDirection : Float;

	public function new (manager : SceneManager) {
		super ();
		sceneManager = manager;
	}

	public function init () : Void { }
	public function update (input : InputManager) : Null<Scene> { return null; }
	public function terminate () : Void { }

	public function isOpaque () : Bool {
		return alpha > 0;
	}

	public function fadeIn () {
		alpha = 0;
		fading = true;
		fadeDirection = 1.0 / 60;
	}

	public function fadeOut () {
		alpha = 1;
		fading = true;
		fadeDirection = -1.0 / 60;
	}

	public function updateFade () {
		alpha += fadeDirection;
		if (alpha <= 0) {
			alpha = 0;
			fading = false;
		}
		if (1 <= alpha) {
			alpha = 1;
			fading = false;
		}
		return !fading;
	}
}
