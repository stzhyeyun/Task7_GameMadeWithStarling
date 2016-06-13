package manager
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import ui.popup.ExitPopup;
	import ui.popup.GameOverPopup;
	import ui.popup.PausePopup;
	import ui.popup.Popup;
	import ui.popup.PopupName;
	import ui.popup.RankPopup;
	import ui.popup.SettingPopup;
	
	public class PopupManager extends Manager
	{
		public static const SHOW:String = "show";
		public static const CLOSE:String = "close";
		
		private static var _instance:PopupManager;
		
		private static var _popups:Dictionary;
		private static var _stack:Vector.<Popup>;
		private static var _background:Image;
		
		public static function get instance():PopupManager
		{
			if (!_instance)
			{
				_instance = new PopupManager();
			}
			return _instance;
		}
		
		
		public function PopupManager()
		{
			
		}

		public override function dispose():void
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
		
		public override function initialize():void
		{
			_instance = new PopupManager();
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
			
			// Rank
			var rank:RankPopup = new RankPopup();
			rank.initialize();
			var rankScale:Number =  stageWidth * 0.8 / rank.width;
			rank.width *= rankScale;
			rank.height *= rankScale;
			_popups[PopupName.RANK] = rank;
		}
		
		public function addPopup(name:String, popup:Popup):void
		{
			if (!name || !popup)
			{
				if (!name) trace("addPopup : No name.");
				if (!popup) trace("addPopup : No popup.");
				return;
			}
			
			if (!_popups)
			{
				_popups = new Dictionary();	
			}
			_popups[name] = popup;
		}
		
		public function removePopup(name:String):void
		{
			if (!name || !_popups || !_popups[name])
			{
				if (!name) trace("removePopup : No name.");
				if (!_popups) trace("removePopup : No registered pop-up.");
				if (!_popups[name]) trace("removePopup : Not registered name.");
				return;
			}
			
			var popup:Popup = _popups[name];
			popup.dispose();
			popup = null;
			delete _popups[name];
		}
		
		public function showPopup(container:DisplayObjectContainer, name:String):void
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
			
			this.dispatchEvent(new Event(SHOW));
		}
		
		public function closePopup(name:String):void
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
			
			this.dispatchEvent(new Event(CLOSE));
		}
		
		private function closeLastPopup():void
		{
			_stack[_stack.length - 1].close();
			_stack[_stack.length - 1].removeFromParent();
			_stack.pop();
			
			if (_stack.length == 0)
			{
				_background.visible = false;
			}
		}
		
		private function onEndedBackground(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_background, TouchPhase.ENDED);
			
			if (touch)
			{
				closeLastPopup();
			}
		}
	}
}