package core
{
	import resources.Resources;
	
	import starling.display.Sprite;

	public class Table extends Sprite
	{
		private const TAG:String = "[Table]";
		
		private var _data:TableData;
		private var _tiles:Vector.<Vector.<Tile>>;

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
			_tiles = new Vector.<Vector.<Tile>>;
		}
		
		public override function dispose():void
		{
			_data = null;
			_tiles = null;
			
			super.dispose();
		}

		public function initialize(tableData:TableData):void
		{
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
					tileData = data[j][i];
					
					tile = new Tile(tileData);
					tile.x = tile.width * j;
					tile.y = tile.height * i;
					
					// 간격 보정
					if (j != 0)
					{
						tile.x -= tile.width / margin * j;
					}
					
					if (i != 0)
					{
						tile.y -= tile.height / margin * i;
					}
					
					// 색상 보정
					tile.color = 0xf2f2f2;
					
					_tiles[i].push(tile);
					addChild(tile);
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
			var pivotJ:int = 0;
			var pivotI:int = 0;
			for (var i:int = 0; i < _tiles.length; i++)
			{
				for (var j:int = 0; j < _tiles[i].length; j++)
				{
					dist = _tiles[j][i].getDistance(primaryTarget);
					
					if (i == 0 && j == 0)
					{
						closestDist = dist;
					}
					
					if (dist < closestDist)
					{
						closestDist = dist;
						pivotJ = j;
						pivotI = i;
					}
				}
			}
			
			return _data.setBlock(pivotJ, pivotI, block.data, onUpdate);
		}
		
		private function onUpdate(updatedDataIndices:Vector.<int>):void // Change tile's texture
		{
			var tileData:Vector.<Vector.<TileData>> = _data.data;
			var updatedJ:int;
			var updatedI:int;
			for (var i:int = 0; i < updatedDataIndices.length; i += 2)
			{
				updatedJ = updatedDataIndices[i];
				updatedI = updatedDataIndices[i + 1];
				
				_tiles[updatedJ][updatedI].texture =
					Resources.getTexture(tileData[updatedJ][updatedI].textureName);
			}
		}

//		
//		public function setBlock(target:Block):Boolean
//		{
//			if (!_tiles || !target)
//			{
//				if (!_tiles) trace(TAG + " setBlock : No tiles.");
//				if (!target) trace(TAG + " setBlock : No target block.");
//				return false;
//			}
//			
//			var blockTiles:Vector.<Tile> = target.tiles;
//			if (!blockTiles)
//			{
//				trace(TAG + " setBlock : No target tiles.");
//				return false;
//			}
//			
//			_closestTilesIndices = new Vector.<TileData>();
//			var closestDist:Number = 0;
//			var dist:Number = 0;
//			for (var i:int = 0; i < blockTiles.length; i++)
//			{
//				for (var j:int = 0; j < _tiles.length; j++)
//				{
//					for (var k:int = 0; k < _tiles[j].length; k++)
//					{
//						if (j == 0 && k == 0)
//						{
//							closestDist = blockTiles[i].getDistance(_tiles[j][k]);
//							_closestTilesIndices.insertAt(i, new TileData(j, k));
//						}
//						else
//						{
//							dist = blockTiles[i].getDistance(_tiles[j][k]);		
//						}
//						
//						if (dist < closestDist)
//						{
//							closestDist = dist;
//							if (_closestTilesIndices[i])
//							{
//								_closestTilesIndices[i].i = j;
//								_closestTilesIndices[i].j = k;
//							}
//							else
//							{
//								_closestTilesIndices.insertAt(i, new TileData(j, k));
//							}
//						}
//					}
//				}
//				
//				if (_tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].isFilled)
//				{
//					return false;
//				}
//				
//				closestDist = 0;
//				dist = 0;
//			}
//			
//			// Set block (Fill tiles)
//			target.visible = false;
//			
//			var selectedTile:Tile;
//			for (i = 0; i < blockTiles.length; i++)
//			{
//				selectedTile = _tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j];
//				selectedTile.isFilled = true;
//				selectedTile.blockType = target.type;
//				selectedTile.texture = blockTiles[i].texture;
//			}
//			selectedTile = null;
//						
//			clear();
//			
//			return true;
//		}
//
//		private function clear():void
//		{
//			var canClearVertical:Boolean;
//			var canClearHotizontal:Boolean;
//			for (var i:int = 0; i < _closestTilesIndices.length; i++)
//			{
//				// Check
//				canClearVertical = _tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].checkLineFilled(Tile.UP);
//				if (canClearVertical)
//				{
//					canClearVertical = _tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].checkLineFilled(Tile.DOWN);
//				}
//				
//				canClearHotizontal = _tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].checkLineFilled(Tile.LEFT);
//				if (canClearHotizontal)
//				{
//					canClearHotizontal = _tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].checkLineFilled(Tile.RIGHT);
//				}
//				
//				// Clear
//				if (canClearVertical)
//				{
//					_tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].clear(Tile.VERTICAL);
//				}
//				
//				if (canClearHotizontal)
//				{
//					_tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].clear(Tile.HORIZONTAL);
//				}
//			}
//			_closestTilesIndices = null;
//		}
		
		
//		public function event(x, y)
//		{
//			if(_data.isPossible(x, y, block) == ture)
//			{
//				_data.setdata();
//				_table.
//			}
//			else
//			{
//				//rewind;
//			}
//		}
		
	}
}