package
{
	import flash.filesystem.File;
	
	import gamedata.DataManager;
	
	import media.Sound;
	import media.SoundManager;
	
	import resources.Resources;
	import resources.SoundName;
	
	import scene.SceneManager;
	import scene.SceneName;
	import scene.gameScene.GameScene;
	import scene.titleScene.TitleScene;
	
	import starling.display.Sprite;
	
	import ui.popup.PopupManager;

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
			
			Resources.onReadyToUseResources = onCompleteLoad;
			Resources.load(File.applicationDirectory.resolvePath("resources/res"));
		}
		
		public override function dispose():void
		{	
			_current = null;
			
			super.dispose();
		}
		
		private function onCompleteLoad():void
		{
			DataManager.initialize();
			PopupManager.initialize();

			var titleScene:TitleScene = new TitleScene();
			titleScene.initialize();
			SceneManager.addScene(SceneName.TITLE, titleScene);

			var gameScene:GameScene = new GameScene();
			gameScene.initialize();
			gameScene.visible = false;
			SceneManager.addScene(SceneName.GAME, gameScene);
			
			SceneManager.switchScene(SceneName.TITLE);
			
			var sound:Sound = Resources.getSound(SoundName.MAIN_THEME);
			if (sound)
			{
				sound.loops = Sound.INFINITE;
			}
			SoundManager.play(sound);
		}
	}
}