package scene
{
	import flash.utils.Dictionary;
	
	import scene.gameScene.GameScene;
	import scene.titleScene.TitleScene;
	
	public class SceneManager
	{
		private static var _scenes:Dictionary;
		private static var _currentSceneName:String;
		
		public function SceneManager()
		{
	
		}
		
		public static function dispose():void
		{
			if (_scenes)
			{
				var sceneInDic:Scene;
				for (var name:String in _scenes)
				{
					sceneInDic = _scenes[name];
					sceneInDic.dispose();
					_scenes[name] = null;
					delete _scenes[name];
				}
			}
			_scenes = null;
			
			_currentSceneName = null;
		}
		
		public static function initialize():void
		{
			_scenes = new Dictionary();
			_currentSceneName = null;
			
//			var title:TitleScene = new TitleScene(SceneName.TITLE);
//			title.initialize();
//			_scenes[title.name] = title;
//			
//			switchScene(title.name);
			
			var game:GameScene = new GameScene(SceneName.GAME);
			game.initialize(); // test
			//game.visible = false;
			_scenes[game.name] = game;
			
			switchScene(game.name);
		}
		
		public static function switchScene(nextSceneName:String):void
		{
			if (!nextSceneName || !_scenes || !_scenes[nextSceneName] || _currentSceneName == nextSceneName)
			{
				if (!nextSceneName) trace("switchScene : No name.");
				if (!_scenes) trace("switchScene : No scenes.");
				if (!_scenes[nextSceneName]) trace("switchScene : Not registered scene name.");
				if (!_currentSceneName == nextSceneName) trace("switchScene : Current scene.");
				return;
			}
			
			var currentScene:Scene;
			if (_currentSceneName)
			{
				currentScene = _scenes[_currentSceneName];
				currentScene.visible = false;
				Main.current.removeChild(currentScene);
			}
			
			_currentSceneName = nextSceneName;
			
			currentScene = _scenes[_currentSceneName];
			currentScene.visible = true;
			Main.current.addChild(currentScene);
		}
	}
}