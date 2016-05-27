package scene.titleScene
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import scene.Scene;
	
	import ui.popup.PopupManager;
	import ui.popup.PopupName;

	public class TitleScene extends Scene
	{
		public function TitleScene()
		{
			
		}
		
		public override function initialize():void
		{
			var titleUI:TitleSceneUI = new TitleSceneUI();
			titleUI.initialize(this.nativeStageWidth, this.nativeStageHeight);
			addChild(titleUI);
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