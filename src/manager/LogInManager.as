package manager
{
	import com.bamkie.FacebookExtension;
	
	import flash.filesystem.File;
	
	import gamedata.Data;
	
	import resources.Resources;
	
	import starling.events.Event;
	
	import user.AccessToken;
	import user.UserInfo;

	public class LogInManager extends Manager
	{
		public static const LOG_IN:String = "logIn";
		public static const LOG_OUT:String = "logOut";
		
		private const TAG:String = "[LoginManager]";	
		
		private static var _instance:LogInManager;
		
		private var _numLoad:int;
		private var _path:File;
		
		private var _accessToken:AccessToken;
		private var _userInfo:UserInfo;
		
		private var _loggedIn:Boolean;
		private var _facebookExtension:FacebookExtension;

		public static function get instance():LogInManager
		{
			if (!_instance)
			{
				_instance = new LogInManager();
			}
			return _instance;
		}
		
		public function get userInfo():UserInfo
		{
			return _userInfo;
		}
		
		public function get loggedIn():Boolean
		{
			return _loggedIn;
		}
		
				
		public function LogInManager()
		{
			
		}
		
		public override function dispose():void
		{
			export();
			
			_instance = null;
			_accessToken = null;
			_userInfo = null;
			_facebookExtension = null;
		}
		
		public override function initialize():void
		{
			_loggedIn = false;
			
			_numLoad = 2;
			_path = File.applicationStorageDirectory.resolvePath("data");
			
			_accessToken = new AccessToken("accessToken", _path);
			_accessToken.addEventListener(Data.SUCCEEDED_READING, onReadAccessToken);
			_accessToken.addEventListener(Data.FAILED_READING, onFailedReadingAccessToken);
			_accessToken.read();
			
			_userInfo = new UserInfo("userInfo", _path);
			_userInfo.addEventListener(Data.SUCCEEDED_READING, onReadUserInfo);
			_userInfo.addEventListener(Data.FAILED_READING, onFailedReadingUserInfo);
			_userInfo.read();
		}
		
		public function checkLogIn():void
		{
			if (!_facebookExtension)
			{
				_facebookExtension = new FacebookExtension();
				_facebookExtension.initialize(onGotAccessToken, onGotUserInfo);
			}
			
			_facebookExtension.checkLogIn();
		}
		
		public function logIn():void
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
		
		public function logOut():void
		{
			if (!_facebookExtension)
			{
				_facebookExtension = new FacebookExtension();
				_facebookExtension.initialize(onGotAccessToken, onGotUserInfo);
			}
			
			_facebookExtension.logOut();
			
			_loggedIn = false;
			_accessToken.clean();
			_userInfo.clean();
			
			this.dispatchEvent(new Event(LOG_OUT));
		}
		
		public function export():void
		{
			if (_accessToken)
			{
				_accessToken.write();
			}
			
			if (_userInfo)
			{
				_userInfo.write();
			}
		}
		
		private function onReadAccessToken(event:Event):void
		{
			_numLoad--;
			checkLoadingProgress();
		}
		
		private function onFailedReadingAccessToken(event:Event):void
		{
			_numLoad--;
			checkLoadingProgress();
		}
		
		private function onReadUserInfo(event:Event):void
		{
			Resources.instance.loadFromURL(Resources.USER_PICTURE, _userInfo.userId);
			
			_loggedIn = true;
			this.dispatchEvent(new Event(LogInManager.LOG_IN));
			
			_numLoad--;
			checkLoadingProgress();
		}
		
		private function onFailedReadingUserInfo(event:Event):void
		{
			_loggedIn = false;
			this.dispatchEvent(new Event(LOG_OUT));
			
			_numLoad--;
			checkLoadingProgress();
		}
		
		private function checkLoadingProgress():void
		{
			if (_numLoad == 0)
			{
				_accessToken.removeEventListener(Data.SUCCEEDED_READING, onReadAccessToken);
				_accessToken.removeEventListener(Data.FAILED_READING, onFailedReadingAccessToken);
				
				_userInfo.removeEventListener(Data.SUCCEEDED_READING, onReadUserInfo);
				_userInfo.removeEventListener(Data.FAILED_READING, onFailedReadingUserInfo);
				
				this.dispatchEvent(new Event(Manager.INITIALIZED));
			}
		}
		
		private function onGotAccessToken(tokenData:String):void
		{
			_accessToken.setData(tokenData);
			_accessToken.write();
			
			Resources.instance.loadFromURL(Resources.USER_PICTURE, _accessToken.userId);
		}
		
		private function onGotUserInfo(info:String):void
		{
			_userInfo.setData(info);
			
			_loggedIn = true;
			this.dispatchEvent(new Event(LOG_IN));
		}
	}
}