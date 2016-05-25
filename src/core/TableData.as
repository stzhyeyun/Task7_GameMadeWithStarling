package core
{
	import resources.ResourcesName;

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
		
		public function isSettable(block:BlockData):Boolean
		{
			// to do
			
			return false;	
		}

		public function setBlock(pivotJ:int, pivotI:int, block:BlockData, onUpdate:Function):Boolean
		{
			var destTilesIndices:Vector.<int> = new Vector.<int>();
			
			var blockTiles:Vector.<TileData> = block.data;
			var prevBlockTileJ:int = blockTiles[0].j;
			var prevBlockTileI:int = blockTiles[0].i;
			var diffJ:int = 0;
			var diffI:int = 0;
			
			// Check
			for (var i:int = 0; i < blockTiles.length; i++)
			{
				diffJ = blockTiles[i].j - prevBlockTileJ;
				diffI = blockTiles[i].i - prevBlockTileI;
				
				pivotJ += diffJ;
				pivotI += diffI;
				
				if (_data[pivotJ][pivotI].textureName != ResourcesName.WHITE)
				{
					destTilesIndices = null;
					blockTiles = null;
					return false;
				}
				
				destTilesIndices.push(pivotJ);
				destTilesIndices.push(pivotI);

				prevBlockTileJ = blockTiles[i].j;
				prevBlockTileI = blockTiles[i].i;
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
			clear(onUpdate);
			
			return true;
		}
		
		public function clear(onUpdate:Function):void
		{
			
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
					dataStr += _data[i][j].i.toString() + ", " +
							   _data[i][j].j.toString() + ", " +
							   _data[i][j].textureName;
				}
			}
			dataStr += "]";
			
			return dataStr;
		}
	}
}


