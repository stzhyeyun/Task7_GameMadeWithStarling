package user
{
	import com.bamkie.FacebookExtension;
	
	import flash.filesystem.File;
	
	import resources.Resources;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class LogInManager extends EventDispatcher
	{
		public static const LOG_IN:String = "logIn";
		public static const LOG_OUT:String = "logOut";
		
		private static const TAG:String = "[LoginManager]";	
		
		private static var _current:LogInManager;
		private static var _loggedIn:Boolean;
		private static var _accessToken:AccessToken;
		private static var _facebookExtension:FacebookExtension;

		public static function get current():LogInManager
		{
			return _current;
		}
		
		public static function get loggedIn():Boolean
		{
			return _loggedIn;
		}
		
				
		public function LogInManager()
		{
			
		}
		
		public static function dispose():void
		{
			_accessToken.write();
			
			_current = null;
			_accessToken = null;
			_facebookExtension = null;
		}
		
		public static function initialize():void
		{
			_current = new LogInManager();
			
			_loggedIn = false;
			
			_accessToken = new AccessToken(
				"accessToken", File.applicationStorageDirectory.resolvePath("data"));
			_accessToken.onReadyToPreset = loadUserPicture;
			_accessToken.read();
		}
		
		public static function checkLogIn():void
		{
			if (!_facebookExtension)
			{
				_facebookExtension = new FacebookExtension();
				_facebookExtension.initialize(onGotAccessToken, onGotUserInfo);
			}
			
			_facebookExtension.checkLogIn();
		}
		
		public static function logIn():void
		{
			if (!_facebookExtension)
			{
				_facebookExtension = new FacebookExtension();
				_facebookExtension.initialize(onGotAccessToken, onGotUserInfo);
			}
			
			var permissions:Array = new Array();
			permissions.push("public_profile");
			
			_facebookExtension.logInWithReadPermissions(permissions);
		}
		
		public static function logOut():void
		{
			if (!_facebookExtension)
			{
				_facebookExtension = new FacebookExtension();
				_facebookExtension.initialize(onGotAccessToken, onGotUserInfo);
			}
			
			_facebookExtension.logOut();
			_loggedIn = false;
			
			LogInManager.current.dispatchEvent(new Event(LogInManager.LOG_OUT));
		}
		
		public static function export():void
		{
			if (_accessToken)
			{
				_accessToken.write();
			}
		}
		
		private static function onGotAccessToken(tokenData:String):void
		{
			_accessToken.setData(tokenData);
			_accessToken.write();
			
			loadUserPicture();
			
			LogInManager.current.dispatchEvent(new Event(LogInManager.LOG_IN));
		}
		
		private static function loadUserPicture():void
		{
			var url:String = "https://graph.facebook.com/" + _accessToken.userId + "/picture?type=large";
			
			if (url)
			{
				Resources.loadImageFromURL(url);
				_loggedIn = true;
			}
			else
			{
				trace(TAG + " onGotAccessToken : Invalid user picture URL.");
			}
		}
		
		private static function onGotUserInfo(info:String):void
		{
			// to do
		}
	}
}