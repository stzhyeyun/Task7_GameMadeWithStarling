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
	
	import user.LoginManager;

	public class Main extends Sprite
	{
		public static const FACEBOOK_APP_ID:String = "943928415704678";
		
		private static var _current:Main;
		private static var _facebookLogin:Boolean;

		public static function get current():Main
		{
			return _current;
		}
		
		public static function get facebookLogin():Boolean
		{
			return _facebookLogin;
		}
		
		public static function set facebookLogin(value:Boolean):void
		{
			_facebookLogin = value;
		}
		
		
		public function Main()
		{
			_current = this;
			
			Resources.initialize();
			Resources.onReadyToUseResources = onCompleteLoad;
			Resources.loadFromDisk(File.applicationDirectory.resolvePath("resources/res"));
			
			DataManager.initialize();
			LoginManager.initialize();
		}
		
		public override function dispose():void
		{	
			_current = null;
			
			super.dispose();
		}
		
		private function onCompleteLoad():void
		{
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
			
			sound = Resources.getSound(SoundName.SET);
			if (sound)
			{
				sound.volume = 0.5;
			}
			
			sound = Resources.getSound(SoundName.CLEAR);
			if (sound)
			{
				sound.volume = 0.5;
			}
		}

		private function handleLogin(response:Object, fail:Object):void
		{
			if (response == null)
			{
				_facebookLogin = false;
			}
			else
			{
				_facebookLogin = true;
			}
		}
	}
}