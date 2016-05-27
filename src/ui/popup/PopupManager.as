package ui.popup
{
	import flash.utils.Dictionary;
	
	import resources.Resources;
	import resources.TextureName;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
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
			var exit:Popup = new Popup(new Image(Resources.getTexture(TextureName.ALERT)));
			var confirm:Button = new Button(Resources.getTexture(TextureName.BTN_CONFIRM));
			var cancel:Button = new Button(Resources.getTexture(TextureName.BTN_CANCEL));
			//exit.addAsset("confirm"
			
			_popups[PopupName.EXIT] = exit;
			
			// Pause
			
			
			// Setting
			
			
			// Game Over
			
			
		}
		
		public static function showPopup(container:DisplayObjectContainer, name:String):void
		{
			trace("showPopup : " + container + ", " + name); // test
			
			if (!container || !name || !_popups[name])
			{
				if (!container) trace("showPopup : No container.");
				if (!name) trace("showPopup : No name.");
				if (!_popups[name]) trace("showPopup : Not registered name.");
				return;
			}
			
			if (_stack.length > 0)
			{
				_stack[_stack.length - 1].touchable = false;
			}
			
			var popupToShow:Popup = _popups[name];
			popupToShow.x = container.width / 2;
			popupToShow.y = container.height / 2;
			popupToShow.touchable = true;
			container.addChild(popupToShow);

			_stack.push(_popups[name]);
			
			PopupManager.current.dispatchEvent(new Event(PopupManager.SHOW));
		}
		
		public static function closePopup(name:String):void
		{
			trace("closePopup : " + name); // test
			
			if (!name || !_popups[name])
			{
				if (!name) trace("closePopup : No name.");
				if (!_popups[name]) trace("closePopup : Not registered name.");
				return;
			}
			
			var index:int = _stack.indexOf(_popups[name]);
			
			if (index == -1)
			{
				trace("closePopup : You named closed Popup.");
				return;
			}
			
			if (index == _stack.length - 1)
			{
				_stack.pop().removeFromParent();
			}
			else
			{
				for (var i:int = _stack.length - 1; i >= index; i--)
				{
					_stack.pop().removeFromParent();
				}
			}
			
			if (index - 1 >= 0)
			{
				_stack[index - 1].touchable = true;
			}
			
			PopupManager.current.dispatchEvent(new Event(PopupManager.CLOSE));
		}
	}
}