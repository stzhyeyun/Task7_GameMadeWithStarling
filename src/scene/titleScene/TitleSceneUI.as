package scene.titleScene
{
	import resources.Resources;
	import resources.TextureAtlasName;
	import resources.TextureName;
	
	import scene.SceneManager;
	import scene.SceneName;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import ui.popup.PopupManager;
	import ui.popup.PopupName;
	
	import user.UserManager;

	public class TitleSceneUI extends Sprite
	{
		private var _logInButton:Button;
		private var _logOutButton:Button;
		
		
		public function TitleSceneUI()
		{

		}
		
		public override function dispose():void
		{
			UserManager.instance.removeEventListener(UserManager.LOG_IN, onLogIn);
			UserManager.instance.removeEventListener(UserManager.LOG_OUT, onLogOut);
			
			_logInButton = null;
			_logOutButton = null;
			
			super.dispose();
		}
		
		public function initialize(stageWidth:Number, stageHeight:Number):void
		{
			// Title
			var title:Image = new Image(Resources.instance.getTexture(TextureAtlasName.LOADING, TextureName.TITLE_GAME));
			var titleScale:Number = stageWidth * 0.8 / title.width;
			title.width *= titleScale;
			title.height *= titleScale;
			title.x = (stageWidth / 2) - (title.width / 2);
			title.y = stageHeight * 0.2;
			addChild(title);
			
			// Play
			var play:Button = new Button(Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.BTN_PLAY));
			var playScale:Number = stageWidth * 0.3 / play.width;
			play.width *= playScale;
			play.height *= playScale;
			play.x = (stageWidth / 2) - (play.width / 2);
			play.y = stageHeight * 0.45;
			play.addEventListener(TouchEvent.TOUCH, onEndedPlayButton);
			addChild(play);
			
			// Rank
			var subBtnY:Number = stageHeight * 0.65;
			var rank:Button = new Button(Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.BTN_RANK));
			var subButtonScale:Number = stageWidth * 0.2 / rank.width;
			rank.width *= subButtonScale;
			rank.height *= subButtonScale;
			rank.x = (stageWidth / 2) - (rank.width * 1.5);
			rank.y = subBtnY;
			rank.addEventListener(TouchEvent.TOUCH, onEndedRankButton);
			addChild(rank);
			
			// Setting
			var setting:Button = new Button(Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.BTN_SETTING));
			setting.width *= subButtonScale;
			setting.height *= subButtonScale;
			setting.x = (stageWidth / 2) + (setting.width / 2);
			setting.y = subBtnY;
			setting.addEventListener(TouchEvent.TOUCH, onEndedSettingButton);
			addChild(setting);
			
			// LogIn
			_logInButton = new Button(Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.BTN_LOG_IN));
			_logInButton.width = play.width / 2;
			_logInButton.height = play.height / 2;
			_logInButton.x = play.x + _logInButton.width * 1.5;
			_logInButton.y = play.y;
			_logInButton.addEventListener(TouchEvent.TOUCH, onEndedLogInButton);
			if (UserManager.instance.loggedIn)
			{
				_logInButton.visible = false;
			}
			addChild(_logInButton);
			
			// LogOut
			_logOutButton = new Button(Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.BTN_LOG_OUT));
			_logOutButton.x = (stageWidth / 2 - _logOutButton.width / 2);
			_logOutButton.y = stageHeight * 0.85;
			_logOutButton.addEventListener(TouchEvent.TOUCH, onEndedLogOutButton);
			if (!UserManager.instance.loggedIn)
			{
				_logOutButton.visible = false;
			}
			addChild(_logOutButton);
			
			UserManager.instance.addEventListener(UserManager.LOG_IN, onLogIn);
			UserManager.instance.addEventListener(UserManager.LOG_OUT, onLogOut);
		}
		
		private function onEndedPlayButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
			
			if (touch)
			{
				SceneManager.switchScene(SceneName.GAME);	
			}			
		}
		
		private function onEndedRankButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
			
			if (touch)
			{
				PopupManager.instance.showPopup(this, PopupName.RANK);
			}	
		}
		
		private function onEndedSettingButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
			
			if (touch)
			{
				PopupManager.instance.showPopup(this, PopupName.SETTING);	
			}	
		}
		
		private function onEndedLogInButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
			
			if (touch)
			{
				UserManager.instance.logIn();
			}	
		}
		
		private function onEndedLogOutButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
			
			if (touch)
			{
				UserManager.instance.logOut();
			}	
		}
		
		private function onLogIn(event:Event):void
		{
			if (_logInButton)
			{
				_logInButton.visible = false;
			}
			
			if (_logOutButton)
			{
				_logOutButton.visible = true;
			}
		}
		
		private function onLogOut(event:Event):void
		{
			if (_logInButton)
			{
				_logInButton.visible = true;
			}
			
			if (_logOutButton)
			{
				_logOutButton.visible = false;
			}
		}
	}
}