package user
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	
	import gamedata.AesCrypto;
	import gamedata.Data;
	
	import item.ItemID;

	public class UserInfo extends Data
	{
		private const TAG:String = "[UserInfo]";
		
		private var _userId:String;
		private var _userName:String;
		private var _score:int;
		private var _items:Vector.<int>;
		private var _attendance:int;
		private var _rewarded:Boolean;

		public function get userId():String
		{
			return _userId;
		}
		
		public function get userName():String
		{
			return _userName;
		}
		
		public function get score():int
		{
			return _score;
		}
		
		public function set score(value:int):void
		{
			if (value > _score)
			{
				_score = value;
			}
		}
		
		public function get items():Vector.<int>
		{
			return _items;
		}
		
		public function get attendance():int
		{
			return _attendance;
		}
		
		public function set attendance(value:int):void
		{
			_attendance = value;
		}
		
		public function get rewarded():Boolean
		{
			return _rewarded;
		}
		
		public function set rewarded(value:Boolean):void
		{
			_rewarded = value;
		}

		
		public function UserInfo(name:String = null, path:File = null)
		{
			super(name, path);
			
			_userId = null;
			_userName = null;
			_score = 0;
			_items = new Vector.<int>(ItemID.NUM_ITEM);
			_attendance = 0;
			_rewarded = false;
		}
		
		public override function write():void
		{
			if (!_fileName || !_path)
			{
				if (!_fileName) trace(TAG + " write : No name.");
				if (!_path) trace(TAG + " write : No path.");
				return;
			}
			
			var file:File = new File(_path.resolvePath(_fileName + ".json").url);
			
			if (!_userId) // 현재 유저 정보가 없을 경우 로컬에 저장된 유저 정보를 삭제함
			{
				trace(TAG + " write : No user info.");
				
				if (file.exists)
				{
					file.deleteFile();
				}
				return;
			}
			
			var plainText:String = 
				"{\n\t\"userId\" : \""	+	_userId		+	"\",\n"	+
				"\t\"userName\" : \""	+	_userName	+	"\",\n" +
				"\t\"score\" : "		+	_score		+	"\n}";
			
			plainText = AesCrypto.encrypt(plainText, "ahundrendblocksbybamkie");
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(plainText);
			stream.close();
			
			plainText = null;
			stream = null;
			file = null;
		}
		
		protected override function onCompleteLoad(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			if (!loader)
			{
				return;
			}
			
			loader.removeEventListener(Event.COMPLETE, onCompleteLoad);
			
			var plainText:Object = JSON.parse(AesCrypto.decrypt(loader.data, "ahundrendblocksbybamkie"));
			
			_userId = plainText.userId;
			_userName = plainText.userName;
			_score = plainText.score;
			
			super.onCompleteLoad(event);
		}
		
		public function setData(info:String):void
		{
			if (info)
			{
				parseData(info);
			}
		}
		
		public function setInfo(userId:String, userName:String, score:int):void
		{
			_userId = userId;
			_userName = userName;
			_score = score;
		}
		
		public function setItem(id:int, num:int):void
		{
			if (id >= 0 && id < _items.length)
			{
				_items[id] = num;
			}
		}
		
		public function addItem(id:int, num:int):void
		{
			if (id >= 0 && id < _items.length)
			{
				_items[id] = _items[id] + num;
			}
		}
		
		public function clean():void
		{
			_userId = null;
			_userName = null;
			_score = 0;
			
			for (var i:int = 0; i < _items.length; i++)
			{
				_items[i] = 0;
			}

			_attendance = 0;
			_rewarded = false;
		}
		
		private function parseData(info:String):void
		{
			var infoObj:Object = JSON.parse(info);
			
			_userId = infoObj.id;
			_userName = infoObj.name;
		}
	}
}