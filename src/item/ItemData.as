package item
{
	public class ItemData
	{
		private var _id:int;
		private var _num:int;
		private var _normalImgName:String;
		private var _noneImgName:String;
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get num():int
		{
			return _num;
		}
		
		public function set num(value:int):void
		{
			_num = value;
		}
		
		public function get normalImgName():String
		{
			return _normalImgName;
		}
		
		public function set normalImgName(value:String):void
		{
			_normalImgName = value;
		}
		
		public function get noneImgName():String
		{
			return _noneImgName;
		}
		
		public function set noneImgName(value:String):void
		{
			_noneImgName = value;
		}
		
		
		public function ItemData(id:int = -1, num:int = 0, normalImgName:String = null, noneImgName:String = null)
		{
			_id = id;
			_num = num;
			_normalImgName = normalImgName;
			_noneImgName = noneImgName;
		}
		
		public function dispose():void
		{
			_noneImgName = null;
			_normalImgName = null;
		}
	}
}