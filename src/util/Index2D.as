package util
{
	public class Index2D
	{
		private var _col:int;
		private var _row:int;
		
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
		
		
		public function Index2D(col:int = 0, row:int = 0)
		{
			_col = col;
			_row = row;
		}

		public function equality(target:Index2D):Boolean
		{
			return (_col == target.col && _row == target.row)? true : false;
		}
	}
}