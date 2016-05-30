package core
{
	import resources.Resources;
	
	import starling.display.Sprite;
	
	import util.Color;

	public class Block extends Sprite
	{
		private const TAG:String = "[Block]";
		
		private var _data:BlockData;
		private var _tiles:Vector.<Tile>;
		private var _tileScale:Number;
		
		public function get data():BlockData
		{
			return _data;
		}
		
		public function get tiles():Vector.<Tile>
		{
			return _tiles;
		}
		
		
		public function Block(scale:Number = 1)
		{
			_data = null;
			_tiles = new Vector.<Tile>();
			_tileScale = scale;
		}
		
		public function initialize(blockData:BlockData):void
		{
			removeChildren();
			
			_data = blockData;
			
			if (!_data)
			{
				return;
			}
			
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
					tile.scale = _tileScale;
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
				tile.color = Color.TILE;
				
				addChild(tile);
			}
			
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
		}
		
		public function setSize(scale:Number):void
		{
			var data:Vector.<TileData> = _data.data;
			var tileData:TileData;
			var tile:Tile;
			var margin:Number = 20;
			for (var i:int = 0; i < data.length; i++)
			{
				tileData = data[i];
				
				_tiles[i].scale = scale;
				_tiles[i].x = _tiles[i].width * tileData.col; 
				_tiles[i].y = _tiles[i].height * tileData.row;
				
				// 간격 보정
				if (tileData.col != 0)
				{
					_tiles[i].x -= _tiles[i].width / margin * tileData.col;
				}
				
				if (tileData.row != 0)
				{
					_tiles[i].y -= _tiles[i].height / margin * tileData.row;
				}
			}
		}
	}
}
