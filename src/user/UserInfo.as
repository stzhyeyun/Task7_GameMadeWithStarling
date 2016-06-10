package user
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import gamedata.AesCrypto;

	public class UserInfo
	{
		private const TAG:String = "[UserInfo]";
		
		private var _id:String;
		private var _name:String;
		private var _score:int;

		private var _onReadyToPreset:Function;

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
		
		public function set score(value:int):void
		{
			_score = value;
		}
		
		public function set onReadyToPreset(value:Function):void
		{
			_onReadyToPreset = value;
		}

		
		public function UserInfo(id:String = null, name:String = null, score:int = 0)
		{
			_id = id;
			_name = name;
			_score = score;
		}
		
		public function setInfo(info:String):void
		{
			if (info)
			{
				parseInfo(info);
			}
		}

		public function setScore(score:int):void
		{
			if (score > _score)
			{
				_score = score;
			}
		}
		
		public function read(name:String, path:File):void
		{
			if (!name || !path)
			{
				if (!name) trace(TAG + " read : No name.");
				if (!path) trace(TAG + " read : No path.");				
				return;
			}
			
			var file:File = path.resolvePath(name + ".json");
			if (file.exists)
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onCompleteLoad);
				urlLoader.load(new URLRequest(file.url));
			}
		}
		
		public function write(name:String, path:File):void
		{
			if (!name || !path)
			{
				if (!name) trace(TAG + " write : No name.");
				if (!path) trace(TAG + " write : No path.");
				return;
			}
			
			var file:File = new File(path.resolvePath(name + ".json").url);
			
			if (!_id) // 현재 유저 정보가 없을 경우 로컬에 저장된 유저 정보를 삭제함
			{
				trace(TAG + " write : No user info.");
				
				if (file.exists)
				{
					file.deleteFile();
				}
				return;
			}
			
			var plainText:String = 
				"{\n\t\"id\" : \""	+	_id		+	"\",\n"	+
				"\t\"name\" : \""	+	_name	+	"\"\n}";
			
			plainText = AesCrypto.encrypt(plainText, "ahundrendblocksbybamkie");
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(plainText);
			stream.close();
			
			plainText = null;
			stream = null;
			file = null;
		}
		
		public function clean():void
		{
			_id = null;
			_name = null;
			_score = 0;
		}
		
		public function toString():String
		{
			var userInfoStr:String =
				"{\"id\" : \"" + _id + "\"}, " +
				"{\"name\" : \"" + _name + "\"}, " +
				"{\"score\" : " + _score.toString() + "}";
			
			return userInfoStr;
		}
		
		private function parseInfo(info:String):void
		{
			var infoObj:Object = JSON.parse(info);
			
			_id = infoObj.id;
			_name = infoObj.name;
		}
		
		private function onCompleteLoad(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			if (!loader)
			{
				return;
			}

			loader.removeEventListener(Event.COMPLETE, onCompleteLoad);
			
			var plainText:Object = JSON.parse(AesCrypto.decrypt(loader.data, "ahundrendblocksbybamkie"));
			
			_id = plainText.id;
			_name = plainText.name;
			
			if (_onReadyToPreset)
			{
				_onReadyToPreset();
			}
		}
	}
}