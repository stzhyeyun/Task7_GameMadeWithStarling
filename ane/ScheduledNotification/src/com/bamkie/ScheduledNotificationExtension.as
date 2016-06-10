package com.bamkie
{
	import flash.external.ExtensionContext;

	public class ScheduledNotificationExtension
	{
		private const TAG:String = "[ScheduledNotificationExtension]";
		
		private var _context:ExtensionContext;
		
		
		public function ScheduledNotificationExtension()
		{
			try
			{
				_context = ExtensionContext.createExtensionContext("com.bamkie.ScheduledNotificationExtension", null);
			}
			catch (e:Error)
			{
				trace(e.message);	
			}
		}
		
		public function dispose():void
		{
			if (_context)
			{
				_context.dispose();
			}
		}
		
		public function setNotification(ticker:String, title:String, message:String, time:int):void
		{
			_context.call("setNotification", ticker, title, message, time);
		}
	}
}