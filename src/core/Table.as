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
			
			return _data.setBlock(pivotCol, pivotRow, block.data, onUpdate);
		}
		
		private function onUpdate(updatedDataIndices:Vector.<int>):void
		{
			// 업데이트 된 타일 텍스처 변경
			var tileData:Vector.<Vector.<TileData>> = _data.data;
			var updatedCol:int;
			var updatedRow:int;
			for (var i:int = 0; i < updatedDataIndices.length; i += 2)
			{
				updatedCol = updatedDataIndices[i];
				updatedRow = updatedDataIndices[i + 1];
				
				_tiles[updatedCol][updatedRow].texture =
					Resources.getTexture(tileData[updatedCol][updatedRow].textureName);
			}
		}
	}
}