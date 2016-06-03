package user
{
	public class AccessToken
	{
		private var _userId:String;
		private var _token:String;
		private var _expires:String;
		private var _permissions:Vector.<String>;
		
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
		
		
		public function AccessToken(tokenData:String)
		{
			parseData(tokenData);
		}
		
		public function dispose():void
		{
			// to do
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