package scene.titleScene
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import gamedata.DataManager;
	
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
	}
}