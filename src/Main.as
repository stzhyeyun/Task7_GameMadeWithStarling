package
{
	import flash.filesystem.File;
	
	import media.Sound;
	
	import resources.Resources;
	import resources.SoundName;
	
	import scene.SceneManager;
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
			
			// 리소스 로드
			Resources.instance.addEventListener(Resources.COMPLETE_LOAD, onCompleteLoad);
			Resources.instance.loadFromDisk(File.applicationDirectory.resolvePath("resources/res/first"));
		}
		
		public override function dispose():void
		{	
			_current = null;
			
			super.dispose();
		}
		
		/**
		 * 리소스 로드가 완료되면 로딩 씬을 생성하고 시작합니다. 
		 * 
		 */
		private function onCompleteLoad():void
		{
			Resources.instance.removeEventListener(Resources.COMPLETE_LOAD, onCompleteLoad);
			
			// 로딩 씬 생성
			var loadingScene:LoadingScene = new LoadingScene();
			loadingScene.initialize();
			SceneManager.addScene(SceneName.LOADING, loadingScene);
			
			// 사운드 세팅
			var sound:Sound = Resources.instance.getSound(SoundName.MAIN_THEME);
			if (sound)
			{
				sound.loops = Sound.INFINITE;
			}
			
			// 로딩 씬 시작
			SceneManager.switchScene(SceneName.LOADING);
		}
	}
}