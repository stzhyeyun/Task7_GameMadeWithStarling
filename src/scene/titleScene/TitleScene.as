package scene.titleScene
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import gamedata.DataManager;
	
	import resources.Resources;
	import resources.TextureAtlasName;
	import resources.TextureName;
	
	import scene.Scene;
	
	import starling.display.Image;
	import starling.events.Event;
	
	import system.AttendanceManager;
	import system.NoticeManager;
	
	import ui.popup.PopupManager;
	import ui.popup.PopupName;
	
	import user.UserManager;
	
	public class TitleScene extends Scene
	{
		private var _firstStart:Boolean;
		
		
		public function TitleScene()
		{

		}
		
		public override function initialize():void
		{
			_firstStart = true;
			
			// Background
			var background:Image = new Image(Resources.instance.getTexture(TextureAtlasName.LOADING, TextureName.BACKGROUND_TITLE));
			background.width = this.nativeStageWidth;
			background.height = this.nativeStageHeight;
			addChild(background);
			
			// UI
			var titleUI:TitleSceneUI = new TitleSceneUI();
			titleUI.initialize(this.nativeStageWidth, this.nativeStageHeight);
			addChild(titleUI);
		}
		
		public override function dispose():void
		{
			AttendanceManager.instance.removeEventListener(AttendanceManager.READY_TO_REWARD, onReadyToReward);
			
			super.dispose();
		}
		
		protected override function onStartScene(event:Event):void
		{
			AttendanceManager.instance.addEventListener(AttendanceManager.READY_TO_REWARD, onReadyToReward);
			
			if (_firstStart)
			{
				// Notice
				if (NoticeManager.instance.isNotice)
				{
					var noticeList:Vector.<String> = NoticeManager.instance.noticeList;
					for (var i:int = noticeList.length - 1; i >= 0; i--)
					{
						PopupManager.instance.showPopup(this, noticeList[i]);
					}
				}
				
				// Reward
				if (!AttendanceManager.instance.rewarded)
				{
					PopupManager.instance.showPopup(this, PopupName.REWARD);
				}
				
				_firstStart = false;
			}
		}
		
		protected override function onEndScene(event:Event):void
		{
			AttendanceManager.instance.removeEventListener(AttendanceManager.READY_TO_REWARD, onReadyToReward);
			
			// 데이터 출력
			DataManager.instance.export();
			UserManager.instance.export();
		}
		
		protected override function onKeyDown(event:KeyboardEvent):void
		{
			if (!this.parent)
			{
				return;
			}
			
			// 종료 팝업 표시
			if (event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				PopupManager.instance.showPopup(this, PopupName.EXIT);
			}
		}
		
		private function onReadyToReward(event:Event):void
		{
			// Reward
			PopupManager.instance.showPopup(this, PopupName.REWARD);
		}
	}
}