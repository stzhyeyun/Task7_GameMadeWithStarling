package core
{
	import gamedata.DataManager;
	
	import resources.ResourcesName;
	
	import starling.events.Event;

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
							_data[pivotCol][pivotRow].textureName != ResourcesName.WHITE)
						{
							isSettable = false;
							break;
						}
						
						prevBlockTileCol = blockTiles[k].col;
						prevBlockTileRow = blockTiles[k].row;
					}
					
					if (isSettable)
					{
						trace("isSettable : The block is settable."); // test
						return true;
					}
				}
			}
			
			return false;	
		}

		public function setBlock(pivotCol:int, pivotRow:int, blockData:BlockData, onUpdate:Function):Boolean
		{
			var destTilesIndices:Vector.<int> = new Vector.<int>();
			
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
					_data[pivotCol][pivotRow].textureName != ResourcesName.WHITE)
				{
					destTilesIndices = null;
					blockTiles = null;
					return false;
				}
				
				destTilesIndices.push(pivotCol);
				destTilesIndices.push(pivotRow);

				prevBlockTileCol = blockTiles[i].col;
				prevBlockTileRow = blockTiles[i].row;
			}
			
			// Set
			var destIndex:int = 0;
			for (i = 0; i < blockTiles.length; i++)
			{
				_data[destTilesIndices[destIndex]][destTilesIndices[destIndex + 1]].textureName = blockTiles[i].textureName;
				destIndex += 2;
			}
			
			if (onUpdate)
			{
				onUpdate(destTilesIndices);
			}
			clear(destTilesIndices, onUpdate);
			
			//DataManager.current.addEventListener(DataManager.UPDATE, onTest); // test
			
			return true;
		}
		
		private function onTest(event:Event):void
		{
			trace("onTest : Listened event."); 
		}
		
		public function clear(updatedTilesIndices:Vector.<int>, onUpdate:Function):void
		{
			var totalClearTilesIndices:Vector.<int> = new Vector.<int>();
			
			var verticalClearTilesIndices:Vector.<int> = new Vector.<int>();
			var horizontalClearTilesIndices:Vector.<int> = new Vector.<int>();
			var pivotCol:int;
			var pivotRow:int;
			var up:Boolean;
			var left:Boolean;
			for (var i:int = 0; i < updatedTilesIndices.length; i += 2)
			{
				// Up
				pivotCol = updatedTilesIndices[i];
				pivotRow = updatedTilesIndices[i + 1];
				up = true;
				while (pivotRow >= 0)
				{
					if (_data[pivotCol][pivotRow].textureName == ResourcesName.WHITE)
					{
						up = false;
						verticalClearTilesIndices.splice(0, verticalClearTilesIndices.length);
						break;
					}
					verticalClearTilesIndices.push(pivotCol);
					verticalClearTilesIndices.push(pivotRow);
					pivotRow--;
				}
				
				// Down
				if (up)
				{
					pivotRow = updatedTilesIndices[i + 1];
					while (pivotRow < _size)
					{
						if (_data[pivotCol][pivotRow].textureName == ResourcesName.WHITE)
						{
							verticalClearTilesIndices.splice(0, verticalClearTilesIndices.length);
							break;
						}
						verticalClearTilesIndices.push(pivotCol);
						verticalClearTilesIndices.push(pivotRow);
						pivotRow++;
					}
				}
				
				// Left
				pivotCol = updatedTilesIndices[i];
				pivotRow = updatedTilesIndices[i + 1];
				left = true;
				while (pivotCol >= 0)
				{
					if (_data[pivotCol][pivotRow].textureName == ResourcesName.WHITE)
					{
						left = false;
						horizontalClearTilesIndices.splice(0, horizontalClearTilesIndices.length);
						break;
					}
					horizontalClearTilesIndices.push(pivotCol);
					horizontalClearTilesIndices.push(pivotRow);
					pivotCol--;
				}
				
				// Right
				if (left)
				{
					pivotCol = updatedTilesIndices[i];
					while (pivotCol < _size)
					{
						if (_data[pivotCol][pivotRow].textureName == ResourcesName.WHITE)
						{
							horizontalClearTilesIndices.splice(0, horizontalClearTilesIndices.length);
							break;
						}
						horizontalClearTilesIndices.push(pivotCol);
						horizontalClearTilesIndices.push(pivotRow);
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
				for (i = 0; i < totalClearTilesIndices.length; i += 2)
				{
					_data[totalClearTilesIndices[i]][totalClearTilesIndices[i + 1]].textureName = ResourcesName.WHITE;
				}
			
				if (onUpdate)
				{
					onUpdate(totalClearTilesIndices);
				}	
			}
			
			totalClearTilesIndices = null;
			verticalClearTilesIndices = null;
			horizontalClearTilesIndices = null;
		}
		
		public function export():String
		{
			var dataStr:String = ",\n\t\"tableSize\" : " + _size.toString() +
								 ",\n\t\"tableData\" : [";
				
			for (var i:int = 0; i < _data.length; i++)
			{
				for (var j:int = 0; j < _data[i].length; j++)
				{
					if (i != 0)
					{
						dataStr += ", ";
					}
					dataStr += _data[i][j].col.toString() + ", " +
							   _data[i][j].row.toString() + ", " +
							   _data[i][j].textureName;
				}
			}
			dataStr += "]";
			
			return dataStr;
		}
	}
}