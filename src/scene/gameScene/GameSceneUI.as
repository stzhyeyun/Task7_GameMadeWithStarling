package scene.gameScene
{
	import gamedata.DataManager;
	
	import resources.Resources;
	import resources.ResourcesName;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class GameSceneUI extends Sprite
	{
		private const BEST_SCORE_COLOR:uint = 0xe6f7ff;
		private const CURRENT_SCORE_COLOR:uint = 0x0077b3;
		
		private var _bestScoreRoot:Sprite;
		private var _currentScoreRoot:Sprite;
		private var _bestScoreNumbers:Vector.<Image>;
		private var _currentScoreNumbers:Vector.<Image>;
		
		
		public function GameSceneUI()
		{
			_bestScoreNumbers = new Vector.<Image>();
			_currentScoreNumbers = new Vector.<Image>();
		}
		
		public function initialize(stageWidth:Number, stageHeight:Number, bestScore:int = 0, currentScore:int = 0):void
		{
			// Background
			var background:Image = new Image(Resources.getTexture(ResourcesName.BACKGROUND_GAME));
			background.width = stageWidth;
			background.height = stageHeight;
			addChild(background);
			
			// Best score
			_bestScoreRoot = new Sprite();
			_bestScoreRoot.x = stageWidth / 2;
			_bestScoreRoot.y = stageHeight / 4.8;
			
			var bestScoreStr:String = bestScore.toString();
			var initialBestScore:Image;
			var bestScoreWidth:Number = 0;
			for (var i:int = 0; i < bestScoreStr.length; i++)
			{
				initialBestScore = new Image(Resources.getTexture(bestScoreStr.charAt(i)));
				_bestScoreNumbers.push(initialBestScore);
				
				bestScoreWidth += initialBestScore.width;
			}
			
			
			var left:Number = -(bestScoreWidth / 2);
			var widthSoFar:Number = 0;
			for (i = 0; i < _bestScoreNumbers.length; i++)
			{
				_bestScoreNumbers[i].pivotX = _bestScoreNumbers[i].width / 2;
				_bestScoreNumbers[i].pivotY = _bestScoreNumbers[i].height / 2;
				_bestScoreNumbers[i].x = left + widthSoFar + _bestScoreNumbers[i].width / 2;
				_bestScoreNumbers[i].color = BEST_SCORE_COLOR;
				_bestScoreRoot.addChild(_bestScoreNumbers[i]);
				
				widthSoFar += _bestScoreNumbers[i].width;
			}
			addChild(_bestScoreRoot);
			
			// Current score
			_currentScoreRoot = new Sprite();
			_currentScoreRoot.x = stageWidth / 2;
			_currentScoreRoot.y = stageHeight / 6.5;
			
			var currentScoreStr:String = currentScore.toString();
			var initialCurrentScore:Image;
			var currentScoreWidth:Number = 0;
			for (i = 0; i < currentScoreStr.length; i++)
			{
				initialCurrentScore = new Image(Resources.getTexture(currentScoreStr.charAt(i)));
				_currentScoreNumbers.push(initialCurrentScore);
				
				currentScoreWidth += initialCurrentScore.width;
			}
			
			left = -(currentScoreWidth / 2);
			widthSoFar = 0;
			for (i = 0; i < _currentScoreNumbers.length; i++)
			{
				_currentScoreNumbers[i].pivotX = _currentScoreNumbers[i].width / 2;
				_currentScoreNumbers[i].pivotY = _currentScoreNumbers[i].height / 2;
				_currentScoreNumbers[i].x = left + widthSoFar + _currentScoreNumbers[i].width / 2;
				_currentScoreNumbers[i].color = CURRENT_SCORE_COLOR;
				_currentScoreRoot.addChild(_currentScoreNumbers[i]);

				widthSoFar += _currentScoreNumbers[i].width;
			}
			addChild(_currentScoreRoot);
			
			// Pause
			
			
			
			
			DataManager.current.addEventListener(DataManager.UPDATE, onUpdateCurrentScore);
		}
		
		private function onUpdateCurrentScore(event:Event):void
		{
			_currentScoreRoot.removeChildren();
			
			var currentScoreStr:String = event.data.toString();
			
			var currentScoreNumbers:Vector.<Image> = new Vector.<Image>();
			var initialCurrentScore:Image;
			var currentScoreWidth:Number = 0;
			for (var i:int = 0; i < currentScoreStr.length; i++)
			{
				initialCurrentScore = new Image(Resources.getTexture(currentScoreStr.charAt(i)));
				currentScoreNumbers.push(initialCurrentScore);
				
				currentScoreWidth += initialCurrentScore.width;
			}
			
			var left:Number = -(currentScoreWidth / 2);
			var widthSoFar:Number = 0;
			for (i = 0; i < currentScoreStr.length; i++)
			{
				currentScoreNumbers[i].pivotX = currentScoreNumbers[i].width / 2;
				currentScoreNumbers[i].pivotY = currentScoreNumbers[i].height / 2;
				currentScoreNumbers[i].x = left + widthSoFar + currentScoreNumbers[i].width / 2;
				currentScoreNumbers[i].color = CURRENT_SCORE_COLOR;
				_currentScoreRoot.addChild(currentScoreNumbers[i]);
				
				widthSoFar += currentScoreNumbers[i].width;
			}
			
			
			
//			var image:Image;
//			var texture:Texture;
//			var maxWidth:Number;
//			for (var i:int = 0; i < currentScoreStr.length; i++)
//			{
//				if (i >= _currentScoreNumbers.length)
//				{
//					image = new Image(Resources.getTexture(currentScoreStr.charAt(i)));
//					image.color = CURRENT_SCORE_COLOR;
//					
//					_currentScoreRoot.addChild(image);
//					_currentScoreNumbers.push(image);
//				}
//				else
//				{
//					texture = Resources.getTexture(currentScoreStr.charAt(i));
//					_currentScoreNumbers[i].width = texture.width;
//					_currentScoreNumbers[i].height = texture.height;
//					_currentScoreNumbers[i].texture = Resources.getTexture(currentScoreStr.charAt(i));
//				}
//				
//				if (i == 0)
//				{
//					maxWidth = _currentScoreNumbers[i].width;
//				}
//				
//				if (_currentScoreNumbers[i].width > maxWidth)
//				{
//					maxWidth = _currentScoreNumbers[i].width;
//				}
//				
//				//currentScoreWidth += _currentScoreNumbers[i].width;
//			}
//			
//			var currentScoreWidth:Number = maxWidth * _currentScoreNumbers.length;
//			var left:Number = -(currentScoreWidth / 2);
//			var widthSoFar:Number = 0;
//			for (i = 0; i < _currentScoreNumbers.length; i++)
//			{
//				_currentScoreNumbers[i].pivotX = maxWidth / 2;
//				_currentScoreNumbers[i].pivotY = _currentScoreNumbers[i].height / 2;
//				_currentScoreNumbers[i].x = left + widthSoFar + maxWidth / 2;
//				
//				widthSoFar += maxWidth;
//				
////				_currentScoreNumbers[i].pivotX = _currentScoreNumbers[i].width / 2;
////				_currentScoreNumbers[i].pivotY = _currentScoreNumbers[i].height / 2;
////				_currentScoreNumbers[i].x = left + widthSoFar + _currentScoreNumbers[i].width / 2;
////								
////				widthSoFar += _currentScoreNumbers[i].width;
//			}
		}
	}
}