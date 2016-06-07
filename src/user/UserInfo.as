package user
{
	public class UserInfo
	{
		private var _id:String;
		private var _name:String;
		private var _score:int;
		
		public function get id():String
		{
			return _id;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get score():int
		{
			return _score;
		}
		
		
		public function UserInfo(id:String, name:String, score:int = 0)
		{
			_id = id;
			_name = name;
		}

		public function setScore(score:int):void
		{
			if (score > _score)
			{
				_score = score;
			}
		}
	}
}