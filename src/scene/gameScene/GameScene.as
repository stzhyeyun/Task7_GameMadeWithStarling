package scene.gameScene
{
	import block.Block;
	import block.Table;
	import block.Tile;
	
	import data.DataManager;
	import data.PlayData;
	
	import scene.Scene;
	
	import starling.display.Button;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameScene extends Scene
	{
		private const NONE:int = -1;
		
		private var _table:Table;
		private var _blocks:Vector.<Block>;
		private var _selectedBlockIndex:int;

		private var _leftBlockX:Number;
		private var _leftBlockY:Number;
		private var _centerBlockX:Number;
		private var _centerBlockY:Number;
		private var _rightBlockX:Number;
		private var _rightBlockY:Number;
		
		public function GameScene(name:String)
		{
			super(name);	
			
			_table = null;
			_blocks = null;
			_selectedBlockIndex = NONE;
		}
		
		public override function initialize():void
		{
			var playData:PlayData = DataManager.playData;
			
			var ui:GameSceneUI = new GameSceneUI();
			if (playData)
			{
				ui.initialize(playData.bestScore, playData.currentScore);
				
				if (playData.table)
				{
					_table = playData.table;
				}
			}
			else
			{
				ui.initialize();

				_table = new Table();
				_table.initialize();
			}
			addChild(ui);
			addChild(_table);
			
			generateBlocks();
			addEventListener(TouchEvent.TOUCH, onTouch);
			
		}
		
		public override function dispose():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			// to do
			
			
			super.dispose();
		}
		
		private function generateBlocks():void
		{
			// to do
			
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			
			if (!touch)
			{
				return;
			}
			
			switch (touch.phase)
			{
				case TouchPhase.BEGAN:
				{
					// define which block pointed
					
				}
					break;
				
				case TouchPhase.MOVED:
				{
					// move hoding block (update position of block)
					
				}
					break;
				
				case TouchPhase.ENDED:
				{
					// set block into table
//					if (!_table.setBlock())
//					{
//						// locate block in original position
//					}
					
					// remain one block
//					if (!_table.isSettable())
//					{
//						// Game over
//					}
					
					// used blocks all
					generateBlocks();
				}
					break;
								
				default:
					break;
			}
		}
	}
}