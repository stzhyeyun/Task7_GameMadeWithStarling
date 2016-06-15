package item
{
	public class ItemData
	{
		private var _id:int;
		private var _num:int;
		private var _imgName:String;
		
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
		
		public function get imgName():String
		{
			return _imgName;
		}
		
		public function set imgName(value:String):void
		{
			_imgName = value;
		}
		
		
		public function ItemData(id:int = -1, num:int = 0, imgName:String = null)
		{
			_id = id;
			_num = num;
			_imgName = imgName;
		}
		
		public function dispose():void
		{
			_imgName = null;
		}
	}
}