package;


import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Vector;
import openfl.Assets;

class Main extends Sprite {
	private var sceneManager : SceneManager;
	private var inputManager : InputManager;

	public function new () {
		super ();

		sceneManager = new SceneManager();
		inputManager = new InputManager();
		this.changeScene (sceneManager.title);

		var whiteMask = new Sprite ();
		whiteMask.graphics.beginFill (0xFFFFFF);
		whiteMask.graphics.drawRect (0, 0, Config.width, Config.height);
		whiteMask.graphics.endFill ();
		mask = whiteMask;

		addEventListener (Event.ENTER_FRAME, update);
		stage.addEventListener (KeyboardEvent.KEY_DOWN, inputManager.keyDown);
		stage.addEventListener (KeyboardEvent.KEY_UP, inputManager.keyUp);
	}

	private function update (e : Event) {
		if (sceneManager.beforeScene != null && sceneManager.beforeScene.fading) {
			if (sceneManager.beforeScene.updateFade ()) {
				sceneManager.beforeScene.terminate ();
				removeChild (sceneManager.beforeScene);
			}
		} else if (sceneManager.activeScene.fading) {
			sceneManager.activeScene.updateFade ();
		} else {
			var newScene = sceneManager.activeScene.update (inputManager);
			if (newScene != null) {
				changeScene (newScene);
			}
		}
	}

	private function changeScene (s : Scene) {
		sceneManager.setActiveScene (s);
		if (sceneManager.beforeScene != null) {
			sceneManager.beforeScene.fadeOut ();
		}
		sceneManager.activeScene.fadeIn ();
		sceneManager.activeScene.init ();
		addChild (sceneManager.activeScene);
	}
}
