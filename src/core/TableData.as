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
			
			DataManager.updateBestScore();
			return false;	
		}

		public function setBlock(pivotCol:int, pivotRow:int, blockData:BlockData, onUpdate:Function):Boolean
		{
			var destTilesIndices:Vector.<Index2D> = new Vector.<Index2D>();
			
			var blockTiles:Vector.<TileData> = blockData.data;
			var prevBlockTileCol:int = blockTiles[0].col;
			var prevBlockTileRow:int = blockTiles[0].row;
			var diffCol:int = 0;
			var diffRow:int = 0;
			
			// Check
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
			
			// Update data
			for (i = 0; i < blockTiles.length; i++)
			{
				_data[destTilesIndices[i].col][destTilesIndices[i].row].textureName = blockTiles[i].textureName;
			}
			DataManager.playData.tableData = this;
			SoundManager.play(Resources.getSound(SoundName.SET));

			// Update view
			if (onUpdate)
			{
				onUpdate(destTilesIndices);
			}
			
			// Clear line
			clear(destTilesIndices, onUpdate);
			
			return true;
		}

		public function clear(updatedTilesIndices:Vector.<Index2D>, onUpdate:Function):void
		{
			var totalClearTilesIndices:Vector.<Index2D> = new Vector.<Index2D>();
			var verticalClearTilesIndices:Vector.<Index2D> = new Vector.<Index2D>();
			var horizontalClearTilesIndices:Vector.<Index2D> = new Vector.<Index2D>();
			
			var pivotCol:int;
			var pivotRow:int;
			var up:Boolean;
			var left:Boolean;
			
			for (var i:int = 0; i < updatedTilesIndices.length; i++)
			{
				// Up
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
				
				// Down
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
				
				// Left
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
				
				// Right
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
			
			// Clear
			if (totalClearTilesIndices.length > 0)
			{
				// Remove duplicates
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
			
				// Update data
				for (i = 0; i < totalClearTilesIndices.length; i++)
				{
					_data[totalClearTilesIndices[i].col][totalClearTilesIndices[i].row].textureName = TextureName.TILE_WHITE;
				}
				DataManager.playData.tableData = this;
				SoundManager.play(Resources.getSound(SoundName.CLEAR));
				
				// Update view
				if (onUpdate)
				{
					onUpdate(totalClearTilesIndices);
				}	
				
				// Update score
				DataManager.updateCurrentScore(updatedTilesIndices.length, totalClearTilesIndices.length);
			}
			else
			{
				DataManager.updateCurrentScore(updatedTilesIndices.length);
			}
			
			totalClearTilesIndices = null;
			verticalClearTilesIndices = null;
			horizontalClearTilesIndices = null;
			tempVec = null;
		}
		
		public function export():String
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
	}
}