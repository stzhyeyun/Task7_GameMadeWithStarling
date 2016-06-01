package scene.titleScene
{
	import resources.Resources;
	import resources.TextureName;
	
	import scene.SceneManager;
	import scene.SceneName;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import ui.popup.PopupManager;
	import ui.popup.PopupName;

	public class TitleSceneUI extends Sprite
	{
		public function TitleSceneUI()
		{

		}
		
		public function initialize(stageWidth:Number, stageHeight:Number):void
		{
			// Title
			var title:Image = new Image(Resources.getTexture(TextureName.TITLE_GAME));
			var titleScale:Number = stageWidth * 0.8 / title.width;
			title.width *= titleScale;
			title.height *= titleScale;
			title.x = (stageWidth / 2) - (title.width / 2);
			title.y = stageHeight * 0.2;
			addChild(title);
			
			// Play
			var play:Button = new Button(Resources.getTexture(TextureName.BTN_PLAY));
			var playScale:Number = stageWidth * 0.3 / play.width;
			play.width *= playScale;
			play.height *= playScale;
			play.x = (stageWidth / 2) - (play.width / 2);
			play.y = stageHeight * 0.45;
			play.addEventListener(TouchEvent.TOUCH, onEndedPlayButton);
			addChild(play);
			
			// Rank
			var subBtnY:Number = stageHeight * 0.65;
			var rank:Button = new Button(Resources.getTexture(TextureName.BTN_RANK));
			var subButtonScale:Number = stageWidth * 0.2 / rank.width;
			rank.width *= subButtonScale;
			rank.height *= subButtonScale;
			rank.x = (stageWidth / 2) - (rank.width * 1.5);
			rank.y = subBtnY;
			rank.addEventListener(TouchEvent.TOUCH, onEndedRankButton);
			addChild(rank);
			
			// Setting
			var setting:Button = new Button(Resources.getTexture(TextureName.BTN_SETTING));
			setting.width *= subButtonScale;
			setting.height *= subButtonScale;
			setting.x = (stageWidth / 2) + (setting.width / 2);
			setting.y = subBtnY;
			setting.addEventListener(TouchEvent.TOUCH, onEndedSettingButton);
			addChild(setting);
			
			// Facebook button
			var facebook:Button = new Button(Resources.getTexture(TextureName.BTN_FACEBOOK));
			facebook.x = play.x + facebook.width * 1.5;
			facebook.y = play.y;
			addChild(facebook);	
		}
		
		private function onEndedPlayButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
			
			if (touch)
			{
				SceneManager.switchScene(SceneName.GAME);	
			}			
		}
		
		private function onEndedRankButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
			
			if (touch)
			{
				PopupManager.showPopup(this, PopupName.RANK);
			}	
		}
		
		private function onEndedSettingButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
			
			if (touch)
			{
				PopupManager.showPopup(this, PopupName.SETTING);	
			}	
		}
	}
}