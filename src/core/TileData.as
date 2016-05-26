package core
{
	import resources.ResourcesName;

	public class TileData
	{
		private var _col:int;
		private var _row:int;
		private var _textureName:String;

		public function get col():int
		{
			return _col;
		}
		
		public function set col(value:int):void
		{
			_col = value;
		}
		
		public function get row():int
		{
			return _row;
		}
		
		public function set row(value:int):void
		{
			_row = value;
		}
		
		public function get textureName():String
		{
			return _textureName;
		}
		
		public function set textureName(value:String):void
		{
			_textureName = value;
		}

		
		public function TileData(col:int = 0, row:int = 0, textureName:String = ResourcesName.WHITE)
		{
			_col = col;
			_row = row;
			_textureName = textureName;
		}
	}
}