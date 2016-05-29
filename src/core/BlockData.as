package core
{
	public class BlockData
	{
		private const TAG:String = "[BlockData]";
		
		private var _data:Vector.<TileData>;
		
		public function get data():Vector.<TileData>
		{
			return _data;
		}
		
		
		public function BlockData()
		{
			_data = new Vector.<TileData>();
		}
		
		public function addData(data:TileData):void
		{
			if (!data)
			{
				trace(TAG + " addData : No data.");
				return;
			}
			
			_data.push(data);
		}
		
		public function export():String
		{
			var dataStr:String = "";
			
			for (var i:int = 0; i < _data.length; i++)
			{
				if (i == 0)
				{
					dataStr += _data.length.toString() + ", ";
				}
				
				if (i != 0)
				{
					dataStr += ", ";
				}
		
				dataStr += 
					_data[i].col.toString() + ", " +
					_data[i].row.toString() + ", " +
					_data[i].textureName;
			}
			
			return dataStr;
		}
	}
}