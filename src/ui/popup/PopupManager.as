package ui.popup
{
	import flash.utils.Dictionary;
	
	import gamedata.DataManager;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class PopupManager extends EventDispatcher
	{
		public static const SHOW:String = "show";
		public static const CLOSE:String = "close";
		
		private static var _current:PopupManager;
		private static var _popups:Dictionary;
		private static var _stack:Vector.<Popup>;
		
		public static function get current():PopupManager
		{
			return _current;
		}
		
		
		public function PopupManager()
		{
			
		}

		public static function dispose():void
		{
			if (_popups)
			{
				for (var key:Object in _popups)
				{
					//_popups[key].dispose();
					delete _popups[key];
				}
			}
			_popups = null;
			
			if (_stack)
			{
				_stack.splice(0, _stack.length);
			}
			_stack = null;
		}
		
		public static function initialize():void
		{
			_current = new PopupManager();
			_popups = new Dictionary();
			_stack = new Vector.<Popup>();
			
			// Exit
			
			
			// Pause
			
			
			// Setting
			
			
			// Game Over
			
			
		}
		
		public static function showPopup(container:DisplayObjectContainer, name:String):void
		{
			trace("showPopup : " + container + ", " + name); // test
			
			// 이전 팝업 touchable = false
			
			if (!_stack)
			{
				_stack = new Vector.<Popup>();
			}
			
			// to do
			
			
			DataManager.current.dispatchEvent(new Event(PopupManager.SHOW));
		}
		
		public static function closePopup(container:DisplayObjectContainer, name:String):void
		{
			// 이전 팝업 touchable = true
			
			
			DataManager.current.dispatchEvent(new Event(PopupManager.CLOSE));
		}
	}
}