package user
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	
	import gamedata.AesCrypto;
	import gamedata.Data;
	
	
	public class AccessToken extends Data
	{
		private const TAG:String = "[AccessToken]";
		
		private var _userId:String;
		private var _token:String;
		private var _expires:String; // no use
		private var _permissions:Vector.<String>; // no use
		
		public function get userId():String
		{
			return _userId;
		}
		
		public function set userId(value:String):void
		{
			_userId = value;
		}
		
		public function get token():String
		{
			return _token;
		}
		
		public function set token(value:String):void
		{
			_token = value;
		}
				
		
		public function AccessToken(name:String, path:File, tokenData:String = null)
		{
			super(name, path);
			
			_userId = null;
			_token = null;
			_expires = null;
			_permissions = new Vector.<String>();
			
			if (tokenData)
			{
				parseData(tokenData);
			}
		}
		
		public override function write():void
		{
			if (!_name || !_path)
			{
				if (!_name) trace(TAG + " write : No name.");
				if (!_path) trace(TAG + " write : No path.");
				return;
			}
			
			var file:File = new File(path.resolvePath(name + ".json").url);
			
			if (!_userId || !_token) // 토큰이 없을 경우 로컬에 저장된 토큰을 삭제함 (로그인한 유저가 없음)
			{
				trace(TAG + " write : No access token.");
				
				if (file.exists)
				{
					file.deleteFile();
				}
				return;
			}
			
			var plainText:String = 
				"{\n\t\"userId\" : \""	+	_userId	+	"\",\n"	+
				"\t\"token\" : \""		+	_token	+	"\"\n}";

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
			
			var plainText:Object = JSON.parse(AesCrypto.decrypt(loader.data, "ahundrendblocksbybamkie"));
			
			_userId = plainText.userId;
			_token = plainText.token;
			
			super.onCompleteLoad(event);
		}
		
		public function setData(tokenData:String):void
		{
			if (tokenData)
			{
				parseData(tokenData);
			}
		}
		
		public function clean():void
		{
			_userId = null;
			_token = null;
			_expires = null;
			_permissions.splice(0, _permissions.length);
		}
		
		private function parseData(tokenData:String):void
		{
			var tokenObj:Object = JSON.parse(tokenData);
			
			_userId = tokenObj.userId;
			_token = tokenObj.token;
			_expires = tokenObj.expires;
			
			_permissions.splice(0, _permissions.length);
			for (var i:int = 0; i < tokenObj.permissions.length; i++)
			{
				_permissions.push(tokenObj.permissions[i]);
			}
		}
	}
}