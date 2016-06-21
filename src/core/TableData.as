package core
{
	import gamedata.DataManager;
	
	import media.SoundManager;
	
	import resources.Resources;
	import resources.SoundName;
	import resources.TextureName;
	
	import util.Index2D;

	public class TableData
	{
		private const TAG:String = "[TableData]";
		
		private var _size:int;
		private var _data:Vector.<Vector.<TileData>>;
		
		public function get size():int
		{
			return _size;
		}
		
		public function set size(value:int):void
		{
			_size = value;
		}

		public function get data():Vector.<Vector.<TileData>>
		{
			return _data;
		}
		
		public function set data(value:Vector.<Vector.<TileData>>):void
		{
			_data = value;
		}

		
		public function TableData(size:int = 0)
		{
			_size = size;
			
			if (_size != 0)
			{
				_data = new Vector.<Vector.<TileData>>;
				
				for (var i:int = 0; i < _size; i++)
				{
					_data[i] = new Vector.<TileData>();
					
					for (var j:int = 0; j < _size; j++)
					{
						_data[i].push(new TileData(i, j));
					}
				}
			}
		}
		
		/**
		 * 해당 Block을 Table에 놓을 수 있는지 검사합니다.
		 * @param blockData 검사 대상 Block의 BlockData입니다.
		 * @return 세팅 가능 여부입니다.
		 * 
		 */
		public function isSettable(blockData:BlockData):Boolean
		{
			var blockTiles:Vector.<TileData> = blockData.data;
			
			var pivotCol:int;
			var pivotRow:int;
			var prevBlockTileCol:int = blockTiles[0].col;
			var prevBlockTileRow:int = blockTiles[0].row;
			var diffCol:int = 0;
			var diffRow:int = 0;
			var isSettable:Boolean;
			
			for (var i:int = 0; i < _data.length; i++)
			{
				for (var j:int = 0; j < _data[i].length; j++)
				{
					pivotCol = i;
					pivotRow = j;
					
					isSettable = true;
					for (var k:int = 0; k < blockTiles.length; k++)
					{
 						diffCol = blockTiles[k].col - prevBlockTileCol;
						diffRow = blockTiles[k].row - prevBlockTileRow;
						
						pivotCol += diffCol;
						pivotRow += diffRow;
						
						if (pivotCol < 0 || pivotCol >= _size || pivotRow < 0 || pivotRow >= _size ||
							_data[pivotCol][pivotRow].textureName != TextureName.TILE_WHITE)
						{
							isSettable = false;
							break;
						}
						
						prevBlockTileCol = blockTiles[k].col;
						prevBlockTileRow = blockTiles[k].row;
					}
					
					if (isSettable)
					{
						return true;
					}
				}
			}

			return false;	
		}

		/**
		 * Table에 Block을 세팅할 수 있는지 검사하여 가능하다면 세팅합니다. 세팅 여부를 반환합니다. 
		 * @param pivotCol 기준 Tile의 열입니다.
		 * @param pivotRow 기준 Tile의 행입니다.
		 * @param blockData Table에 놓고자 하는 Block의 BlockData입니다.
		 * @param makeHistory TableData와 세팅한 Block을 저장하는 함수입니다.
		 * @param onUpdated TableData의 변경 내용을 Table에 적용하는 함수입니다.
		 * @return 세팅 여부입니다.
		 * 
		 */
		public function setBlock(pivotCol:int, pivotRow:int, blockData:BlockData, makeHistory:Function, onUpdated:Function):Boolean
		{
			var destTilesIndices:Vector.<Index2D> = new Vector.<Index2D>();
			
			var blockTiles:Vector.<TileData> = blockData.data;
			var prevBlockTileCol:int = blockTiles[0].col;
			var prevBlockTileRow:int = blockTiles[0].row;
			var diffCol:int = 0;
			var diffRow:int = 0;
			
			// 세팅 가능 여부 확인
			for (var i:int = 0; i < blockTiles.length; i++)
			{
				diffCol = blockTiles[i].col - prevBlockTileCol;
				diffRow = blockTiles[i].row - prevBlockTileRow;
				
				pivotCol += diffCol;
				pivotRow += diffRow;
				
				if (pivotCol < 0 || pivotCol >= _size || pivotRow < 0 || pivotRow >= _size ||
					_data[pivotCol][pivotRow].textureName != TextureName.TILE_WHITE)
				{
					destTilesIndices = null;
					blockTiles = null;
					return false;
				}
				
				destTilesIndices.push(new Index2D(pivotCol, pivotRow));

				prevBlockTileCol = blockTiles[i].col;
				prevBlockTileRow = blockTiles[i].row;
			}
			
			// 현재 데이터 히스토리화
			if (makeHistory)
			{
				makeHistory(false, clone(), destTilesIndices.length);
			}
			
			// TableData 업데이트
			for (i = 0; i < blockTiles.length; i++)
			{
				_data[destTilesIndices[i].col][destTilesIndices[i].row].textureName = blockTiles[i].textureName;
			}
			DataManager.instance.playData.tableData = this;
			SoundManager.play(Resources.instance.getSound(SoundName.SET));

			// Table(Tile) 업데이트
			if (onUpdated)
			{
				onUpdated(destTilesIndices);
			}
			
			// 라인 클리어 여부 검사
			clear(destTilesIndices, makeHistory, onUpdated);
			
			return true;
		}

		/**
		 * 라인 클리어가 가능한지 확인하고 가능하다면 클리어합니다. 
		 * @param updatedTilesIndices 변경된 TableData의 인덱스입니다.
		 * @param makeHistory TableData와 세팅한 Block을 저장하는 함수입니다.
		 * @param onUpdated TableData의 변경 내용을 Table에 적용하는 함수입니다.
		 * 
		 */
		public function clear(updatedTilesIndices:Vector.<Index2D>, makeHistory:Function, onUpdated:Function):void
		{
			var totalClearTilesIndices:Vector.<Index2D> = new Vector.<Index2D>();
			var verticalClearTilesIndices:Vector.<Index2D> = new Vector.<Index2D>();
			var horizontalClearTilesIndices:Vector.<Index2D> = new Vector.<Index2D>();
			
			var pivotCol:int;
			var pivotRow:int;
			var up:Boolean;
			var left:Boolean;
			
			// 클리어 가능 여부 확인
			for (var i:int = 0; i < updatedTilesIndices.length; i++)
			{
				// 변경된 타일 기준 위쪽 검사
				pivotCol = updatedTilesIndices[i].col;
				pivotRow = updatedTilesIndices[i].row;
				up = true;
				while (pivotRow >= 0)
				{
					if (_data[pivotCol][pivotRow].textureName == TextureName.TILE_WHITE)
					{
						up = false;
						verticalClearTilesIndices.splice(0, verticalClearTilesIndices.length);
						break;
					}
					verticalClearTilesIndices.push(new Index2D(pivotCol, pivotRow));
					pivotRow--;
				}
				
				// 아래쪽 검사
				if (up)
				{
					pivotRow = updatedTilesIndices[i].row;
					while (pivotRow < _size)
					{
						if (_data[pivotCol][pivotRow].textureName == TextureName.TILE_WHITE)
						{
							verticalClearTilesIndices.splice(0, verticalClearTilesIndices.length);
							break;
						}
						verticalClearTilesIndices.push(new Index2D(pivotCol, pivotRow));
						pivotRow++;
					}
				}
				
				// 왼쪽 검사
				pivotCol = updatedTilesIndices[i].col;
				pivotRow = updatedTilesIndices[i].row;
				left = true;
				while (pivotCol >= 0)
				{
					if (_data[pivotCol][pivotRow].textureName == TextureName.TILE_WHITE)
					{
						left = false;
						horizontalClearTilesIndices.splice(0, horizontalClearTilesIndices.length);
						break;
					}
					horizontalClearTilesIndices.push(new Index2D(pivotCol, pivotRow));
					pivotCol--;
				}
				
				// 오른쪽 검사
				if (left)
				{
					pivotCol = updatedTilesIndices[i].col;
					while (pivotCol < _size)
					{
						if (_data[pivotCol][pivotRow].textureName == TextureName.TILE_WHITE)
						{
							horizontalClearTilesIndices.splice(0, horizontalClearTilesIndices.length);
							break;
						}
						horizontalClearTilesIndices.push(new Index2D(pivotCol, pivotRow));
						pivotCol++;
					}
				}
				
				if (verticalClearTilesIndices.length > 0)
				{
					for (var j:int = 0; j < verticalClearTilesIndices.length; j++)
					{
						totalClearTilesIndices.push(verticalClearTilesIndices[j]);
					}
					verticalClearTilesIndices.splice(0, verticalClearTilesIndices.length);
				}
				
				if (horizontalClearTilesIndices.length > 0)
				{
					for (j = 0; j < horizontalClearTilesIndices.length; j++)
					{
						totalClearTilesIndices.push(horizontalClearTilesIndices[j]);
					}
					horizontalClearTilesIndices.splice(0, horizontalClearTilesIndices.length);
				}
			}
			
			// 클리어 가능한 라인이 있다면 클리어 (TableData 변경)
			if (totalClearTilesIndices.length > 0)
			{
				// 중복값 삭제
				var tempVec:Vector.<int> = new Vector.<int>();
				for (i = 0; i < totalClearTilesIndices.length; i++)
				{
					for (j = totalClearTilesIndices.length - 1; j > i; j--)
					{
						if (totalClearTilesIndices[i].equality(totalClearTilesIndices[j]))
						{
							totalClearTilesIndices.removeAt(j);
						}
					}
				}
			
				// 현재 데이터 히스토리화
				if (makeHistory)
				{
					makeHistory();
				}
				
				// TableData 업데이트
				for (i = 0; i < totalClearTilesIndices.length; i++)
				{
					_data[totalClearTilesIndices[i].col][totalClearTilesIndices[i].row].textureName = TextureName.TILE_WHITE;
				}
				DataManager.instance.playData.tableData = this;
				SoundManager.play(Resources.instance.getSound(SoundName.CLEAR));
				
				// Table(Tile) 업데이트
				if (onUpdated)
				{
					onUpdated(totalClearTilesIndices);
				}	
				
				// 점수 업데이트
				DataManager.instance.updateCurrentScore(updatedTilesIndices.length, totalClearTilesIndices.length);
			}
			else
			{
				// 점수 업데이트
				DataManager.instance.updateCurrentScore(updatedTilesIndices.length);
			}
			
			totalClearTilesIndices = null;
			verticalClearTilesIndices = null;
			horizontalClearTilesIndices = null;
			tempVec = null;
		}
		
		public function toString():String
		{
			var dataStr:String = "\n\t\"tableSize\" : " + _size.toString() +
								 ",\n\t\"tableData\" : [";
				
			for (var i:int = 0; i < _data.length; i++)
			{
				for (var j:int = 0; j < _data[i].length; j++)
				{
					if (i != 0 || j != 0)
					{
						dataStr += ", ";
					}
					dataStr += "{\"col\" : " + _data[i][j].col.toString() + "}, " +
							   "{\"row\" : " + _data[i][j].row.toString() + "}, " +
							   "{\"textureName\" : \"" + _data[i][j].textureName + "\"}";
				}
			}
			dataStr += "]";
			
			return dataStr;
		}
		
		public function clone():TableData
		{
			var tableData:TableData = new TableData(_size);
			for (var i:int = 0; i < _data.length; i++)
			{
				for (var j:int = 0; j < _data[i].length; j++)
				{
					tableData.data[i][j] = _data[i][j].clone();
				}
			}
			
			return tableData;
		}
	}
}