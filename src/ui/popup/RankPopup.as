package ui.popup
{
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import gamedata.DataManager;
	import gamedata.Rank;
	
	import resources.Resources;
	import resources.TextureAtlasName;
	import resources.TextureName;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	
	import ui.SpriteNumber;
	
	import user.UserInfo;
	import user.UserManager;
	
	import util.Color;

	public class RankPopup extends Popup
	{
		private const TAG:String = "[RankPopup]";
		private const RANK_PER_PAGE:int = 5;
		
		private var _userRankButton:Button;
		private var _message:Image;
		private var _rankerPanels:Vector.<Sprite>;
		
		private var _userRank:int;
		private var _prevTop:int;
		private var _currTop:int;
		private var _numLoadRequest:int;
		private var _needToSetPicIndices:Dictionary;
		private var _forcedToFocus:Boolean;
		
		
		public function RankPopup()
		{
			
		}
		
		public override function dispose():void
		{
			DataManager.instance.removeEventListener(DataManager.UPDATE_RANK, onUpdateRank);
			UserManager.instance.removeEventListener(UserManager.LOG_IN, onLogIn);
			UserManager.instance.removeEventListener(UserManager.LOG_OUT, onLogOut);
						
			super.dispose();
		}
		
		public override function initialize():void
		{
			var panel:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.POPUP));
			var title:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.TITLE_RANK));
			var top:Button = new Button(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.BTN_TOP));
			var up:Button = new Button(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.BTN_UP));
			var down:Button = new Button(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.BTN_DOWN));
			_message = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.TEXT_NO_DATA));
			_userRankButton = new Button(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.BTN_MY));
			
			title.pivotX = title.width / 2;
			title.pivotY = title.height / 2;
			title.x = panel.width / 2;
			
			top.x = panel.width * 0.8;
			top.y = panel.height * 0.15;
			top.addEventListener(TouchEvent.TOUCH, onEndedTopButton);
			
			up.x = panel.width * 0.8;
			up.y = panel.height * 0.38;
			up.addEventListener(TouchEvent.TOUCH, onEndedUpButton);
			
			_userRankButton.x = panel.width * 0.8;
			_userRankButton.y = panel.height * 0.53;
			_userRankButton.addEventListener(TouchEvent.TOUCH, onEndedUserButton);
			if (!UserManager.instance.loggedIn)
			{
				_userRankButton.touchable = false;
				_userRankButton.color = Color.INACTIVE;		
			}
			
			down.x = panel.width * 0.8;
			down.y = panel.height * 0.68;
			down.addEventListener(TouchEvent.TOUCH, onEndedDownButton);
			
			_message.scale = 1.5;
			_message.pivotX = _message.width / 2;
			_message.pivotY = _message.height / 2;
			_message.x = panel.width * 0.5;
			_message.y = panel.height / 2;
			
			addChild(panel);
			addChild(title);
			addChild(top);
			addChild(up);
			addChild(_userRankButton);
			addChild(down);
			addChild(_message);
			
			// Ranker panels
			_rankerPanels = new Vector.<Sprite>();
			var ranker:Sprite;
			var rankerPanel:Image;
			var picture:Image;
			var rank:SpriteNumber;
			var score:SpriteNumber;
			var name:TextField;
			var rankScale:Number;
			var scoreScale:Number;
			var format:TextFormat = new TextFormat("DaumSemiBold", 50, Color.RANKER, TextFormatAlign.LEFT);
			for (var i:int = 0; i < RANK_PER_PAGE; i++)
			{
				ranker = new Sprite();
				ranker.x = panel.width * 0.1;
				ranker.y = panel.width * 0.15 * (i + 1);

				rankerPanel = new Image(
					Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_PANEL_GRAY));
				rankerPanel.name = "panel";
				rankerPanel.width = panel.width * 0.65;
				rankerPanel.height = panel.height * 0.15;
				
				picture = new Image(
					Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_ANONYMOUS));
				picture.name = "picture";
				picture.height = rankerPanel.height * 0.75;
				picture.width = picture.height;
				picture.x = rankerPanel.width * 0.2;
				picture.y = (rankerPanel.height / 2) - (picture.height / 2);
				
				rank = new SpriteNumber("123", Color.RANKER);
				rank.name = "rank";
				rankScale = rankerPanel.width * 0.1 / rank.width;
				rank.width *= rankScale;
				rank.height *= rankScale;
				rank.pivotX = rank.width / 2;
				rank.x = picture.x - (rank.width / 2 + rank.width / 4);
				rank.y = (rankerPanel.height - rank.height) / 2;
				
				name = new TextField(
					int(rankerPanel.width * 0.5), int(rankerPanel.height * 0.3), "Null", format);
				name.name = "name";
				name.autoScale = true;
				name.x = rankerPanel.width * 0.4;
				name.y = rankerPanel.height * 0.2;
				
				score = new SpriteNumber("123456", Color.RANKER);
				score.name = "score";
				scoreScale = rankerPanel.height * 0.3 / score.height;
				score.width *= scoreScale;
				score.height *= scoreScale;
				score.x = name.x + score.width / 2;
				score.y = name.y + name.height + score.height / 8;
				
				ranker.addChild(rankerPanel);
				ranker.addChild(rank);
				ranker.addChild(picture);
				ranker.addChild(name);
				ranker.addChild(score);
				
				ranker.visible = false;
				
				_rankerPanels.push(ranker);
				addChild(ranker);
			}
			
			// Set ranker
			_userRank = 0;
			_prevTop = 0;
			_currTop = 1;
			_numLoadRequest = 0;
			_needToSetPicIndices = new Dictionary();
			_forcedToFocus = false;
			
			var userInfo:UserInfo = UserManager.instance.userInfo;
			if (userInfo && userInfo.userId)
			{
				_forcedToFocus = true;
				DataManager.instance.rank.addEventListener(Rank.GET_RANK, onGotRank);
				DataManager.instance.rank.getRank(userInfo);
			}
			else
			{
				setRanker();
			}
			
			DataManager.instance.addEventListener(DataManager.UPDATE_RANK, onUpdateRank);
			UserManager.instance.addEventListener(UserManager.LOG_IN, onLogIn);
			UserManager.instance.addEventListener(UserManager.LOG_OUT, onLogOut);
			
			super.initialize();
		}
		
		public override function close():void
		{
			if (_userRank > 0)
			{
				_currTop = _userRank - int(RANK_PER_PAGE / 2);
				_forcedToFocus = true;
				setRanker();
			}
			
			super.close();
		}
		
		private function setRanker():void
		{
			if (_currTop <= 0)
			{
				_currTop = 1;
			}
			
			if (_currTop == _prevTop)
			{
				return;
			}
			
			DataManager.instance.rank.addEventListener(Rank.COUNT, onGotCount);
			DataManager.instance.rank.count();
		}
		
		private function onGotCount(event:Event):void
		{
			DataManager.instance.rank.removeEventListener(Rank.COUNT, onGotCount);
			
			var count:int = int(event.data);
			if (_currTop > count)
			{
				_currTop = _prevTop;
				return;
			}
			
			DataManager.instance.rank.addEventListener(Rank.GET_USER, onGotUser);
			
			if (_forcedToFocus)
			{
				DataManager.instance.rank.getUser(
					_currTop, RANK_PER_PAGE, UserManager.instance.userInfo.userId);
				_forcedToFocus = false;
			}
			else
			{
				DataManager.instance.rank.getUser(_currTop, RANK_PER_PAGE);
			}
		}
		
		private function onGotUser(event:Event):void
		{
			DataManager.instance.rank.removeEventListener(Rank.GET_USER, onGotUser);
			
			var userInfoVec:Vector.<UserInfo> = event.data as Vector.<UserInfo>;
			if (!userInfoVec)
			{
				return;
			}
			
			_message.visible = false;
			
			var rankValue:int = _currTop;
			_prevTop = _currTop;
			_numLoadRequest = 0;
			
			var panel:Image;
			var rank:SpriteNumber;
			var name:TextField;
			var score:SpriteNumber;
			for (var i:int = 0; i < _rankerPanels.length; i++)
			{
				if (i < userInfoVec.length)
				{
					_rankerPanels[i].visible = true;
					
					panel = _rankerPanels[i].getChildByName("panel") as Image;
					rank = _rankerPanels[i].getChildByName("rank") as SpriteNumber;
					name = _rankerPanels[i].getChildByName("name") as TextField;
					score = _rankerPanels[i].getChildByName("score") as SpriteNumber;
					
					if (rankValue == _userRank)
					{
						panel.texture = 
							Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_PANEL_BROWN);
						rank.color = Color.RANKER_USER;
						score.color = Color.RANKER_USER;
						name.format.color = Color.RANKER_USER;
					}
					else
					{
						panel.texture = 
							Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_PANEL_GRAY);
						rank.color = Color.RANKER;
						score.color = Color.RANKER;
						name.format.color = Color.RANKER;
					}
					
					rank.update(rankValue.toString());
					score.update(userInfoVec[i].score.toString());
					name.text = userInfoVec[i].userName;
					
					_numLoadRequest++;
					_needToSetPicIndices[userInfoVec[i].userId] = i;
					Resources.instance.addEventListener(Resources.READY_USER_PICTURE, onLoadedUserPicture);
					Resources.instance.loadFromURL(Resources.USER_PICTURE, userInfoVec[i].userId);
				}
				else
				{
					_rankerPanels[i].visible = false;
				}
				
				rankValue++;
			} // for (var i:int = 0; i < _rankerPanels.length; i++)
		}
		
		private function onGotRank(event:Event):void
		{
			DataManager.instance.rank.removeEventListener(Rank.GET_RANK, onGotRank);
			_userRank = int(event.data);
			
			if (_userRank > 0)
			{
				_userRankButton.touchable = true;
				_userRankButton.color = 0xffffff;
				
				_currTop = _userRank - int(RANK_PER_PAGE / 2);
			}
			setRanker();
		}
		
		private function onLoadedUserPicture(event:Event):void
		{
			var userId:String = event.data as String;
			if (!userId || !_needToSetPicIndices || _needToSetPicIndices[userId] == null)
			{
				if (!userId) 
					trace(TAG + " onLoadedUserPicture : No userId.");
				if (!_needToSetPicIndices) 
					trace(TAG + " onLoadedUserPicture : No need to set picture.");
				if (_needToSetPicIndices[userId] == null) 
					trace(TAG + " onLoadedUserPicture : Not registered userId.");
				
				_numLoadRequest--;
				return;	
			}
			
			var index:int = _needToSetPicIndices[userId];
			delete _needToSetPicIndices[userId];
			if (index < 0 || index >= _rankerPanels.length)
			{
				trace(TAG + " onLoadedUserPicture : Invalid index.");
				return;
			}

			var picture:Image = _rankerPanels[index].getChildByName("picture") as Image;
			var texture:Texture = Resources.instance.getUserPicture(userId);
			
			if (texture)
			{
				picture.texture = texture;
			}
			else
			{
				picture.texture = Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_ANONYMOUS);
			}
			
			_numLoadRequest--;
			
			if (_numLoadRequest <= 0)
			{
				Resources.instance.removeEventListener(Resources.READY_USER_PICTURE, onLoadedUserPicture);
			}
		}

		private function onUpdateRank(event:Event):void
		{
			_userRank = int(event.data);
			_currTop = _userRank - int(RANK_PER_PAGE / 2);
			setRanker();
		}
		
		private function onLogIn(event:Event):void
		{
			var userInfo:UserInfo = UserManager.instance.userInfo;
			if (userInfo.userId)
			{
				_forcedToFocus = true;
				DataManager.instance.rank.addEventListener(Rank.GET_RANK, onGotRank);
				DataManager.instance.rank.getRank(userInfo);
			}
		}
		
		private function onLogOut(event:Event):void
		{
			_userRankButton.touchable = false;
			_userRankButton.color = Color.INACTIVE;
			
			_userRank = 0;
			_currTop = 1;
			setRanker();
		}
		
		private function onEndedTopButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				_currTop = 1;
				setRanker();
			}
		}
		
		private function onEndedUpButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
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
					_currTop = _userRank - int(RANK_PER_PAGE / 2);
					_forcedToFocus = true;
					setRanker();
				}
			}
		}
		
		private function onEndedDownButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				_currTop += RANK_PER_PAGE;
				setRanker();
			}
		}
	}
}