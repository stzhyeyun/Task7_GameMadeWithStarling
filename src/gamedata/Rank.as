package gamedata
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.events.EventDispatcher;
	
	import user.UserInfo;
	
	public class Rank extends EventDispatcher
	{
		public static const ADD:String = "added";  
		public static const GET_RANK:String = "getRank";
		public static const GET_USER:String = "getUser";
		public static const COUNT:String = "count";
		
		private const TAG:String = "[Rank]";
		private const DB_URL:String =
			"http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com/hundredblocks/";
		
		
		public function Rank()
		{
			
		}
		
		public function addData(userInfo:UserInfo):void
		{
			var url:String =
				DB_URL +
				"addRankData.php" +
				"?id=" + userInfo.id +
				"&name=" + userInfo.name +
				"&score=" + userInfo.score;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onAddedData);
		}
		
		public function getRank(userInfo:UserInfo):void
		{
			var url:String =
				DB_URL +
				"getRank.php" +
				"?id=" + userInfo.id;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onGotRank);
		}
		
		public function getUser(rank:int, numResult:int = 1):void
		{
			var url:String =
				DB_URL +
				"getRankedUser.php" +
				"?rank=" + rank +
				"&numResult=" + numResult;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onGotUser);
		}

		public function count():void
		{
			var url:String =
				DB_URL +
				"getNumRank.php?";
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onGotNumRank);
		}
		
		private function onAddedData(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onAddedData);
			
			this.dispatchEvent(new starling.events.Event(ADD, false, urlLoader.data)); 
		}
		
		private function onGotRank(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onGotRank);
			
			this.dispatchEvent(new starling.events.Event(GET_RANK, false, urlLoader.data)); 
		}
		
		private function onGotUser(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onGotUser);
			
			var userInfoVec:Vector.<UserInfo> = null;
			if (urlLoader.data != 0)
			{
				var data:Object = JSON.parse(urlLoader.data);
				
				userInfoVec = new Vector.<UserInfo>();
				for (var i:int = 0; i < data.length; i++)
				{
					userInfoVec.push(new UserInfo(data[i].id, data[i].name, data[i].score));
				}
			}
			
			this.dispatchEvent(new starling.events.Event(GET_USER, false, userInfoVec)); 
		}
		
		private function onGotNumRank(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onGotNumRank);
			
			this.dispatchEvent(new starling.events.Event(COUNT, false, urlLoader.data)); 
		}
	}
}

//package gamedata
//{
//	import flash.events.Event;
//	import flash.filesystem.File;
//	import flash.filesystem.FileMode;
//	import flash.filesystem.FileStream;
//	import flash.net.URLLoader;
//	
//	import user.UserInfo;
//
//	public class Rank extends Data
//	{
//		private const TAG:String = "[Rank]";
//		
//		private var _data:Vector.<UserInfo>;
//
//		
//		public function Rank(name:String, path:File)
//		{
//			super(name, path);
//			
//			_data = new Vector.<UserInfo>();
//		}
//
//		public override function write():void
//		{
//			if (!_name || !_path || _data.length == 0)
//			{
//				if (!_name) trace(TAG + " write : No name.");
//				if (!_path) trace(TAG + " write : No path.");
//				if (!_data.length == 0) trace(TAG + " write : No rank data.");
//				return;
//			}
//			
//			var plainText:String = "{\n\t\"rank\" : [";
//
//			for (var i:int = 0; i < _data.length; i++)
//			{
//				plainText += _data[i].toString();
//				
//				if (i != _data.length - 1)
//				{
//					plainText += ", ";
//				}
//			}
//			
//			plainText += "]\n}";
//			
//			trace(TAG + plainText); // debug
//			
//			plainText = AesCrypto.encrypt(plainText, "ahundrendblocksbybamkie");
//			
//			var stream:FileStream = new FileStream();
//			var file:File = new File(_path.resolvePath(_name + ".json").url);
//			stream.open(file, FileMode.WRITE);
//			stream.writeUTFBytes(plainText);
//			stream.close();
//			
//			plainText = null;
//			stream = null;
//			file = null;
//		}
//		
//		protected override function onCompleteLoad(event:Event):void
//		{
//			super.onCompleteLoad(event);
//			
//			var loader:URLLoader = event.target as URLLoader;
//			if (!loader)
//			{
//				return;
//			}
//			
//			var plainText:Object = JSON.parse(AesCrypto.decrypt(loader.data, "ahundrendblocksbybamkie"));
//			
//			trace(TAG + plainText); // debug
//			
//			var id:String;
//			var name:String;
//			var score:int;
//			for (var i:int = 0; i < plainText.rank.length; )
//			{
//				id = plainText.rank[i++].id;
//				name = plainText.rank[i++].name;
//				score = plainText.rank[i++].score;
//				
//				_data.push(new UserInfo(id, name, score));
//			}
//		}
//		
//		public function addData(userInfo:UserInfo):int
//		{
//			// 추가
//			var index:int = -1;
//			for (var i:int = 0; i < _data.length; i++)
//			{
//				if (_data[i].id == userInfo.id)
//				{
//					index = i;
//					break;
//				}
//			}
//			
//			if (index != -1)
//			{
//				if (_data[index].score < userInfo.score)
//				{
//					_data[index] = userInfo;
//				}
//				else
//				{
//					// 갱신할 필요가 없음
//					return 0;
//				}
//			}
//			else
//			{
//				_data.push(userInfo);
//				index = _data.length - 1;
//			}
//			
//			// 내림차순 정렬
//			for (i = index; i > 0; i--)
//			{
//				if (_data[i].score > _data[i - 1].score)
//				{
//					var temp:UserInfo = _data[i];
//					_data[i] = _data[i - 1];
//					_data[i - 1] = temp;
//				}
//				else
//				{
//					// 정렬 완료
//					break;
//				}
//			}
//			
//			return index + 1;
//		}
//		
//		public function getRank(userInfo:UserInfo):int
//		{
//			for (var i:int = 0; i < _data.length; i++)
//			{
//				if (_data[i].id == userInfo.id)
//				{
//					return i + 1;
//				}
//			}
//			
//			return 0;
//		}
//		
//		public function getUser(rank:int):UserInfo
//		{
//			if (rank <= 0 || rank > _data.length)
//			{
//				trace(TAG + " getUser : Invalid rank.");
//				return null;
//			}
//				
//			return _data[rank - 1];
//		}
//		
//		public function count():int
//		{
//			if (_data)
//			{
//				return _data.length;
//			}
//			else
//			{
//				return 0;
//			}
//		}
//	}
//}