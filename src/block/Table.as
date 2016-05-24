package block
{
	import starling.display.Sprite;

	public class Table extends Sprite
	{
		public static const HORIZONTAL:int = 0;
		public static const VERTICAL:int = 1;
	
		private const TAG:String = "[Table]";
		
		private var _tiles:Vector.<Tile>;
		
		public function get tiles():Vector.<Tile>
		{
			return _tiles;
		}

		
		public function Table()
		{
			_tiles = null;
		}

		public function initialize():void
		{
			var tile:Tile;
			for (var i:int = 0; i < 10; i++)
			{
				for (var j:int = 0; j < 10; j++)
				{
					//tile = new Tile(texture);
					
				}
			}
		}
		
		public function addTile(tile:Tile):void
		{
			if (!tile)
			{
				trace(TAG + " addTile : No tile.");
				return;
			}
			
			if (!_tiles)
			{
				_tiles = new Vector.<Tile>();
			}
			_tiles.push(tile);
		}

		public function isSettable(block:Block):Boolean
		{
			// to do
			
			return true;	
		}
		
		public function setBlock(block:Block):Boolean
		{
			// to do
			
			
			// true
			//clear();
			
			return true;
		}

		private function clear(startIndex:int):void
		{
			// determine if line can be clear
			// clear tiles
			// Table.HORIZONTAL
			
		}
	}
}