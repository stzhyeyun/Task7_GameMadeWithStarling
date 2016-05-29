package ui.popup
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import resources.Resources;
	import resources.TextureName;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ExitPopup extends Popup
	{
		public function ExitPopup()
		{
			
		}
		
		public override function initialize():void
		{
			var alert:Image = new Image(Resources.getTexture(TextureName.ALERT));
			var confirm:Button = new Button(Resources.getTexture(TextureName.BTN_CONFIRM));
			var cancel:Button = new Button(Resources.getTexture(TextureName.BTN_CANCEL));
			
			confirm.pivotX = confirm.width / 2;
			confirm.pivotY = confirm.height / 2;
			confirm.x = alert.width * 0.3;
			confirm.y = alert.height;
			
			cancel.pivotX = cancel.width / 2;
			cancel.pivotY = cancel.height / 2;
			cancel.x = alert.width * 0.7;
			cancel.y = alert.height;
			
			confirm.addEventListener(TouchEvent.TOUCH, onEndedConfirmButton);
			cancel.addEventListener(TouchEvent.TOUCH, onEndedCancelButton);
			
			addChild(alert);
			addChild(confirm);
			addChild(cancel);
			
			super.initialize();
		}
		
		private function onEndedConfirmButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				NativeApplication.nativeApplication.dispatchEvent(new Event(Event.EXITING));
				NativeApplication.nativeApplication.exit(0);
			}
		}
		
		private function onEndedCancelButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				PopupManager.closePopup(PopupName.EXIT);
			}
		}
	}
}