package scene.gameScene
{
	import gamedata.DataManager;
	
	import resources.Resources;
	import resources.ResourcesName;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import util.Color;
	import util.SpriteNumber;

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
			
			// to do
			
			super.dispose();
		}
		
		public function initialize(stageWidth:Number, stageHeight:Number, bestScore:int = 0, currentScore:int = 0):void
		{
			// Background
			var background:Image = new Image(Resources.getTexture(ResourcesName.BACKGROUND_GAME));
			background.width = stageWidth;
			background.height = stageHeight;
			addChild(background);
			
			// Header
			//var header:Canvas = 
			
			
			// Pause
			
			
			// Best score
			_bestScore = new SpriteNumber(bestScore, Color.BEST_SCORE);
			_bestScore.x = stageWidth / 2;
			_bestScore.y = stageHeight / 4.8;
			addChild(_bestScore);
			
			// Current score
			_currentScore = new SpriteNumber(currentScore, Color.CURRENT_SCORE);
			_currentScore.x = stageWidth / 2;
			_currentScore.y = stageHeight / 6.5;
			addChild(_currentScore);
			
			DataManager.current.addEventListener(DataManager.UPDATE, onUpdateCurrentScore);
		}
		
		private function onUpdateCurrentScore(event:Event):void
		{
			_currentScore.update(int(event.data));
		}
	}
}
