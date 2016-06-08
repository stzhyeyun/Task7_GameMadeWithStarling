package gamedata
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	
	import user.UserInfo;

	public class Rank extends Data
	{
		private const TAG:String = "[Rank]";
		
		private var _data:Vector.<UserInfo>;

		
		public function Rank(name:String, path:File)
		{
			super(name, path);
			
			_data = new Vector.<UserInfo>();
		}

		public override function write():void
		{
			if (!_name || !_path || _data.length == 0)
			{
				if (!_name) trace(TAG + " write : No name.");
				if (!_path) trace(TAG + " write : No path.");
				if (!_data.length == 0) trace(TAG + " write : No rank data.");
				return;
			}
			
			var plainText:String = "{\n\t\"rank\" : [";

			for (var i:int = 0; i < _data.length; i++)
			{
				plainText += _data[i].toString();
				
				if (i != _data.length - 1)
				{
					plainText += ", ";
				}
			}
			
			plainText += "]\n}";
			
			trace(TAG + plainText); // debug
			
			plainText = AesCrypto.encrypt(plainText, "ahundrendblocksbybamkie");
			
			var stream:FileStream = new FileStream();
			var file:File = new File(_path.resolvePath(_name + ".json").url);
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(plainText);
			stream.close();
			
			plainText = null;
			stream = null;
			file = null;
		}
		
		protected override function onCompleteLoad(event:Event):void
		{
			super.onCompleteLoad(event);
			
			var loader:URLLoader = event.target as URLLoader;
			if (!loader)
			{
				return;
			}
			
			var plainText:Object = JSON.parse(AesCrypto.decrypt(loader.data, "ahundrendblocksbybamkie"));
			
			trace(TAG + plainText); // debug
			
			var id:String;
			var name:String;
			var score:int;
			for (var i:int = 0; i < plainText.rank.length; )
			{
				id = plainText.rank[i++].id;
				name = plainText.rank[i++].name;
				score = plainText.rank[i++].score;
				
				_data.push(new UserInfo(id, name, score));
			}
		}
		
		public function addData(userInfo:UserInfo):int
		{
			// 추가
			var index:int = -1;
			for (var i:int = 0; i < _data.length; i++)
			{
				if (_data[i].id == userInfo.id)
				{
					index = i;
					break;
				}
			}
			
			if (index != -1)
			{
				if (_data[index].score < userInfo.score)
				{
					_data[index] = userInfo;
				}
				else
				{
					// 갱신할 필요가 없음
					return 0;
				}
			}
			else
			{
				_data.push(userInfo);
				index = _data.length - 1;
			}
			
			// 내림차순 정렬
			for (i = index; i > 0; i--)
			{
				if (_data[i].score > _data[i - 1].score)
				{
					var temp:UserInfo = _data[i];
					_data[i] = _data[i - 1];
					_data[i - 1] = temp;
				}
				else
				{
					// 정렬 완료
					break;
				}
			}
			
			return index + 1;
		}
		
		public function getRank(userInfo:UserInfo):int
		{
			for (var i:int = 0; i < _data.length; i++)
			{
				if (_data[i].id == userInfo.id)
				{
					return i + 1;
				}
			}
			
			return 0;
		}
		
		public function getUser(rank:int):UserInfo
		{
			if (rank <= 0 || rank > _data.length)
			{
				trace(TAG + " getUser : Invalid rank.");
				return null;
			}
				
			return _data[rank - 1];
		}
		
		public function count():int
		{
			if (_data)
			{
				return _data.length;
			}
			else
			{
				return 0;
			}
		}
	}
}