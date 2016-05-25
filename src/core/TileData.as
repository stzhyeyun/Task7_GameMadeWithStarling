package core
{
	import resources.ResourcesName;

	public class TileData
	{
		private var _i:int;
		private var _j:int;
		private var _textureName:String;

		public function get i():int
		{
			return _i;
		}
		
		public function set i(value:int):void
		{
			_i = value;
		}
		
		public function get j():int
		{
			return _j;
		}
		
		public function set j(value:int):void
		{
			_j = value;
		}
		
		public function get textureName():String
		{
			return _textureName;
		}
		
		public function set textureName(value:String):void
		{
			_textureName = value;
		}

		
		public function TileData(i:int = 0, j:int = 0, textureName:String = ResourcesName.WHITE)
		{
			_i = i;
			_j = j;
			_textureName = textureName;
		}
	}
}