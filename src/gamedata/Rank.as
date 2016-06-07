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
		
		private var _rank:Vector.<UserInfo>;
		
		public function get rank():Vector.<UserInfo>
		{
			return _rank;
		}
		
		
		public function Rank(name:String, path:File)
		{
			super(name, path);
			
			_rank = new Vector.<UserInfo>();
		}

		public override function write():void
		{
			if (!_name || !_path)
			{
				if (!_name) trace(TAG + " write : No name.");
				if (!_path) trace(TAG + " write : No path.");				
				return;
			}
			
			var plainText:String = "";
//				"{\n\t\"bestScore\" : "	+	_bestScore.toString()		+	",\n"	+
//				"\t\"currentScore\" : "	+	_currentScore.toString();
			
			plainText += "\n}";
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
			
			// to do
			
		}
		
		public function addData(userInfo:UserInfo):void
		{
			// 추가
			var index:int = -1;
			for (var i:int = 0; i < _rank.length; i++)
			{
				if (_rank[i].id == userInfo.id)
				{
					index = i;
					break;
				}
			}
			
			if (index != -1)
			{
				if (_rank[index].score < userInfo.score)
				{
					_rank[index] = userInfo;
				}
				else
				{
					// 갱신할 필요가 없음
					return;
				}
			}
			else
			{
				_rank.push(userInfo);
				index = _rank.length - 1;
			}
			
			// 내림차순 정렬
			for (i = index; i > 0; i--)
			{
				if (_rank[i].score > _rank[i - 1].score)
				{
					var temp:UserInfo = _rank[i];
					_rank[i] = _rank[i - 1];
					_rank[i - 1] = temp;
				}
				else
				{
					// 정렬 완료
					break;
				}
			}
		}
	}
}