package scene.loadingScene
{
	import flash.filesystem.File;
	
	import gamedata.DataManager;
	
	import media.Sound;
	import media.SoundManager;
	
	import resources.Resources;
	import resources.SoundName;
	import resources.TextureAtlasName;
	import resources.TextureName;
	
	import scene.Scene;
	import scene.SceneManager;
	import scene.SceneName;
	import scene.gameScene.GameScene;
	import scene.titleScene.TitleScene;
	
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	import system.AttendanceManager;
	import system.Manager;
	import system.NoticeManager;
	
	import ui.Gauge;
	import ui.popup.PopupManager;
	
	import user.UserManager;

	public class LoadingScene extends Scene
	{
		private var _loadingBar:Gauge;
		
		private var _numTotalLoad:int;
		private var _numPhase1Load:int;
		private var _loadCounter:int;
		
		
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
			
			var numPhase2Load:int = 2;
			_numPhase1Load = 3;
			_numTotalLoad = _numPhase1Load + numPhase2Load;
			_loadCounter = 0;
			// Loading bar
			var bar:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.LOADING, TextureName.IMG_GAUGE_BASE));
			var progress:Image = new Image( 
				Resources.instance.getTexture(TextureAtlasName.LOADING, TextureName.IMG_GAUGE_BAR));
			
			bar.width = background.width * 0.7;
			bar.height = background.height * 0.08;
			progress.width = bar.width * 0.95;
			progress.height = bar.height * 0.7;
			progress.x = bar.width * 0.02;
			progress.y = bar.height * 0.15;
						
			_loadingBar = new Gauge(bar, progress, _numTotalLoad);
			_loadingBar.pivotX = _loadingBar.width / 2;
			_loadingBar.pivotY = _loadingBar.height / 2;
			_loadingBar.x = this.nativeStageWidth / 2;
			_loadingBar.y = this.nativeStageHeight * 0.65;
			addChild(_loadingBar);
			
			this.alpha = 0;
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
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
			SoundManager.play(Resources.instance.getSound(SoundName.MAIN_THEME));
			
			Resources.instance.addEventListener(Resources.COMPLETE_LOAD, checkLoadingPhase1Progress);
			Resources.instance.loadFromDisk(File.applicationDirectory.resolvePath("resources/res/second"));
			
			UserManager.instance.addEventListener(Manager.INITIALIZED, checkLoadingPhase1Progress);
			UserManager.instance.initialize();
			
			DataManager.instance.addEventListener(Manager.INITIALIZED, checkLoadingPhase1Progress);
			DataManager.instance.initialize();
		}
		
		private function checkLoadingPhase1Progress():void
		{
			if (_loadingBar)
			{
				_loadingBar.update(++_loadCounter);
			}
			
			if (_loadCounter == _numPhase1Load) 
			{
				// removeEventListener
				Resources.instance.removeEventListener(Resources.COMPLETE_LOAD, checkLoadingPhase1Progress);
				UserManager.instance.removeEventListener(Manager.INITIALIZED, checkLoadingPhase1Progress);
				DataManager.instance.removeEventListener(Manager.INITIALIZED, checkLoadingPhase1Progress);
				
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
				PopupManager.instance.addEventListener(Manager.INITIALIZED, checkLoadingPhase2Progress);
				PopupManager.instance.initialize();
				
				// Notice
				NoticeManager.instance.addEventListener(Manager.INITIALIZED, checkLoadingPhase2Progress);
				NoticeManager.instance.initialize();
				
				// Attendance
				AttendanceManager.instance.initialize();
			}
		}
		
		private function checkLoadingPhase2Progress():void
		{
			if (_loadingBar)
			{
				_loadingBar.update(++_loadCounter);
			}
			
			if (_loadCounter == _numTotalLoad) 
			{
				// removeEventListener
				PopupManager.instance.removeEventListener(Manager.INITIALIZED, checkLoadingPhase2Progress);
				NoticeManager.instance.removeEventListener(Manager.INITIALIZED, checkLoadingPhase2Progress);
				
				// Switch scene
				SceneManager.switchScene(SceneName.TITLE);
			}
		}
		
		private function onEnterFrame(event:EnterFrameEvent):void
		{
			this.alpha += 0.05;
			
			if (this.alpha >= 1)
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			}
		}
	}
}