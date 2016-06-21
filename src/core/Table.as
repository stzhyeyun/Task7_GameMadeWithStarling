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
			
			// 타일 생성
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
						// 변경된 테이블 데이터에 따라 타일 텍스처 변경
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
		
		/**
		 * 해당 Block을 Table에 놓을 수 있는지 검사합니다. 
		 * @param block 검사 대상 Block입니다.
		 * @return 세팅 가능 여부입니다.
		 * 
		 */
		public function isSettable(block:Block):Boolean
		{
			return _data.isSettable(block.data);
		}
		
		/**
		 * Table에 Block을 세팅할 수 있는지 검사하여 가능하다면 세팅합니다. 세팅 여부를 반환합니다.
		 * @param block Table에 놓고자 하는 Block입니다.
		 * @return 세팅 여부입니다.
		 * 
		 */
		public function setBlock(block:Block):Boolean
		{
			// 블록과 가장 가까이 있는 기준 타일을 특정
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
					
					// 가장 가까운 타일의 인덱스 저장
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
		
		/**
		 * 테이블을 직전 블록을 놓기 전으로 되돌립니다.
		 * @return Undo 실행 여부입니다.
		 * 
		 */
		public function undo():Boolean
		{
			if (!_tableHistory || _tableHistory.length <= 0)
			{
				trace(TAG + " undo : No previous data.");
				_toaster.toast("Can not UNDO no more!");
				return false;
			}

			// 테이블 되돌리기
			setTableData(_tableHistory.pop());
			
			// 점수 되돌리기
			DataManager.instance.revertScore(_blockHistory.pop());
			
			return true;
		}
		
		/**
		 * 테이블과 세팅한 블록의 히스토리를 저장합니다. 
		 * @param lineCleared 라인 클리어 여부입니다.
		 * @param tableData 현재 TableData입니다.
		 * @param numblock 세팅된 블록의 개수입니다.
		 * 
		 */
		private function makeHistory(lineCleared:Boolean = true, tableData:TableData = null, numTiles:int = 0):void
		{
			if (lineCleared)
			{
				// 클리어 전으로는 Undo 불가능
				_tableHistory.splice(0, _tableHistory.length);
				_blockHistory.splice(0, _blockHistory.length);
			}
			else
			{
				// 정해진 횟수(5번)만큼 Undo 가능
				if (_tableHistory.length == NUM_UNDO)
				{
					_tableHistory.shift();
				}
				
				if (_blockHistory.length == NUM_UNDO)
				{
					_blockHistory.shift();
				}
				
				_tableHistory.push(tableData);
				_blockHistory.push(numTiles);
			}
		}
		
		/**
		 * TableData가 변경되었을 경우 그에 따라 Tile의 텍스처를 변경합니다. 
		 * @param updatedDataIndices 변경된 TableData의 인덱스입니다.
		 * 
		 */
		private function onUpdated(updatedDataIndices:Vector.<Index2D>):void
		{
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