package user
{
	import com.bamkie.FacebookExtension;
	
	import resources.Resources;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class LoginManager extends EventDispatcher
	{
		public static const LOG_IN:String = "logIn";
		public static const LOG_OUT:String = "logOut";
		
		private static const TAG:String = "[LoginManager]";	
		
		private static var _current:LoginManager;
		
		private static var _accessToken:AccessToken;
		private static var _facebookExtension:FacebookExtension;
		
		public static function get current():LoginManager
		{
			return _current;
		}
		
				
		public function LoginManager()
		{
			
		}
		
		public static function initialize():void
		{
			_current = new LoginManager();
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
			
			LoginManager.current.dispatchEvent(new Event(LoginManager.LOG_OUT));
		}
		
		private static function onGotAccessToken(tokenData:String):void
		{
			if (_accessToken)
			{
				_accessToken.dispose();
				_accessToken = null;
			}
			
			_accessToken = new AccessToken(tokenData);
			var url:String = "https://graph.facebook.com/" + _accessToken.userId + "/picture?type=large";
			
			if (url)
			{
				Resources.loadImageFromURL(url);	
			}
			else
			{
				trace(TAG + " onGotAccessToken : Invalid user picture URL.");
			}
			
			LoginManager.current.dispatchEvent(new Event(LoginManager.LOG_IN));
		}
		
		private static function onGotUserInfo(info:String):void
		{
			// to do
		}
	}
}