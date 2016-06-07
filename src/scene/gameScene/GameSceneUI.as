package scene.gameScene
{
	import flash.display.BitmapData;
	
	import gamedata.DataManager;
	
	import resources.Resources;
	import resources.TextureName;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import ui.SpriteNumber;
	import ui.popup.PopupManager;
	import ui.popup.PopupName;
	
	import user.LogInManager;
	
	import util.Color;

	public class GameSceneUI extends Sprite
	{
		private var _userPic:Image;
		private var _bestScore:SpriteNumber;
		private var _currentScore:SpriteNumber;
		
		private var _headerWidth:Number;
		private var _headerHeight:Number;
		
		
		public function GameSceneUI()
		{
			
		}
		
		public override function dispose():void
		{
			DataManager.current.removeEventListener(DataManager.UPDATE, onUpdateCurrentScore);
			
			super.dispose();
		}
		
		public function initialize(stageWidth:Number, stageHeight:Number, bestScore:int, currentScore:int):void
		{
			// Header
			var bitmapData:BitmapData =
				new BitmapData(int(stageWidth), int(stageHeight / 10), false, Color.HEADER);
			var header:Image = new Image(Texture.fromBitmapData(bitmapData));
			_headerWidth = header.width;
			_headerHeight = header.height;
			addChild(header);
			
			// User picture
			//_userPic = new Image(Resources.getTexture(TextureName.DEFAULT_PICTURE));
			_userPic = new Image(null); // temp
			_userPic.height = header.height * 0.8;
			_userPic.width = _userPic.height;
			_userPic.pivotX = _userPic.width / 2;
			_userPic.pivotY = _userPic.height / 2;
			_userPic.x = header.width * 0.1;
			_userPic.y = header.height / 2;
			_userPic.visible = false;
			addChild(_userPic);
			
			// Pause
			var pauseScale:Number = 0.8;
			var pause:Button = new Button(Resources.getTexture(TextureName.BTN_PAUSE));
			pause.height = header.height * 0.8;
			pause.width = pause.height;
			pause.pivotX = pause.width / 2;
			pause.pivotY = pause.height / 2;
			pause.x = header.width * 0.9;
			pause.y = header.height / 2;
			pause.addEventListener(TouchEvent.TOUCH, onEndedPauseButton);
			addChild(pause);
			
			// Score
			setScore(stageWidth, stageHeight, bestScore, currentScore);
			
			DataManager.current.addEventListener(DataManager.UPDATE, onUpdateCurrentScore);
			Resources.current.addEventListener(Resources.USER_PICTURE_READY, onUserPictureReady);
			LogInManager.current.addEventListener(LogInManager.LOG_OUT, onLogOut);
		}
		
		public function setScore(stageWidth:Number, stageHeight:Number, bestScore:int, currentScore:int):void
		{
			// Best score
			if (_bestScore)
			{
				removeChild(_bestScore, true);
				_bestScore = null;
			}
			_bestScore = new SpriteNumber(bestScore, Color.BEST_SCORE);
			var bestScoreScale:Number = _headerHeight * 0.25 / _bestScore.height;
			_bestScore.height *= bestScoreScale;
			_bestScore.width *= bestScoreScale; 
			_bestScore.x = stageWidth / 2;
			_bestScore.y = stageHeight / 4.8;
			addChild(_bestScore);
			
			// Current score
			if (_currentScore)
			{
				removeChild(_currentScore, true);
				_currentScore = null;
			}
			_currentScore = new SpriteNumber(currentScore, Color.CURRENT_SCORE);
			var currentScoreScale:Number = _headerHeight * 0.4 / _currentScore.height;
			_currentScore.height *= currentScoreScale;
			_currentScore.width *= currentScoreScale; 
			_currentScore.x = stageWidth / 2;
			_currentScore.y = stageHeight / 6.5;
			addChild(_currentScore);
		}
		
		private function onEndedPauseButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (!touch)
			{
				return;
			}
			
			PopupManager.showPopup(this, PopupName.PAUSE);
		}
		
		private function onUpdateCurrentScore(event:Event):void
		{
			_currentScore.update(int(event.data));
		}
		
		private function onUserPictureReady(event:Event):void
		{
			_userPic.texture = Resources.getUserPicture();
			_userPic.visible = true;
		}
		
		private function onLogOut(event:Event):void
		{
			//_userPic.texture = Resources.getTexture(TextureName.DEFAULT_PICTURE);
			_userPic.visible = false; // temp
		}
	}
}
