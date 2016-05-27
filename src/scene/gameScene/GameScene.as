package scene.gameScene
{
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
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
	
	import ui.popup.PopupManager;
	import ui.popup.PopupName;
	
	public class GameScene extends Scene
	{
		public static const SET_BLOCK:String = "setBlock";

		private const TABLE_SIZE:int = 10;
		private const BLOCK_NUM:int = 3;
		private const NONE:int = -1;
		
		private var _table:Table;
		private var _blocks:Vector.<Block>; // 3 Blocks
		
		private var _blockAreaSize:Number;
		private var _selectedBlockOriginWidth:Number;
		private var _selectedBlockOriginHeight:Number;
		private var _selectedBlockScaleX:Number;
		private var _selectedBlockScaleY:Number;
		private var _originBlockPosData:Vector.<Point>;
		
		public function GameScene()
		{
			_table = null;
			_blocks = new Vector.<Block>();
			_originBlockPosData = new Vector.<Point>();
		}
		
		public override function dispose():void
		{
			// to do
			
			super.dispose();
		}
		
		public override function initialize():void
		{
			var playData:PlayData = DataManager.playData;
			
			// UI
			var gameUI:GameSceneUI = new GameSceneUI();
			gameUI.initialize(this.nativeStageWidth, this.nativeStageHeight,
						  	  playData.bestScore, playData.currentScore);
			addChild(gameUI);
			
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

			var scale:Number =  this.nativeStageWidth * 0.8 / _table.width;
			_table.width *= scale;
			_table.height *= scale;
			_table.x = (this.nativeStageWidth / 2) - (_table.width / 2);
			_table.y = (this.nativeStageHeight / 2) - (_table.height / 2);
			addChild(_table);
			
			_blockAreaSize = _table.width / 3;
			_selectedBlockScaleX = _selectedBlockScaleY = 1.8;
			
			// Block
			createBlocks();
		}
		
		protected override function onKeyDown(event:KeyboardEvent):void
		{
			if (!this.visible)
			{
				return;
			}
			
			if (event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				PopupManager.showPopup(this, PopupName.PAUSE);
			}
		}
		
		private function createBlocks():void
		{
			BlockDispenser.initialize();
			
			var bitmapData:BitmapData = new BitmapData(_blockAreaSize, _blockAreaSize);
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = 0; 
			bitmapData.colorTransform(new Rectangle(0, 0, bitmapData.width, bitmapData.height), ct);
			
			var block:Block;
			var scale:Number = 0.5;
			var touchArea:Image;
			for (var i:int = 0; i < BLOCK_NUM; i++)
			{
				// Block
				block = new Block();
				block.initialize(BlockDispenser.pop());
				//block.scale = scale;
				block.width *= scale;
				block.height *= scale;
				block.pivotX = block.width / 2;
				block.pivotY = block.height / 2;
				block.x = _table.x + (_blockAreaSize / 2) + _blockAreaSize * i;  
				block.y = _table.y + _table.height + (_blockAreaSize / 2);
				addChild(block);
				
				_blocks.insertAt(i, block);
				_originBlockPosData.push(new Point(block.x, block.y));
				
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
				_blocks[i].pivotX = _blocks[i].width / 2;
				_blocks[i].pivotY = _blocks[i].height / 2;
				_blocks[i].x = _originBlockPosData[i].x;  
				_blocks[i].y = _originBlockPosData[i].y;
				_blocks[i].visible = true;
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
					_selectedBlockOriginWidth = block.width;
					_selectedBlockOriginHeight = block.height;
					block.width *= _selectedBlockScaleX;
					block.height *= _selectedBlockScaleY;
					
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
					block.width = _selectedBlockOriginWidth;
					block.height = _selectedBlockOriginHeight;
					
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
					for (var i:int = 0; i < _blocks.length; i++)
					{
						if (i != blockIndex)
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