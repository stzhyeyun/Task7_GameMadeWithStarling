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
		
		private var _onReadyToPreset:Function;
		
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
		
		public function set onReadyToPreset(value:Function):void
		{
			_onReadyToPreset = value;
		}
		
		
		public function AccessToken(name:String, path:File, tokenData:String = null)
		{
			super(name, path);
			
			if (tokenData)
			{
				parseData(tokenData);
			}
		}
		
		public override function dispose():void
		{
			// to do
			
			
			super.dispose();
		}
		
		public override function write():void
		{
			if (!_name || !_path || !_userId || !_token)
			{
				if (!_name) trace(TAG + " write : No name.");
				if (!_path) trace(TAG + " write : No path.");
				if (!_userId) trace(TAG + " write : No userId.");
				if (!_token) trace(TAG + " write : No token.");
				return;
			}
			
			trace(TAG + " write : AccessToken is written.");
			
			var plainText:String = 
				"{\n\t\"userId\" : \""	+	_userId	+	"\",\n"	+
				"\t\"token\" : \""		+	_token	+	"\"\n}";

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
			trace(TAG + " onCompleteLoad : AccessToken loaded.");
			
			super.onCompleteLoad(event);
			
			var loader:URLLoader = event.target as URLLoader;
			if (!loader)
			{
				return;
			}
			
			var plainText:Object = JSON.parse(AesCrypto.decrypt(loader.data, "ahundrendblocksbybamkie"));
			
			_userId = plainText.userId;
			_token = plainText.token;
			
			if (_onReadyToPreset)
			{
				_onReadyToPreset();
			}
		}
		
		public function setData(tokenData:String):void
		{
			if (tokenData)
			{
				parseData(tokenData);
			}
		}
		
		private function parseData(tokenData:String):void
		{
			var array:Array = tokenData.replace(/[\s]+/gim, '').split("}");

			// User ID					
			var userId:String = array[0];
			_userId = userId.substring(userId.indexOf(":") + 1, userId.length);
			
			// Token
			var token:String = array[1];
			_token = token.substring(token.indexOf(":") + 1, token.length);
			
			// Expires
			var expires:String = array[2];
			_expires = expires.substring(expires.indexOf(":") + 1, expires.length);
			
			// Permissions
						
			
		}
	}
}