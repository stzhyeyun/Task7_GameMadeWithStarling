package scene.loadingScene
{
	import flash.filesystem.File;
	
	import manager.DataManager;
	import manager.LogInManager;
	import manager.Manager;
	import manager.NoticeManager;
	import manager.PopupManager;
	import manager.SceneManager;
	import manager.SoundManager;
	
	import media.Sound;
	
	import resources.Resources;
	import resources.SoundName;
	import resources.TextureAtlasName;
	import resources.TextureName;
	
	import scene.Scene;
	import scene.SceneName;
	import scene.gameScene.GameScene;
	import scene.titleScene.TitleScene;
	
	import starling.display.Image;
	import starling.events.Event;
	
	import ui.Gauge;

	public class LoadingScene extends Scene
	{
		private var _numLoad:int;
		private var _loadCounter:int;
		private var _loadingBar:Gauge;
		
		public function LoadingScene()
		{
			
		}
		
		public override function initialize():void
		{
			// Background
			var background:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.LOADING, TextureName.BACKGROUND_TITLE));
			background.width = this.nativeStageWidth;
			background.height = this.nativeStageHeight;
			addChild(background);
			
			// Title
			var title:Image = new Image(Resources.instance.getTexture(TextureAtlasName.LOADING, TextureName.TITLE_GAME));
			var titleScale:Number = this.nativeStageWidth * 0.8 / title.width;
			title.width *= titleScale;
			title.height *= titleScale;
			title.x = (this.nativeStageWidth / 2) - (title.width / 2);
			title.y = this.nativeStageHeight * 0.2;
			addChild(title);
			
			_numLoad = 4;
			_loadCounter = 0;
			// Loading bar
			_loadingBar = new Gauge(
				background.width * 0.7, background.height * 0.08,
				Resources.instance.getTexture(TextureAtlasName.LOADING, TextureName.IMG_GAUGE_BASE),
				Resources.instance.getTexture(TextureAtlasName.LOADING, TextureName.IMG_GAUGE_BAR),
				_numLoad);
			_loadingBar.pivotX = _loadingBar.width / 2;
			_loadingBar.pivotY = _loadingBar.height / 2;
			_loadingBar.x = this.nativeStageWidth / 2;
			_loadingBar.y = this.nativeStageHeight * 0.7;
			addChild(_loadingBar);
		}
		
		public override function dispose():void
		{
			if (_loadingBar)
			{
				_loadingBar.dispose();
			}
		}
		
		protected override function onStartScene(event:Event):void
		{
			SoundManager.play(Resources.instance.getSound(SoundName.MAIN_THEME));
			
			Resources.instance.addEventListener(Resources.COMPLETE_LOAD, onCompleteResourcesLoad);
			Resources.instance.loadFromDisk(File.applicationDirectory.resolvePath("resources/res/second"));
			
			LogInManager.instance.addEventListener(Manager.INITIALIZED, checkLoadingProgress);
			LogInManager.instance.initialize();
			
			DataManager.instance.addEventListener(Manager.INITIALIZED, checkLoadingProgress);
			DataManager.instance.initialize();
		}
		
		private function onCompleteResourcesLoad():void
		{
			Resources.instance.removeEventListener(Resources.COMPLETE_LOAD, onCompleteResourcesLoad);
			
			if (_loadingBar)
			{
				_loadingBar.update(++_loadCounter);
			}
			
			// Scene
			var titleScene:TitleScene = new TitleScene();
			titleScene.initialize();
			SceneManager.addScene(SceneName.TITLE, titleScene);
			
			var gameScene:GameScene = new GameScene();
			gameScene.initialize();
			gameScene.visible = false;
			SceneManager.addScene(SceneName.GAME, gameScene);
			
			// Sound
			var sound:Sound = Resources.instance.getSound(SoundName.SET);
			if (sound)
			{
				sound.volume = 0.5;
			}
			
			sound = Resources.instance.getSound(SoundName.CLEAR);
			if (sound)
			{
				sound.volume = 0.5;
			}

			// Popup			
			PopupManager.instance.initialize();
			
			// Notice
			NoticeManager.instance.addEventListener(Manager.INITIALIZED, checkLoadingProgress);
			NoticeManager.instance.initialize();
		}
		
		private function checkLoadingProgress():void
		{
			if (_loadingBar)
			{
				_loadingBar.update(++_loadCounter);
			}
			
			if (_loadCounter == _numLoad) 
			{
				// removeEventListener
				LogInManager.instance.addEventListener(Manager.INITIALIZED, checkLoadingProgress);
				DataManager.instance.addEventListener(Manager.INITIALIZED, checkLoadingProgress);
				NoticeManager.instance.addEventListener(Manager.INITIALIZED, checkLoadingProgress);
				
				// Switch scene
				SceneManager.switchScene(SceneName.TITLE);
			}
		}
	}
}