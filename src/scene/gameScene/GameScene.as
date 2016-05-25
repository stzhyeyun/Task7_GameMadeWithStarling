package scene.gameScene
{
	import block.Block;
	import block.Table;
	
	import data.DataManager;
	import data.PlayData;
	
	import scene.Scene;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameScene extends Scene
	{
		public static const SET_BLOCK:String = "setBlock";
		
		private const NONE:int = -1;
		
		private var _table:Table;
		private var _blocks:Vector.<Block>; // 3 Blocks
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
		
		public override function dispose():void
		{
			// to do
			
			
			super.dispose();
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
			
			refreshBlocks();
		}
		
		private function refreshBlocks():void
		{
			// to do
			//addEventListener(TouchEvent.TOUCH, onTouchBlock);
		}
		
		private function onTouchBlock(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			var target:Block = event.currentTarget as Block;
			
			if (!touch || !target)
			{
				return;
			}
			
			switch (touch.phase)
			{
				case TouchPhase.BEGAN:
				{
					// place block avoid finger
					
					
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
//					if (_table.setBlock())
//					{
//						//removeEventListener(TouchEvent.TOUCH, onTouchBlock);
//						//block.visible = false;
						//update score
//					}
//					else
//					{
//						//locate block in original position
//					}
					
					// check remained blocks are settable
//					if (!_table.isSettable())
//					{
//						// Game over
//					}
					
					// used blocks all
					refreshBlocks();
				}
					break;
			} // switch (touch.phase)
		} // private function onTouchBlock(event:TouchEvent):void
	}
}