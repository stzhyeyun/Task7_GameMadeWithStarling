package block
{
	public class Index2D
	{
		private const NONE:int = -1;
		
		private var _i:int;
		private var _j:int;
		
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

		
		public function Index2D(i:int = NONE, j:int = NONE)
		{
			_i = i;
			_j = j;
		}
	}
}