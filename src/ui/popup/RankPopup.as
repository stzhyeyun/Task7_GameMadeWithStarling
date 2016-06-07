package ui.popup
{
	import resources.Resources;
	import resources.TextureName;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.TouchEvent;

	public class RankPopup extends Popup
	{
		public function RankPopup()
		{
			
		}
		
		public override function initialize():void
		{
//			var alert:Image = new Image(Resources.getTexture(TextureName.ALERT));
//			var confirm:Button = new Button(Resources.getTexture(TextureName.BTN_CONFIRM));
//			var cancel:Button = new Button(Resources.getTexture(TextureName.BTN_CANCEL));
//			
//			confirm.pivotX = confirm.width / 2;
//			confirm.pivotY = confirm.height / 2;
//			confirm.x = alert.width * 0.3;
//			confirm.y = alert.height;
//			
//			cancel.pivotX = cancel.width / 2;
//			cancel.pivotY = cancel.height / 2;
//			cancel.x = alert.width * 0.7;
//			cancel.y = alert.height;
//			
//			confirm.addEventListener(TouchEvent.TOUCH, onEndedConfirmButton);
//			cancel.addEventListener(TouchEvent.TOUCH, onEndedCancelButton);
//			
//			addChild(alert);
//			addChild(confirm);
//			addChild(cancel);
			
			super.initialize();
		}
	}
}