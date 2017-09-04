package;

class SceneManager {
	public var title(default,null) : Scene;
	public var stageSelect(default,null) : Scene;
	public var game1(default,null) : Scene;
	public var game2(default,null) : Scene;
	public var game3(default,null) : Scene;
	public var game4(default,null) : Scene;

	public var activeScene(default,null) : Scene;
	public var beforeScene(default,null) : Scene;

	public function new () {
		title = new Title (this);
		stageSelect = new StageSelect (this);
		game1 = new GameStage1 (this);
		game2 = new GameStage2 (this);
		game3 = new GameStage3 (this);
		game4 = new GameStage4 (this);
	}

	public function setActiveScene (newScene : Scene) : Scene {
		if (newScene != activeScene) {
			beforeScene = activeScene;
			activeScene = newScene;
		}

		return activeScene;
	}
}
