package
{
	import flash.filesystem.File;
	
	import media.Sound;
	
	import resources.Resources;
	import resources.SoundName;
	
	import manager.SceneManager;
	import scene.SceneName;
	import scene.loadingScene.LoadingScene;
	
	import starling.display.Sprite;
	
	public class Main extends Sprite
	{
		private static var _current:Main;

		public static function get current():Main
		{
			return _current;
		}
		
		
		public function Main()
		{
			_current = this;
			
			Resources.instance.initialize();
			Resources.instance.addEventListener(Resources.COMPLETE_LOAD, onCompleteLoad);
			Resources.instance.loadFromDisk(File.applicationDirectory.resolvePath("resources/res/first"));
		}
		
		public override function dispose():void
		{	
			_current = null;
			
			super.dispose();
		}
		
		private function onCompleteLoad():void
		{
			Resources.instance.removeEventListener(Resources.COMPLETE_LOAD, onCompleteLoad);
			
			var loadingScene:LoadingScene = new LoadingScene();
			loadingScene.initialize();
			SceneManager.addScene(SceneName.LOADING, loadingScene);
			
			var sound:Sound = Resources.instance.getSound(SoundName.MAIN_THEME);
			if (sound)
			{
				sound.loops = Sound.INFINITE;
			}
			
			SceneManager.switchScene(SceneName.LOADING);
		}
	}
}