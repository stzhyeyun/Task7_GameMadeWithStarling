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
	
	import util.Color;

	public class GameSceneUI extends Sprite
	{
		private var _bestScore:SpriteNumber;
		private var _currentScore:SpriteNumber;
		
		
		public function GameSceneUI()
		{
			
		}
		
		public override function dispose():void
		{
			DataManager.current.removeEventListener(DataManager.UPDATE, onUpdateCurrentScore);
			
			super.dispose();
		}
		
		public function initialize(stageWidth:Number, stageHeight:Number, bestScore:int = 0, currentScore:int = 0):void
		{
			// Background
			var background:Image = new Image(Resources.getTexture(TextureName.BACKGROUND_GAME));
			background.width = stageWidth;
			background.height = stageHeight;
			addChild(background);
			
			// Header
			var bitmapData:BitmapData =
				new BitmapData(int(stageWidth), int(stageHeight / 10), false, Color.HEADER);
			var header:Image = new Image(Texture.fromBitmapData(bitmapData));
			addChild(header);
			
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
			
			// Best score
			_bestScore = new SpriteNumber(bestScore, Color.BEST_SCORE);
			var bestScoreScale:Number = header.height * 0.25 / _bestScore.height;
			_bestScore.height *= bestScoreScale;
			_bestScore.width *= bestScoreScale; 
			_bestScore.x = stageWidth / 2;
			_bestScore.y = stageHeight / 4.8;
			addChild(_bestScore);
			
			// Current score
			_currentScore = new SpriteNumber(currentScore, Color.CURRENT_SCORE);
			var currentScoreScale:Number = header.height * 0.4 / _currentScore.height;
			_currentScore.height *= currentScoreScale;
			_currentScore.width *= currentScoreScale; 
			_currentScore.x = stageWidth / 2;
			_currentScore.y = stageHeight / 6.5;
			addChild(_currentScore);
			
			DataManager.current.addEventListener(DataManager.UPDATE, onUpdateCurrentScore);
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
	}
}
