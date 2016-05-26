package core
{
	import resources.Resources;
	
	import starling.display.Sprite;

	public class Block extends Sprite
	{
		private const TAG:String = "[Block]";
		
		private var _data:BlockData;
		private var _tiles:Vector.<Tile>;

		public function get data():BlockData
		{
			return _data;
		}
		
		public function get tiles():Vector.<Tile>
		{
			return _tiles;
		}
		
		
		public function Block()
		{
			_data = null;
			_tiles = new Vector.<Tile>();
		}
		
		public function initialize(blockData:BlockData):void
		{
			removeChildren();
			
			_data = blockData;
			
			// Create tiles
			var data:Vector.<TileData> = _data.data;
			var tileData:TileData;
			var tile:Tile;
			var margin:Number = 20;
			for (var i:int = 0; i < data.length; i++)
			{
				tileData = data[i];
				
				if (i >= _tiles.length)
				{
					tile = new Tile(tileData);
					_tiles.push(tile);
				}
				else
				{
					tile = _tiles[i]
					tile.data = tileData;
					tile.texture = Resources.getTexture(tile.data.textureName);
					tile.visible = true;
				}
				tile.x = tile.width * tileData.col; 
				tile.y = tile.height * tileData.row;
				
				// 간격 보정
				if (tileData.col != 0)
				{
					tile.x -= tile.width / margin * tileData.col;
				}
				
				if (tileData.row != 0)
				{
					tile.y -= tile.height / margin * tileData.row;
				}
				
				// 색상 보정
				tile.color = 0xf2f2f2;
				
				addChild(tile);
			}
		}
	}
}
