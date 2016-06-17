package core
{
	import com.bamkie.ToastExtension;
	
	import gamedata.DataManager;
	
	import resources.Resources;
	import resources.TextureAtlasName;
	import resources.TextureName;
	
	import starling.display.Sprite;
	
	import util.Color;
	import util.Index2D;

	public class Table extends Sprite
	{
		private const TAG:String = "[Table]";
		private const NUM_UNDO:int = 5;
		
		private var _data:TableData;
		private var _tableHistory:Vector.<TableData>;
		private var _blockHistory:Vector.<int>;
		private var _tiles:Vector.<Vector.<Tile>>;
		private var _toaster:ToastExtension;

		public function get tiles():Vector.<Vector.<Tile>>
		{
			return _tiles;
		}

		public function set tiles(value:Vector.<Vector.<Tile>>):void
		{
			_tiles = value;
		}
		
		
		public function Table()
		{
			_data = null;
			_tiles = new Vector.<Vector.<Tile>>();
		}
		
		public override function dispose():void
		{
			_data = null;
			_tableHistory = null;
			_blockHistory = null;
			_toaster = null;
			
			if (_tiles)
			{
				for (var i:int = 0; i < _tiles.length; i++)
				{
					for (var j:int = 0; j < _tiles[i].length; j++)
					{
						if (_tiles[i][j])
						{
							_tiles[i][j].dispose();
							_tiles[i][j] = null;
						}
					}
					_tiles[i] = null;
				}
			}
			_tiles = null;
			
			super.dispose();
		}

		public function initialize(tableData:TableData):void
		{
			_tableHistory = new Vector.<TableData>();
			_blockHistory = new Vector.<int>();
			_toaster = new ToastExtension();
			
			_data = tableData;
			
			// Create tiles
			var data:Vector.<Vector.<TileData>> = _data.data;
			var tileData:TileData;
			var tile:Tile;
			var margin:Number = 15;
			for (var i:int = 0; i < data.length; i++)
			{
				_tiles[i] = new Vector.<Tile>();
				
				for (var j:int = 0; j < data[i].length; j++)
				{
					tileData = data[i][j];
					
					tile = new Tile(tileData);
					tile.x = tile.width * i;
					tile.y = tile.height * j;
					
					// 간격 보정
					if (i != 0)
					{
						tile.x -= tile.width / margin * i;
					}
					
					if (j != 0)
					{
						tile.y -= tile.height / margin * j;
					}
					
					// 색상 보정
					tile.color = Color.TILE;
					
					_tiles[i].push(tile);
					addChild(tile);
				}
			}
		}
		
		public function setTableData(tableData:TableData):void
		{
			if (!_tiles)
			{
				trace(TAG + " setTableData : No tiles.");
				return;
			}
			
			if (tableData)
			{
				_data = tableData;
				
				var data:Vector.<Vector.<TileData>> = _data.data;
				for (var i:int = 0; i < data.length; i++)
				{
					for (var j:int = 0; j < data[i].length; j++)
					{
						_tiles[i][j].texture = Resources.instance.getTexture(TextureAtlasName.MAIN, data[i][j].textureName);
					}
				}
			}
			else
			{
				// 초기화
				data = _data.data;
				for (i = 0; i < data.length; i++)
				{
					for (j = 0; j < data[i].length; j++)
					{
						data[i][j].textureName = TextureName.TILE_WHITE;
						_tiles[i][j].texture = Resources.instance.getTexture(TextureAtlasName.MAIN, data[i][j].textureName);
					}
				}
			}
		}
		
		public function isSettable(block:Block):Boolean
		{
			return _data.isSettable(block.data);
		}
		
		public function setBlock(block:Block):Boolean
		{
			// Determine pivot
			var primaryTarget:Tile = block.tiles[0];
			var closestDist:Number = 0;
			var dist:Number = 0;
			var pivotCol:int = 0;
			var pivotRow:int = 0;
			for (var i:int = 0; i < _tiles.length; i++)
			{
				for (var j:int = 0; j < _tiles[i].length; j++)
				{
					dist = _tiles[i][j].getDistance(primaryTarget);
					
					if (i == 0 && j == 0)
					{
						closestDist = dist;
					}
					
					if (dist < closestDist)
					{
						closestDist = dist;
						pivotCol = i;
						pivotRow = j;
					}
				}
			}
			
			return _data.setBlock(pivotCol, pivotRow, block.data, makeHistory, onUpdated);
		}
		
		public function undo():Boolean
		{
			if (!_tableHistory || _tableHistory.length <= 0)
			{
				trace(TAG + " undo : No previous data.");
				_toaster.toast("Can not UNDO no more!");
				return false;
			}

			setTableData(_tableHistory.pop());
			DataManager.instance.revertScore(_blockHistory.pop());
			
			return true;
		}
		
		private function makeHistory(lineCleared:Boolean = true, tableData:TableData = null, numblock:int = 0):void
		{
			// 테이블 히스토리화
			if (lineCleared)
			{
				// 클리어 전으로는 Undo 불가능
				_tableHistory.splice(0, _tableHistory.length);
				_blockHistory.splice(0, _blockHistory.length);
			}
			else
			{
				// 최대 5번 Undo 가능
				if (_tableHistory.length == NUM_UNDO)
				{
					_tableHistory.shift();
				}
				
				if (_blockHistory.length == NUM_UNDO)
				{
					_blockHistory.shift();
				}
				_tableHistory.push(tableData);
				_blockHistory.push(numblock);
			}
		}
		
		private function onUpdated(updatedDataIndices:Vector.<Index2D>):void
		{
			// 업데이트 된 타일 텍스처 변경
			var tileData:Vector.<Vector.<TileData>> = _data.data;
			var updatedCol:int;
			var updatedRow:int;
			for (var i:int = 0; i < updatedDataIndices.length; i++)
			{
				updatedCol = updatedDataIndices[i].col;
				updatedRow = updatedDataIndices[i].row;
				
				_tiles[updatedCol][updatedRow].texture =
					Resources.instance.getTexture(TextureAtlasName.MAIN, tileData[updatedCol][updatedRow].textureName);
			}
		}
	}
}