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
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import system.Manager;
	
	public class PopupManager extends Manager
	{
		public static const SHOW:String = "show";
		public static const CLOSE:String = "close";

		private static var _instance:PopupManager;
		
		private const TAG:String = "[PopupManager]";
		
		private var _popups:Dictionary;
		private var _stack:Vector.<Popup>;
		private var _background:Image;
		
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
			_instance = null;
			
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
			
			// Reward
			var reward:RewardPopup = new RewardPopup();
			reward.initialize();
			var rewardScale:Number =  stageWidth * 0.8 / reward.width;
			reward.width *= rewardScale;
			reward.height *= rewardScale;
			_popups[PopupName.REWARD] = reward;
			
			this.dispatchEvent(new Event(Manager.INITIALIZED));
		}
		
		/**
		 * 팝업을 등록합니다. 
		 * @param name 팝업의 이름입니다.
		 * @param popup 등록할 팝업입니다.
		 * 
		 */
		public function addPopup(name:String, popup:Popup):void
		{
			if (!name || !popup)
			{
				if (!name) trace(TAG + " addPopup : No name.");
				if (!popup) trace(TAG + " addPopup : No popup.");
				return;
			}
			
			if (!_popups)
			{
				_popups = new Dictionary();	
			}
			_popups[name] = popup;
		}
		
		/**
		 * 등록된 팝업을 제거합니다. 
		 * @param name 제거할 팝업의 이름입니다.
		 * 
		 */
		public function removePopup(name:String):void
		{
			if (!name || !_popups || !_popups[name])
			{
				if (!name) trace(TAG + " removePopup : No name.");
				if (!_popups) trace(TAG + " removePopup : No registered pop-up.");
				if (!_popups[name]) trace(TAG + " removePopup : Not registered name.");
				return;
			}
			
			var popup:Popup = _popups[name];
			popup.dispose();
			popup = null;
			delete _popups[name];
		}
		
		/**
		 * 지정한 팝업을 가져옵니다. 
		 * @param name 얻고자 하는 팝업의 이름입니다.
		 * @return 해당 이름의 팝업을 반환합니다. 업을 경우 null을 반환합니다.
		 * 
		 */
		public function getPopup(name:String):Popup
		{
			if (!name || !_popups || !_popups[name])
			{
				if (!name) trace(TAG + " getPopup : No name.");
				if (!_popups) trace(TAG + " getPopup : No registered pop-up.");
				if (!_popups[name]) trace(TAG + " getPopup : Not registered name.");
				return null;
			}
			
			return _popups[name];
		}
		
		/**
		 * 팝업을 표시합니다. 
		 * @param container 팝업을 Child로 가질 DisplayObjectContainer입니다.
		 * @param name 표시할 팝업의 이름입니다.
		 * 
		 */
		public function showPopup(container:DisplayObjectContainer, name:String):void
		{
			if (!container || !name || !_popups[name])
			{
				if (!container) trace(TAG + " showPopup : No container.");
				if (!name) trace(TAG + " showPopup : No name.");
				if (!_popups[name]) trace(TAG + " showPopup : Not registered name.");
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
				// 이미 표시된 팝업이 있을 경우 터치 비황성화
				_stack[_stack.length - 1].touchable = false;
			}
			else
			{
				// 배경(반투명 레이어) 표시
				_background.visible = true;
				container.addChild(_background);
			}
			
			var popupToShow:Popup = _popups[name];
			popupToShow.x = Starling.current.nativeStage.stageWidth / 2;
			popupToShow.y = Starling.current.nativeStage.stageHeight / 2;
			popupToShow.show();
			
			// 팝업 표시
			container.addChild(popupToShow);

			// 팝업 히스트리화
			_stack.push(_popups[name]);
			
			// 팝업 표시 이벤트 dispatch
			this.dispatchEvent(new Event(SHOW));
		}
		
		/**
		 * 지정한 팝업을 닫습니다. 
		 * @param name 닫을 팝업의 이름입니다.
		 * 
		 */
		public function closePopup(name:String):void
		{
			if (!name || !_popups[name])
			{
				if (!name) trace(TAG + " closePopup : No name.");
				if (!_popups[name]) trace(TAG + " closePopup : Not registered name.");
				return;
			}
			
			var index:int = _stack.indexOf(_popups[name]);
			
			if (index == -1)
			{
				trace(TAG + " closePopup : You named closed Popup.");
				return;
			}
			
			// 지정한 팝업 이후에 열린 팝업도 모두 닫음
			for (var i:int = _stack.length - 1; i >= index; i--)
			{
				_stack[_stack.length - 1].close();
				_stack[_stack.length - 1].removeFromParent();
				_stack.pop();
			}
			
			// 닫힌 팝업 바로 이전 팝업 터치 활성화
			if (index - 1 >= 0)
			{
				_stack[index - 1].touchable = true;
			}
			else
			{
				_background.visible = false;
			}
			
			// 팝업 닫힘 이벤트 dispatch
			this.dispatchEvent(new Event(CLOSE));
		}
		
		/**
		 * 표시된 팝업 중 가장 위에 있는 팝업을 답습니다. 
		 * 
		 */
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