package block
{
	import resources.Resources;
	import resources.ResourcesName;
	
	import starling.display.Sprite;

	public class Table extends Sprite
	{
		private const TAG:String = "[Table]";
		private const SIZE:int = 10;
		
		private var _tiles:Vector.<Vector.<Tile>>;
		private var _closestTilesIndices:Vector.<Index2D>;

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
			_tiles = null;
			_closestTilesIndices = null;
		}
		
		public override function dispose():void
		{
			if (_tiles)
			{
				for (var i:int = 0; i < _tiles.length; i++)
				{
					for (var j:int = 0; j < _tiles[i].length; j++)
					{
						_tiles[i][j].dispose();
						_tiles[i][j] = null;
					}
					_tiles[i].splice(0, _tiles[i].length);
				}
				_tiles.splice(0, _tiles.length);
			}
			_tiles = null;	
			
			if (_closestTilesIndices)
			{
				for (i = 0; i < _closestTilesIndices.length; i++)
				{
					_closestTilesIndices[i] = null;
				}
				_closestTilesIndices.splice(0, _closestTilesIndices.length);
			}
			_closestTilesIndices = null;	
			
			super.dispose();
		}

		public function initialize():void
		{
			if (!_tiles)
			{
				_tiles = new Vector.<Vector.<Tile>>;
				
				// Create tiles
				var tile:Tile;
				for (var i:int = 0; i < SIZE; i++)
				{
					for (var j:int = 0; j < SIZE; j++)
					{
						tile = new Tile(Resources.getTexture(ResourcesName.ATLAS, ResourcesName.TILE_EMPTY));
						tile.x = tile.width * i + tile.width * j;
						tile.y = tile.height * i;
						tile.isFilled = false;
						
						_tiles[i].push(tile);
						addChild(tile);
					}
				}
			}
			else
			{
				for (i = 0; i < SIZE; i++)
				{
					for (j = 0; j < SIZE; j++)
					{
						tile = _tiles[i][j];
						tile.x = tile.width * i + tile.width * j;
						tile.y = tile.height * i;
						
						addChild(tile);
					}
				}
			}
			
			// Set relative tiles
			for (i = 0; i < SIZE; i++)
			{
				for (j = 0; j < SIZE; j++)
				{
					if (i - 1 >= 0)
					{
						_tiles[i][j].top = _tiles[i - 1][j];
					}
					
					if (i + 1 < SIZE)
					{
						_tiles[i][j].bottom = _tiles[i + 1][j];
					}
					
					if (j - 1 >= 0)
					{
						_tiles[i][j].left = _tiles[i][j - 1];
					}
					
					if (j + 1 < SIZE)
					{
						_tiles[i][j].right = _tiles[i][j + 1];
					}
				}
			}
		}

		public function isSettable(blockType:String):Boolean
		{
			var isSettable:Boolean;
			
			switch (blockType)
			{
				case BlockType.I_TWO_VERTICAL:
				{
					for (var i:int = 0; i < _tiles.length; i++)
					{
						for (var j:int = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.DOWN, 2);
							if (isSettable) return true;
						}
					}
				}
					break;
				
				case BlockType.I_THREE_VERTICAL:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.DOWN, 3);
							if (isSettable) return true;
						}
					}
				}
					break;
				
				case BlockType.I_FOUR_VERTICAL:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.DOWN, 4); 
							if (isSettable) return true;
						}
					}
				}
					break;
				
				case BlockType.I_FIVE_VERTICAL:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.DOWN, 5); 
							if (isSettable) return true;
						}
					}
				}
					break;
				
				case BlockType.I_TWO_HORIZONTAL:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 2); 
							if (isSettable) return true;
						}
					}
				}
					break;
				
				case BlockType.I_THREE_HORIZONTAL:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 3); 
							if (isSettable) return true;
						}
					}
				}
					break;
				
				case BlockType.I_FOUR_HORIZONTAL:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 4); 
							if (isSettable) return true;
						}
					}
				}
					break;
				
				case BlockType.I_FIVE_HORIZONTAL:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 5); 
							if (isSettable) return true;
						}
					}
				}
					break;
				
				case BlockType.L_TWO_LEFTTOP:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 2); 
							
							if (isSettable)
							{
								isSettable = _tiles[i][j].checkLineEmpty(Tile.DOWN, 2);
								if (isSettable) return true;
							}
						}
					}
				}
					break;
				
				case BlockType.L_TWO_LEFTBOTTOM:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.UP, 2); 
							
							if (isSettable)
							{
								isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 2);
								if (isSettable) return true;
							}
						}
					}
				}
					break;
				
				case BlockType.L_TWO_RIGHTTOP:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.DOWN, 2); 
							
							if (isSettable)
							{
								isSettable = _tiles[i][j].checkLineEmpty(Tile.LEFT, 2);
								if (isSettable) return true;
							}
						}
					}
				}
					break;
				
				case BlockType.L_TWO_RIGHTBOTTOM:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.UP, 2); 
							
							if (isSettable)
							{
								isSettable = _tiles[i][j].checkLineEmpty(Tile.LEFT, 2);
								if (isSettable) return true;
							}
						}
					}
				}
					break;
				
				case BlockType.L_THREE_LEFTTOP:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 3); 
							
							if (isSettable)
							{
								isSettable = _tiles[i][j].checkLineEmpty(Tile.DOWN, 3);
								if (isSettable) return true;
							}
						}
					}
				}
					break;
				
				case BlockType.L_THREE_LEFTBOTTOM:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.UP, 3); 
							
							if (isSettable)
							{
								isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 3);
								if (isSettable) return true;
							}
						}
					}
				}
					break;
				
				case BlockType.L_THREE_RIGHTTOP:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.DOWN, 3); 
							
							if (isSettable)
							{
								isSettable = _tiles[i][j].checkLineEmpty(Tile.LEFT, 3);
								if (isSettable) return true;
							}
						}
					}
				}
					break;
				
				case BlockType.L_THREE_RIGHTBOTTOM:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.UP, 3); 
							
							if (isSettable)
							{
								isSettable = _tiles[i][j].checkLineEmpty(Tile.LEFT, 3);
								if (isSettable) return true;
							}
						}
					}
				}
					break;
				
				case BlockType.O_ONE:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 1); 
							if (isSettable) return true;
						}
					}
				}
					break;
				
				case BlockType.O_TWO:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 2); 
							
							if (isSettable && i + 1 < SIZE)
							{
								isSettable = _tiles[i + 1][j].checkLineEmpty(Tile.RIGHT, 2);
								if (isSettable) return true;
							}
						}
					}
				}
					break;
				
				case BlockType.O_THREE:
				{
					for (i = 0; i < _tiles.length; i++)
					{
						for (j = 0; j < _tiles[i].length; j++)
						{
							isSettable = _tiles[i][j].checkLineEmpty(Tile.RIGHT, 3); 
							
							if (isSettable && i + 1 < SIZE)
							{
								isSettable = _tiles[i + 1][j].checkLineEmpty(Tile.RIGHT, 3);
								
								if (isSettable && i + 2 < SIZE)
								{
									isSettable = _tiles[i + 2][j].checkLineEmpty(Tile.RIGHT, 3);
									if (isSettable) return true;
								}
							}
						}
					}
				}
					break;
				
				default:
				{
					trace(TAG + " isSettable : Invalid block type.");
					return false;
				}
					break;
			} // switch (_type)
			
			return false;	
		}
		
		public function setBlock(target:Block):Boolean
		{
			if (!_tiles || !target)
			{
				if (!_tiles) trace(TAG + " setBlock : No tiles.");
				if (!target) trace(TAG + " setBlock : No target block.");
				return false;
			}
			
			var blockTiles:Vector.<Tile> = target.tiles;
			if (!blockTiles)
			{
				trace(TAG + " setBlock : No target tiles.");
				return false;
			}
			
			_closestTilesIndices = new Vector.<Index2D>();
			var closestDist:Number = 0;
			var dist:Number = 0;
			for (var i:int = 0; i < blockTiles.length; i++)
			{
				for (var j:int = 0; j < _tiles.length; j++)
				{
					for (var k:int = 0; k < _tiles[j].length; k++)
					{
						if (j == 0 && k == 0)
						{
							closestDist = blockTiles[i].getDistance(_tiles[j][k]);
							_closestTilesIndices.insertAt(i, new Index2D(j, k));
						}
						else
						{
							dist = blockTiles[i].getDistance(_tiles[j][k]);		
						}
						
						if (dist < closestDist)
						{
							closestDist = dist;
							if (_closestTilesIndices[i])
							{
								_closestTilesIndices[i].i = j;
								_closestTilesIndices[i].j = k;
							}
							else
							{
								_closestTilesIndices.insertAt(i, new Index2D(j, k));
							}
						}
					}
				}
				
				if (_tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].isFilled)
				{
					return false;
				}
				
				closestDist = 0;
				dist = 0;
			}
			
			// Set block (Fill tiles)
			target.visible = false;
			
			var selectedTile:Tile;
			for (i = 0; i < blockTiles.length; i++)
			{
				selectedTile = _tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j];
				selectedTile.isFilled = true;
				selectedTile.blockType = target.type;
				selectedTile.texture = blockTiles[i].texture;
			}
			selectedTile = null;
						
			clear();
			
			return true;
		}

		private function clear():void
		{
			var canClearVertical:Boolean;
			var canClearHotizontal:Boolean;
			for (var i:int = 0; i < _closestTilesIndices.length; i++)
			{
				// Check
				canClearVertical = _tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].checkLineFilled(Tile.UP);
				if (canClearVertical)
				{
					canClearVertical = _tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].checkLineFilled(Tile.DOWN);
				}
				
				canClearHotizontal = _tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].checkLineFilled(Tile.LEFT);
				if (canClearHotizontal)
				{
					canClearHotizontal = _tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].checkLineFilled(Tile.RIGHT);
				}
				
				// Clear
				if (canClearVertical)
				{
					_tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].clear(Tile.VERTICAL);
				}
				
				if (canClearHotizontal)
				{
					_tiles[_closestTilesIndices[i].i][_closestTilesIndices[i].j].clear(Tile.HORIZONTAL);
				}
			}
			_closestTilesIndices = null;
		}
	}
}