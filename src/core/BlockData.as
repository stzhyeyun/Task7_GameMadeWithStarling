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
		
		public function dispose():void
		{
			if (_data)
			{
				for (var i:int = 0; i < _data.length; i++)
				{
					if (_data[i])
					{
						_data[i].dispose();
					}
					_data[i] = null;
				}
			}
			_data = null;
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
		
		public function export(index:int):String
		{
			var dataStr:String = "";
			
			if (index != 0)
			{
				dataStr += ", ";
			}
			
			for (var i:int = 0; i < _data.length; i++)
			{
				if (i == 0)
				{
					dataStr += index.toString() + ", " + _data.length.toString() + ", ";
				}
		
				dataStr += "{\"col\" : " + _data[i].col.toString() + "}, " +
						   "{\"row\" : " + _data[i].row.toString() + "}, " +
						   "{\"textureName\" : \"" + _data[i].textureName + "\"}";
				
				if (i != _data.length - 1)
				{
					dataStr += ", ";
				}
			}
			
			return dataStr;
		}
	}
}