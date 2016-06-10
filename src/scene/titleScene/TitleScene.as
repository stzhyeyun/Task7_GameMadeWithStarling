package scene.titleScene
{
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import gamedata.DataManager;
	import gamedata.DatabaseURL;
	
	import resources.Resources;
	import resources.TextureName;
	
	import scene.Scene;
	
	import starling.display.Image;
	import starling.events.Event;
	
	import ui.popup.PopupManager;
	import ui.popup.PopupName;
	
	public class TitleScene extends Scene
	{
		public function TitleScene()
		{

		}
		
		public override function initialize():void
		{
			// Background
			var background:Image = new Image(Resources.getTexture(TextureName.BACKGROUND_TITLE));
			background.width = this.nativeStageWidth;
			background.height = this.nativeStageHeight;
			addChild(background);
			
			// UI
			var titleUI:TitleSceneUI = new TitleSceneUI();
			titleUI.initialize(this.nativeStageWidth, this.nativeStageHeight);
			addChild(titleUI);
			
			notice();
		}
		
		protected override function onEndScene(event:Event):void
		{
			DataManager.export();
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
				PopupManager.showPopup(this, PopupName.EXIT);
			}
		}
		
		private function notice():void
		{
			var localNow:Date = new Date();
			var gmtNow:Date = new Date(
				localNow.getUTCFullYear(), localNow.getUTCMonth(), localNow.getUTCDate(),
				localNow.getUTCHours(), localNow.getUTCMinutes(), localNow.getUTCSeconds(), localNow.getUTCMilliseconds());
			gmtNow.setHours(gmtNow.hours + 9);
				
			var url:String =
				DatabaseURL.NOTICE +
				"getNoticeToShow.php" +
				"?now=" + gmtNow;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(flash.events.Event.COMPLETE, onGotNoticeData);
		}
		
		private function onGotNoticeData(event:flash.events.Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, onGotNoticeData);
			
			if (urlLoader.data != "[]")
			{
				var data:Object = JSON.parse(urlLoader.data);
				
				for (var i:int = 0; i < data.length; i++)
				{
					// load image from URL
					//data[i].image
				}
			}
						
			// create popup
			// add popup
			// show popup
			// close popup
			// remove popup
		}
	}
}