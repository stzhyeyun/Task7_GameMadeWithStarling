package ui.popup
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class PopupManager extends EventDispatcher
	{
		public static const SHOW:String = "show";
		public static const CLOSE:String = "close";
		
		private static var _current:PopupManager;
		private static var _popups:Dictionary;
		private static var _stack:Vector.<Popup>;
		private static var _background:Image;
		
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
					var popup:Popup = _popups[key];
					popup.dispose();
					popup = null;
					delete _popups[key];
				}
			}
			_popups = null;
			
			if (_stack)
			{
				_stack.splice(0, _stack.length);
			}
			_stack = null;
			
			if (_background)
			{
				_background.dispose();
			}
			_background = null;
		}
		
		public static function initialize():void
		{
			_current = new PopupManager();
			_popups = new Dictionary();
			_stack = new Vector.<Popup>();
			
			var stageWidth:Number = Starling.current.nativeStage.stageWidth;
			var stageHeight:Number = Starling.current.nativeStage.stageHeight;
			
			// Background
			var bitmapData:BitmapData = new BitmapData(64, 64, false, 0x000000);
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = 0.5; 
			bitmapData.colorTransform(new Rectangle(0, 0, bitmapData.width, bitmapData.height), ct);
			
			_background = new Image(Texture.fromBitmapData(bitmapData));
			_background.visible = false;
			_background.width = stageWidth;
			_background.height = stageHeight;
			
			// Exit
			var exit:ExitPopup = new ExitPopup();
			exit.initialize();
			var exitScale:Number =  stageWidth * 0.7 / exit.width;
			exit.width *= exitScale;
			exit.height *= exitScale;
			_popups[PopupName.EXIT] = exit;
			
			// Pause
			var pause:PausePopup = new PausePopup();
			pause.initialize();
			var pauseScale:Number =  stageWidth * 0.7 / pause.width;
			pause.width *= pauseScale;
			pause.height *= pauseScale;
			_popups[PopupName.PAUSE] = pause;
			
			// Setting
			var setting:SettingPopup = new SettingPopup();
			setting.initialize();
			var settingScale:Number =  stageWidth * 0.7 / setting.width;
			setting.width *= settingScale;
			setting.height *= settingScale;
			_popups[PopupName.SETTING] = setting;
			
			// Game Over
			var gameOver:GameOverPopup = new GameOverPopup();
			gameOver.initialize();
			var gameOverScale:Number =  stageWidth * 0.8 / gameOver.width;
			gameOver.width *= gameOverScale;
			gameOver.height *= gameOverScale;
			_popups[PopupName.GAME_OVER] = gameOver;
			
		}
		
		public static function showPopup(container:DisplayObjectContainer, name:String):void
		{
			if (!container || !name || !_popups[name])
			{
				if (!container) trace("showPopup : No container.");
				if (!name) trace("showPopup : No name.");
				if (!_popups[name]) trace("showPopup : Not registered name.");
				return;
			}
			
			if (name == PopupName.GAME_OVER)
			{
				_background.removeEventListener(TouchEvent.TOUCH, onEndedBackground);
			}
			else
			{
				_background.addEventListener(TouchEvent.TOUCH, onEndedBackground);
			}
			
			if (_stack.length > 0)
			{
				_stack[_stack.length - 1].touchable = false;
			}
			else
			{
				_background.visible = true;
				container.addChild(_background);
			}
			
			var popupToShow:Popup = _popups[name];
			popupToShow.x = Starling.current.nativeStage.stageWidth / 2;
			popupToShow.y = Starling.current.nativeStage.stageHeight / 2;
			popupToShow.show();
			
			container.addChild(popupToShow);

			_stack.push(_popups[name]);
			
			PopupManager.current.dispatchEvent(new Event(PopupManager.SHOW));
		}
		
		public static function closePopup(name:String):void
		{
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
			
			for (var i:int = _stack.length - 1; i >= index; i--)
			{
				_stack[_stack.length - 1].close();
				_stack[_stack.length - 1].removeFromParent();
				_stack.pop();
			}
			
			if (index - 1 >= 0)
			{
				_stack[index - 1].touchable = true;
			}
			else
			{
				_background.visible = false;
			}
			
			PopupManager.current.dispatchEvent(new Event(PopupManager.CLOSE));
		}
		
		private static function closeLastPopup():void
		{
			_stack[_stack.length - 1].close();
			_stack[_stack.length - 1].removeFromParent();
			_stack.pop();
			
			if (_stack.length == 0)
			{
				_background.visible = false;
			}
		}
		
		private static function onEndedBackground(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_background, TouchPhase.ENDED);
			
			if (touch)
			{
				closeLastPopup();
			}
		}
	}
}