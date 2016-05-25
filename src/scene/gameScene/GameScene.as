package scene.gameScene
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.Block;
	import core.BlockDispenser;
	import core.Table;
	import core.TableData;
	
	import gamedata.DataManager;
	import gamedata.PlayData;
	
	import scene.Scene;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class GameScene extends Scene
	{
		public static const SET_BLOCK:String = "setBlock";

		private const TABLE_SIZE:int = 10;
		private const BLOCK_NUM:int = 3;
		private const NONE:int = -1;
		
		private var _table:Table;
		private var _blocks:Vector.<Block>; // 3 Blocks
		private var _originBlockPosData:Vector.<Point>;
		
		public function GameScene(name:String)
		{
			super(name);	
			
			_table = null;
			_blocks = new Vector.<Block>();
			_originBlockPosData = new Vector.<Point>();
		}
		
		public override function dispose():void
		{
			// to do
			// touchArea.addEventListener(TouchEvent.TOUCH, onTouchBlock);
			
			super.dispose();
		}
		
		public override function initialize():void
		{
			var playData:PlayData = DataManager.playData;
			
			// UI
			var ui:GameSceneUI = new GameSceneUI();
			ui.initialize(playData.bestScore, playData.currentScore);
			//addChild(ui);
			
			// Table
			var tableData:TableData;
			if (playData.tableData)
			{
				tableData = playData.tableData;
			}
			else
			{
				tableData = new TableData(TABLE_SIZE);	
			}
			
			_table = new Table();
			_table.initialize(tableData);

			var scale:Number =  this.nativeStageWidth * 0.9 / _table.width;
			_table.width *= scale;
			_table.height *= scale;
			_table.x = (this.nativeStageWidth / 2) - (_table.width / 2);
			_table.y = (this.nativeStageHeight / 2) - (_table.height / 2);
			addChild(_table);
			
			// Block
			createBlocks();
		}
		
		private function createBlocks():void
		{
			BlockDispenser.initialize();
			
			var bitmapData:BitmapData = new BitmapData(_table.width / 3, _table.width / 3);
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = 0; 
			bitmapData.colorTransform(new Rectangle(0, 0, bitmapData.width, bitmapData.height), ct);
			
			var block:Block;
			var scale:Number;
			var touchArea:Image;
			for (var i:int = 0; i < BLOCK_NUM; i++)
			{
				// Block
				block = new Block();
				block.initialize(BlockDispenser.pop());
//				scale = _table.width / 3 * 0.5 / block.width;
//				block.width *= scale;
//				block.height *= scale;
				block.x = _table.x + (_table.width / 3 / 2) - (block.width / 2) + _table.width / 3 * i;  
				block.y = _table.y + _table.height + (_table.width / 3 / 2) - (block.height / 2);
				addChild(block);
				
				_blocks.insertAt(i, block);
				_originBlockPosData.push(new Point(block.x, block.y));
				
				// Touch area
				touchArea = new Image(Texture.fromBitmapData(bitmapData));
				touchArea.name = i.toString();
				touchArea.width = _table.width / 3;
				touchArea.height = touchArea.width;
				touchArea.x = _table.x + _table.width / 3 * i;
				touchArea.y = _table.y + _table.height;
				touchArea.addEventListener(TouchEvent.TOUCH, onTouchBlock);
				addChild(touchArea);
			}
		}
		
		private function refreshBlocks():void
		{
			var needRefresh:Boolean = true;
			for (var i:int = 0; i < _blocks.length; i++)
			{
				if (_blocks[i].visible)
				{
					needRefresh = false;
					break;
				}
			}
			
			if (!needRefresh)
			{
				return;
			}
			
			var scale:Number;
			for (i = 0; i < _blocks.length; i++)
			{
				_blocks[i].initialize(BlockDispenser.pop());
//				scale = _table.width / 3 * 0.5 / _blocks[i].width;
//				_blocks[i].width *= scale;
//				_blocks[i].height *= scale;
				_blocks[i].x = _originBlockPosData[i].x;  
				_blocks[i].y = _originBlockPosData[i].y;
				_blocks[i].visible = true;
			}
		}
		
		private function moveBlock(blockIndex:int, touchPos:Point):void
		{
			var block:Block = _blocks[blockIndex];
			if (block.visible)
			{
				block.x = touchPos.x - block.width / 2;
				block.y = touchPos.y - block.height * 1.2;
			}
		}
			
		private function onTouchBlock(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			var touchArea:Image = event.currentTarget as Image;
			
			if (!touch || !touchArea || !_blocks)
			{
				return;
			}
			
			switch (touch.phase)
			{
				case TouchPhase.BEGAN:
				{
					moveBlock(int(touchArea.name), touch.getLocation(this));
				}
					break;
				
				case TouchPhase.MOVED:
				{
					moveBlock(int(touchArea.name), touch.getLocation(this));
				}
					break;
				
				case TouchPhase.ENDED:
				{
					var blockIndex:int = int(touchArea.name);
					var block:Block = _blocks[blockIndex];
					
					// 테이블에 블럭 세팅
					if (_table.setBlock(block))
					{
						// 점수 갱신
						block.visible = false;
					}
					else
					{
						// 블럭 원위치로
						block.x = _originBlockPosData[blockIndex].x;
						block.y = _originBlockPosData[blockIndex].y;
					}
					
					// 남은 블럭이 테이블에 세팅 가능한지 확인
					if (!_table.isSettable(block))
					{
						// Game over
						
					}
					
					//block.visible = false; // temp
					
					refreshBlocks();
				}
					break;
			} // switch (touch.phase)
		} // private function onTouchBlock(event:TouchEvent):void
	}
}