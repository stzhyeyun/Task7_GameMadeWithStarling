package ui.popup
{
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObjectContainer;
	
	public class PopupManager
	{
		private static var _popups:Dictionary;
		private static var _stack:Vector.<Popup>;
		
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
			// Create popups		
			
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
		}
		
		public static function closePopup(container:DisplayObjectContainer, name:String):void
		{
			// 이전 팝업 touchable = true
		}
	}
}