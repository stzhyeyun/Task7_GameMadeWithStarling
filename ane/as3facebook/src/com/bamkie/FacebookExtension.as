package com.bamkie
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class FacebookExtension
	{
		private const TAG:String = "[FacebookExtension]";
			
		private var _context:ExtensionContext;
		private var _accessTokenCallback:Function;
		private var _userInfoCallback:Function;
		
		public function FacebookExtension()
		{
			try
			{
				_context = ExtensionContext.createExtensionContext("com.bamkie.FacebookExtension", null);
			}
			catch (e:Error)
			{
				trace(e.message);	
			}
			
			if (_context)
			{
				_context.addEventListener(StatusEvent.STATUS, onListenEvent);
			}
		}
		
		public function dispose():void
		{
			if (_context)
			{
				_context.dispose();
			}
		}
		
		public function initialize(accessTokenCallback:Function, userInfoCallback:Function):void
		{
			if (!accessTokenCallback || !userInfoCallback)
			{
				if (!accessTokenCallback) trace(TAG + " initialize: No accessTokenCallback.");
				if (!userInfoCallback) trace(TAG + " initialize: No userInfoCallback.");
				return;
			}
			
			_accessTokenCallback = accessTokenCallback;
			_userInfoCallback = userInfoCallback;
		}
		
		public function logInWithReadPermissions(permissions:Array):void
		{
			_context.call("logInWithReadPermissions", permissions);
		}
		
		public function logOut():void
		{
			_context.call("logOut", null);
		}
		
		private function onListenEvent(event:StatusEvent):void
		{
			if (event.code == "accessToken")
			{
				trace(TAG + " onListenEvent : Got accessToken.");
				trace(TAG + " " + event.level);
				
				if (_accessTokenCallback)
				{
					_accessTokenCallback(event.level);
				}
			}
			else if (event.code == "userInfo")
			{
				trace(TAG + " onListenEvent : Got userInfo.");
				trace(TAG + " " + event.level);
				
				if (_userInfoCallback)
				{
					_userInfoCallback(event.level);
				}
			}
		}
	}
}