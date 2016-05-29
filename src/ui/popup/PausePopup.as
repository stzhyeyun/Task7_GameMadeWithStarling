package ui.popup
{
	import resources.Resources;
	import resources.TextureName;
	
	import scene.SceneManager;
	import scene.SceneName;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class PausePopup extends Popup
	{
		public function PausePopup()
		{
			
		}
		
		public override function initialize():void
		{
			var panel:Image = new Image(Resources.getTexture(TextureName.POPUP_MINI));
			var title:Image = new Image(Resources.getTexture(TextureName.TITLE_PAUSE));
			var resume:Button = new Button(Resources.getTexture(TextureName.BTN_RESUME));
			var replay:Button = new Button(Resources.getTexture(TextureName.BTN_REPLAY));
			var menu:Button = new Button(Resources.getTexture(TextureName.BTN_MENU));
			
			title.pivotX = title.width / 2;
			title.pivotY = title.height / 2;
			title.x = panel.width / 2;
			
			var btnY:Number = panel.height / 2;
			
			resume.pivotX = resume.width / 2;
			resume.pivotY = resume.height / 2;
			resume.x = panel.width * 0.25;
			resume.y = btnY
			
			replay.pivotX = replay.width / 2;
			replay.pivotY = replay.height / 2;
			replay.x = panel.width * 0.5;
			replay.y = btnY;
			
			menu.pivotX = replay.width / 2;
			menu.pivotY = replay.height / 2;
			menu.x = panel.width * 0.75;
			menu.y = btnY;
			
			resume.addEventListener(TouchEvent.TOUCH, onEndedResumeButton);
			replay.addEventListener(TouchEvent.TOUCH, onEndedReplayButton);
			menu.addEventListener(TouchEvent.TOUCH, onEndedMenuButton);
			
			addChild(panel);
			addChild(title);
			addChild(resume);
			addChild(replay);
			addChild(menu);
			
			super.initialize();
		}
		
		private function onEndedResumeButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				PopupManager.closePopup(PopupName.PAUSE);
			}
		}
		
		private function onEndedReplayButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				SceneManager.restartScene();
				PopupManager.closePopup(PopupName.PAUSE);
			}
		}
		
		private function onEndedMenuButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				SceneManager.switchScene(SceneName.TITLE);
				PopupManager.closePopup(PopupName.PAUSE);
			}
		}
	}
}