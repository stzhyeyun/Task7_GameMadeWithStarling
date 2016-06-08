package ui.popup
{
	import gamedata.DataManager;
	
	import resources.Resources;
	import resources.TextureName;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import user.LogInManager;
	import user.UserInfo;

	public class RankPopup extends Popup
	{
		private const RANK_PER_PAGE:int = 5;
		
		private var _userRank:int;
		private var _prevTop:int;
		private var _currTop:int;
		
		
		public function RankPopup()
		{
			
		}
		
		public override function dispose():void
		{
			DataManager.current.removeEventListener(DataManager.UPDATE_RANK, onUpdateRank);
			LogInManager.current.removeEventListener(LogInManager.LOG_IN, onLogIn);
			LogInManager.current.removeEventListener(LogInManager.LOG_OUT, onLogOut);
						
			super.dispose();
		}
		
		public override function initialize():void
		{
			var panel:Image = new Image(Resources.getTexture(TextureName.POPUP));
			var title:Image = new Image(Resources.getTexture(TextureName.TITLE_RANK));
			var top:Button = new Button(Resources.getTexture(TextureName.BTN_TOP));
			var up:Button = new Button(Resources.getTexture(TextureName.BTN_UP));
			var userRank:Button = new Button(Resources.getTexture(TextureName.BTN_MY));
			var down:Button = new Button(Resources.getTexture(TextureName.BTN_DOWN));
			
			title.pivotX = title.width / 2;
			title.pivotY = title.height / 2;
			title.x = panel.width / 2;
			
			top.x = panel.width * 0.8;
			top.y = panel.height * 0.15;
			top.addEventListener(TouchEvent.TOUCH, onEndedTopButton);
			
			up.x = panel.width * 0.8;
			up.y = panel.height * 0.4;
			up.addEventListener(TouchEvent.TOUCH, onEndedUpButton);
			
			userRank.x = panel.width * 0.8;
			userRank.y = panel.height * 0.55;
			userRank.addEventListener(TouchEvent.TOUCH, onEndedUserButton);
			
			down.x = panel.width * 0.8;
			down.y = panel.height * 0.7;
			down.addEventListener(TouchEvent.TOUCH, onEndedDownButton);
			
			addChild(panel);
			addChild(title);
			addChild(top);
			addChild(up);
			addChild(userRank);
			addChild(down);
			
			_userRank = 0;
			_prevTop = 1;
			_currTop = 1;
			
			var userInfo:UserInfo = LogInManager.userInfo;
			if (userInfo.id)
			{
				_userRank = DataManager.rank.getRank(userInfo);
				if (_userRank > 0)
				{
					_prevTop = _currTop;
					_currTop = _userRank - RANK_PER_PAGE / 2;
				}
			}
			setRanker();
			
			DataManager.current.addEventListener(DataManager.UPDATE_RANK, onUpdateRank);
			LogInManager.current.addEventListener(LogInManager.LOG_IN, onLogIn);
			LogInManager.current.addEventListener(LogInManager.LOG_OUT, onLogOut);
			
			super.initialize();
		}
		
		private function setRanker():void
		{
			if (_currTop <= 0)
			{
				_currTop = 1;
			}
			
			var count:int = DataManager.rank.count();
			
			if (_currTop > count)
			{
				_currTop = _prevTop;
			}
			
			var userInfo:UserInfo;
			var top:int = _currTop;
			for (var i:int = 0; i < RANK_PER_PAGE; i++)
			{
				userInfo = DataManager.rank.getUser(top++);
				
				if (userInfo)
				{
					
				}
			}
			
			// to do
			
			
		}
		
		private function onUpdateRank(event:Event):void
		{
			_userRank = int(event.data);
			_prevTop = _currTop;
			_currTop = _userRank - RANK_PER_PAGE / 2;
			setRanker();
		}
		
		private function onLogIn(event:Event):void
		{
			var userInfo:UserInfo = LogInManager.userInfo;
			if (userInfo.id)
			{
				_userRank = DataManager.rank.getRank(userInfo);
				if (_userRank > 0)
				{
					_prevTop = _currTop;
					_currTop = _userRank - RANK_PER_PAGE / 2;
					setRanker();
				}
			}
		}
		
		private function onLogOut(event:Event):void
		{
			_userRank = 0;
			_prevTop = _currTop;
			_currTop = 1;
			setRanker();
		}
		
		private function onEndedTopButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				_prevTop = _currTop;
				_currTop = 1;
				setRanker();
			}
		}
		
		private function onEndedUpButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				_prevTop = _currTop;
				_currTop -= RANK_PER_PAGE;
				setRanker();
			}
		}
		
		private function onEndedUserButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				if (_userRank > 0)
				{
					_prevTop = _currTop;
					_currTop = _userRank - RANK_PER_PAGE / 2;
					setRanker();
				}
			}
		}
		
		private function onEndedDownButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				_prevTop = _currTop;
				_currTop += RANK_PER_PAGE;
				setRanker();
			}
		}
	}
}