package block
{
	import starling.display.Sprite;

	public class Block extends Sprite
	{
		private var _id:int;
		private var _tiles:Vector.<Tile>;
		
		public function get tiles():Vector.<Tile>
		{
			return _tiles;
		}
		
		public function Block(id:int)
		{
			_id = id;
		}
		
		public function initialize():void
		{
			
		}


	}
}