package ui.popup
{
	import gamedata.DataManager;
	
	import resources.Resources;
	import resources.TextureAtlasName;
	import resources.TextureName;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class NoticePopup extends Popup
	{
		private const TAG:String = "[NoticePopup]";
		
		private var _panelWidth:Number;
		private var _panelHeight:Number;
		
		
		public function NoticePopup()
		{

		}
		
		public override function initialize():void
		{
			var panel:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.POPUP));
			var close:Button = new Button(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.BTN_CLOSE));
			var message:Button = new Button(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.TEXT_POPUP_MESSAGE));
			
			_panelWidth = panel.width;
			_panelHeight = panel.height;
			
			close.pivotX = close.width / 2;
			close.pivotY = close.height / 2;
			close.x = _panelWidth * 0.9;
			close.y = _panelHeight * 0.1;
			close.addEventListener(TouchEvent.TOUCH, onEndedCloseButton);
			
			var messageScale:Number = _panelWidth * 0.5 / message.width;
			message.width *= messageScale;
			message.height *= messageScale;
			message.pivotY = message.height / 2;
			message.x = _panelWidth * 0.1;
			message.y = _panelHeight * 0.9;
			message.addEventListener(TouchEvent.TOUCH, onEndedMessageButton);
			
			addChild(panel);
			addChild(close);
			addChild(message);
			
			super.initialize();
		}
		
		public function setContent(content:Texture):void
		{
			var contentImg:Image = new Image(content);
			var scale:Number = _panelWidth * 0.8 / contentImg.width;  
			
			contentImg.width *= scale;
			contentImg.height *= scale;
			contentImg.x = (_panelWidth / 2) - (contentImg.width / 2);
			contentImg.y = (_panelHeight / 2) - (contentImg.height / 2);
			
			addChild(contentImg);
		}
		
		private function onEndedCloseButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				PopupManager.instance.closePopup(this.name);
			}
		}
		
		private function onEndedMessageButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				DataManager.instance.settingData.addBannedPopup(this.name);
				PopupManager.instance.closePopup(this.name);
			}
		}
	}
}