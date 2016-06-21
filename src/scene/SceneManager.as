package scene
{
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	
	public class SceneManager
	{
		private static const TAG:String = "[SceneManager]";
		
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
		
		/**
		 * Scene을 등록합니다. 
		 * @param name Scene의 이름입니다.
		 * @param scene 등록할 Scene입니다.
		 * 
		 */
		public static function addScene(name:String, scene:Scene):void
		{
			if (!name || !scene)
			{
				if (!name) trace(TAG + " addScene : No name.");
				if (!scene) trace(TAG + " addScene : No scene.");
				return;
			}
			
			if (!_scenes)
			{
				_scenes = new Dictionary();
			}
			_scenes[name] = scene;
		}
		
		/**
		 * Scene응 제거합니다. 
		 * @param name 제거할 Scene의 이름입니다.
		 * 
		 */
		public static function removeScene(name:String):void
		{
			if (!name || !_scenes || !_scenes[name])
			{
				if (!name) trace(TAG + " removeScene : No name.");
				if (!_scenes) trace(TAG + " removeScene : No scenes.");
				if (!_scenes[name]) trace(TAG + " removeScene : Not registered name.");
				return;
			}
			
			var sceneToRemove:Scene = _scenes[name];
			sceneToRemove.dispose();
			sceneToRemove = null;

			delete _scenes[name];
		}
		
		/**
		 * Scene을 전환합니다. 
		 * @param nextSceneName 다음 Scene의 이름입니다.
		 * Scene.START_SCENE, Scene.END_SCENE 이벤트를 수신하여 Scene의 시작 및 종료 시점에 작업할 수 있습니다.
		 */
		public static function switchScene(nextSceneName:String):void
		{
			if (!nextSceneName || !_scenes || !_scenes[nextSceneName] || _currentSceneName == nextSceneName)
			{
				if (!nextSceneName) trace(TAG + " switchScene : No name.");
				if (!_scenes) trace(TAG + " switchScene : No scenes.");
				if (!_scenes[nextSceneName]) trace(TAG + " switchScene : Not registered scene name.");
				if (!_currentSceneName == nextSceneName) trace(TAG + " switchScene : Current scene.");
				return;
			}
			
			var currentScene:Scene;
			if (_currentSceneName)
			{
				currentScene = _scenes[_currentSceneName];
				currentScene.dispatchEvent(new Event(Scene.END_SCENE));
				Main.current.removeChild(currentScene);
			}
			
			_currentSceneName = nextSceneName;
			
			currentScene = _scenes[_currentSceneName];
			currentScene.dispatchEvent(new Event(Scene.START_SCENE));
			currentScene.visible = true;
			Main.current.addChild(currentScene);
		}
		
		/**
		 * 현재 Scene을 재시작합니다. 
		 * 
		 */
		public static function restartScene():void
		{
			if (!_scenes || !_currentSceneName)
			{
				if (!_scenes) trace(TAG + " restartScene : No scenes.");
				if (!_currentSceneName) trace(TAG + " restartScene : No name.");
				return;
			}
			
			var currentScene:Scene = _scenes[_currentSceneName];
			currentScene.dispatchEvent(new Event(Scene.RESTART_SCENE));
		}
	}
}