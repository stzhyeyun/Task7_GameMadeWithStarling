package block
{
	import starling.display.Image;
	import starling.textures.Texture;

	public class Tile extends Image
	{
		private const NONE:int = -1;
		
		private var _index:int;
		private var _blockId:int;
		private var _isFilled:Boolean;
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function get blockId():int
		{
			return _blockId;
		}
		
		public function set blockId(value:int):void
		{
			_blockId = value;
		}
		
		public function get isFilled():Boolean
		{
			return _isFilled;
		}
		
		public function set isFilled(value:Boolean):void
		{
			_isFilled = value;
		}
		
		
		public function Tile(texture:Texture, index:int = NONE, blockId:int = NONE, isFilled:Boolean = false)
		{
			super(texture);
			
			_index = index;
			_blockId = blockId;
			_isFilled = isFilled;
		}
		
		public function isIn():Boolean
		{
			// to do
			
			return true;
		}
	}
}