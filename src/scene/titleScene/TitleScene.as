package scene.titleScene
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import gamedata.DataManager;
	
	import resources.Resources;
	import resources.TextureAtlasName;
	import resources.TextureName;
	
	import scene.Scene;
	
	import system.NoticeManager;
	
	import starling.display.Image;
	import starling.events.Event;
	
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
		
		protected override function onStartScene(event:Event):void
		{
			if (_firstStart)
			{
				notice();
				_firstStart = false;
			}
		}
		
		protected override function onEndScene(event:Event):void
		{
			DataManager.instance.export();
			UserManager.instance.export();
		}
		
		protected override function onKeyDown(event:KeyboardEvent):void
		{
			if (!this.parent)
			{
				return;
			}
			
			if (event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				PopupManager.instance.showPopup(this, PopupName.EXIT);
			}
		}
		
		private function notice():void
		{
			if (NoticeManager.instance.isNotice)
			{
				var noticeList:Vector.<String> = NoticeManager.instance.noticeList;
				for (var i:int = noticeList.length - 1; i >= 0; i--)
				{
					PopupManager.instance.showPopup(this, noticeList[i]);
				}
			}
		}
	}
}