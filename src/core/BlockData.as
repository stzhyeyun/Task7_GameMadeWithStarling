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
	}
}