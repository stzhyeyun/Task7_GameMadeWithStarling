package ui.popup
{
	import gamedata.DataManager;
	
	import resources.Resources;
	import resources.TextureName;
	
	import scene.SceneManager;
	import scene.SceneName;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import ui.SpriteNumber;
	
	import util.Color;

	public class GameOverPopup extends Popup
	{
		private var _bestScore:SpriteNumber;
		private var _currentScore:SpriteNumber;

		private var _panelWidth:Number;
		private var _panelHeight:Number;
		
		
		public function GameOverPopup()
		{
			
		}
		
		public override function initialize():void
		{
			var panel:Image = new Image(Resources.getTexture(TextureName.POPUP));
			var title:Image = new Image(Resources.getTexture(TextureName.TITLE_GAME_OVER));
			var share:Button = new Button(Resources.getTexture(TextureName.BTN_SHARE));
			var replay:Button = new Button(Resources.getTexture(TextureName.BTN_REPLAY));
			var menu:Button = new Button(Resources.getTexture(TextureName.BTN_MENU));
			var currScoreText:Image = new Image(Resources.getTexture(TextureName.TEXT_SCORE));
			var bestScoreText:Image = new Image(Resources.getTexture(TextureName.TEXT_BEST_SCORE));

			_panelWidth = panel.width;
			_panelHeight = panel.height;
			
			title.pivotX = title.width / 2;
			title.pivotY = title.height / 2;
			title.x = _panelWidth / 2;
			
			// Text
			currScoreText.pivotX = currScoreText.width / 2;
			currScoreText.pivotY = currScoreText.height / 2;
			currScoreText.x = _panelWidth / 2;
			currScoreText.y = _panelHeight * 0.2;
			
			bestScoreText.pivotX = bestScoreText.width / 2;
			bestScoreText.pivotY = bestScoreText.height / 2;
			bestScoreText.x = _panelWidth / 2;
			bestScoreText.y = _panelHeight * 0.45;
			
			// Button
			share.pivotX = share.width / 2;
			share.pivotY = share.height / 2;
			share.x = _panelWidth / 2;
			share.y = _panelHeight * 0.75;
			
			replay.pivotX = replay.width / 2;
			replay.pivotY = replay.height / 2;
			replay.x = _panelWidth * 0.35;
			replay.y = _panelHeight;
			
			menu.pivotX = menu.width / 2;
			menu.pivotY = menu.height / 2;
			menu.x = _panelWidth * 0.65;
			menu.y = _panelHeight;
			
			share.addEventListener(TouchEvent.TOUCH, onEndedShareButton);
			replay.addEventListener(TouchEvent.TOUCH, onEndedReplayButton);
			menu.addEventListener(TouchEvent.TOUCH, onEndedMenuButton);
			
			addChild(panel);
			addChild(title);
			addChild(currScoreText);
			addChild(bestScoreText);
			addChild(share);
			addChild(replay);
			addChild(menu);
			
			super.initialize();
		}
		
		public override function show():void
		{
			_bestScore = new SpriteNumber(DataManager.playData.bestScore.toString(), Color.RESULT);
			_currentScore = new SpriteNumber(DataManager.playData.currentScore.toString(), Color.RESULT);

			_bestScore.x = _panelWidth / 2;
			_bestScore.y = _panelHeight * 0.55;

			_currentScore.x = _panelWidth / 2;
			_currentScore.y = _panelHeight * 0.3;
			
			addChild(_currentScore);
			addChild(_bestScore);
			
			super.show();
		}
		
		public override function close():void
		{
			removeChild(_currentScore, true);
			removeChild(_bestScore, true);
			
			super.close();
		}
		
		private function onEndedShareButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				// to do
				
			}
		}
		
		private function onEndedReplayButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				SceneManager.restartScene();
				PopupManager.closePopup(PopupName.GAME_OVER);
			}
		}
		
		private function onEndedMenuButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				SceneManager.restartScene();
				SceneManager.switchScene(SceneName.TITLE);
				PopupManager.closePopup(PopupName.GAME_OVER);
			}
		}
	}
}