package scene.gameScene
{
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import core.Block;
	import core.BlockData;
	import core.BlockDispenser;
	import core.Table;
	import core.TableData;
	
	import gamedata.DataManager;
	import gamedata.PlayData;
	
	import resources.Resources;
	import resources.TextureName;
	
	import scene.Scene;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import ui.popup.PopupManager;
	import ui.popup.PopupName;
	
	public class GameScene extends Scene
	{
		private const TABLE_SIZE:int = 10;
		private const BLOCK_NUM:int = 3;
		
		private var _table:Table;
		private var _blocks:Vector.<Block>; // 3 Blocks
		private var _ui:GameSceneUI;
		
		private var _tableScale:Number;
		private var _blockAreaSize:Number;
		private var _originBlockPosData:Vector.<Point>;
		
		public function GameScene()
		{
			_table = null;
			_blocks = new Vector.<Block>();
			_originBlockPosData = new Vector.<Point>();
		}
		
		public override function dispose():void
		{
			if (_table)
			{
				_table.dispose();
			}
			_table = null;
			
			_blocks = null;
			
			if (_ui)
			{
				_ui.dispose();
			}
			_ui = null;
			
			_originBlockPosData = null;
			
			super.dispose();
		}
		
		public override function initialize():void
		{
			var playData:PlayData = DataManager.playData;
			
			// Background
			var background:Image = new Image(Resources.getTexture(TextureName.BACKGROUND_GAME));
			background.width = this.nativeStageWidth;
			background.height = this.nativeStageHeight;
			addChild(background);
			
			// Table
			var tableData:TableData;
			if (playData.tableData)
			{
				tableData = playData.tableData;
			}
			else
			{
				tableData = new TableData(TABLE_SIZE);
				playData.tableData = tableData;
			}
			
			_table = new Table();
			_table.initialize(tableData);

			_tableScale =  this.nativeStageWidth * 0.8 / _table.width;
			_table.width *= _tableScale;
			_table.height *= _tableScale;
			_table.x = (this.nativeStageWidth / 2) - (_table.width / 2);
			_table.y = (this.nativeStageHeight / 2) - (_table.height / 2);
			addChild(_table);
			
			_blockAreaSize = _table.width / 3;
			
			// Block
			createBlocks();
			
			// UI
			_ui = new GameSceneUI();
			_ui.initialize(
				this.nativeStageWidth, this.nativeStageHeight,
				playData.bestScore, playData.currentScore);
			addChild(_ui);
		}
		
		protected override function onRestartScene(event:Event):void
		{
			DataManager.playData.clean();
			
			_table.setTableData(DataManager.playData.tableData);
			refreshBlocks(true);
			_ui.setScore(
				this.nativeStageWidth, this.nativeStageHeight,
				DataManager.playData.bestScore, DataManager.playData.currentScore);
		}
		
		protected override function onEndScene(event:Event):void
		{
			DataManager.export();
		}
		
		protected override function onKeyDown(event:KeyboardEvent):void
		{
			if (!this.parent)
			{
				return;
			}
			
			if (event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				PopupManager.showPopup(this, PopupName.EXIT);
			}
		}
		
		private function createBlocks():void
		{
			BlockDispenser.initialize();
			
			var bitmapData:BitmapData = new BitmapData(_blockAreaSize, _blockAreaSize);
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = 0; 
			bitmapData.colorTransform(new Rectangle(0, 0, bitmapData.width, bitmapData.height), ct);
			
			var blocksData:Vector.<BlockData> = DataManager.playData.blocksData;
			var block:Block;
			var touchArea:Image;
			for (var i:int = 0; i < BLOCK_NUM; i++)
			{
				// Block
				block = new Block(_tableScale * 0.5);
				if (!blocksData)
				{
					block.initialize(BlockDispenser.pop());
				}
				else if (blocksData && blocksData[i])
				{
					block.initialize(blocksData[i]);
				}
				else if (blocksData && !blocksData[i])
				{
					block.initialize(null);
				}
				block.x = _table.x + (_blockAreaSize / 2) + _blockAreaSize * i;  
				block.y = _table.y + _table.height + (_blockAreaSize / 2);
				addChild(block);
				
				_blocks.insertAt(i, block);
				_originBlockPosData.push(new Point(block.x, block.y));
				DataManager.playData.setBlockData(i, block.data);
				
				// Touch area
				touchArea = new Image(Texture.fromBitmapData(bitmapData));
				touchArea.name = i.toString();
				touchArea.width = _blockAreaSize;
				touchArea.height = touchArea.width;
				touchArea.x = _table.x + _blockAreaSize * i;
				touchArea.y = _table.y + _table.height;
				touchArea.addEventListener(TouchEvent.TOUCH, onTouchBlock);
				addChild(touchArea);
			}
		}
		
		private function setBlocks():void
		{
			// get blocksData from DataManager
			// set blocks
		}
			
		private function refreshBlocks(restart:Boolean = false):void
		{
			var needRefresh:Boolean = true;
			
			if (!restart)
			{
				for (var i:int = 0; i < _blocks.length; i++)
				{
					if (_blocks[i].visible)
					{
						needRefresh = false;
						break;
					}
				}
			}
			
			if (!needRefresh)
			{
				return;
			}
			
			for (i = 0; i < _blocks.length; i++)
			{
				_blocks[i].initialize(BlockDispenser.pop());
				_blocks[i].x = _originBlockPosData[i].x;  
				_blocks[i].y = _originBlockPosData[i].y;
				_blocks[i].visible = true;
				DataManager.playData.setBlockData(i, _blocks[i].data);
			}
		}
		
		private function moveBlock(block:Block, touchPos:Point):void
		{
			if (block.visible)
			{
				block.x = touchPos.x;
				block.y = touchPos.y - block.height;
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
			
			var blockIndex:int = int(touchArea.name);
			var block:Block = _blocks[blockIndex];
			
			switch (touch.phase)
			{
				case TouchPhase.BEGAN:
				{
					// 블럭 확대
					block.setSize(_tableScale);
					
					moveBlock(block, touch.getLocation(this));
				}
					break;
				
				case TouchPhase.MOVED:
				{
					moveBlock(block, touch.getLocation(this));
				}
					break;
				
				case TouchPhase.ENDED:
				{
					// 블럭 크기 원복
					block.setSize(_tableScale * 0.5);
					
					// 테이블에 블럭 세팅
					if (_table.setBlock(block))
					{
						block.visible = false;
						
						for (var i:int = 0; i < _blocks.length; i++)
						{
							if (_blocks[i].visible)
							{
								DataManager.playData.setBlockData(i, _blocks[i].data);
							}
							else
							{
								DataManager.playData.setBlockData(i);
							}
						}
					}
					else
					{
						// 블럭 원위치로
						block.x = _originBlockPosData[blockIndex].x;
						block.y = _originBlockPosData[blockIndex].y;
					}
					
					// 남은 블럭이 테이블에 세팅 가능한지 확인
					for (i = 0; i < _blocks.length; i++)
					{
						if (i != blockIndex && _blocks[i].visible)
						{
							if (!_table.isSettable(_blocks[i]))
							{
								// 종료 팝업 호출
								PopupManager.showPopup(this, PopupName.GAME_OVER);
							}
						}
					}
					
					refreshBlocks();
				}
					break;
			} // switch (touch.phase)
		} // private function onTouchBlock(event:TouchEvent):void
	}
}