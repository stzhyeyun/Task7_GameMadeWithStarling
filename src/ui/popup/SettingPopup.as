package ui.popup
{
	import gamedata.DataManager;
	
	import media.SoundManager;
	
	import resources.Resources;
	import resources.TextureName;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class SettingPopup extends Popup
	{
		private var _activeBgm:Boolean;
		private var _activeSound:Boolean;
		
		private var _banBgm:Image;
		private var _banSound:Image;
		
		public function SettingPopup()
		{
			
		}
		
		public override function initialize():void
		{
			var panel:Image = new Image(Resources.getTexture(TextureName.POPUP_MINI));
			var title:Image = new Image(Resources.getTexture(TextureName.TITLE_SETTING));
			var bgm:Button = new Button(Resources.getTexture(TextureName.BTN_BGM));
			var sound:Button = new Button(Resources.getTexture(TextureName.BTN_SOUND));
			_banBgm = new Image(Resources.getTexture(TextureName.BTN_CANCEL)); // IMG_BAN
			_banSound = new Image(Resources.getTexture(TextureName.BTN_CANCEL)); // IMG_BAN
			
			title.pivotX = title.width / 2;
			title.pivotY = title.height / 2;
			title.x = panel.width / 2;
			
			var btnY:Number = panel.height / 2;
			
			bgm.pivotX = bgm.width / 2;
			bgm.pivotY = bgm.height / 2;
			bgm.x = panel.width * 0.3;
			bgm.y = btnY;
				
			_banBgm.pivotX = bgm.width / 2;
			_banBgm.pivotY = bgm.height / 2;
			_banBgm.x = bgm.x;
			_banBgm.y = btnY;
			_banBgm.visible = false;
			
			sound.pivotX = sound.width / 2;
			sound.pivotY = sound.height / 2;
			sound.x = panel.width * 0.7;
			sound.y = btnY;
			
			_banSound.pivotX = sound.width / 2;
			_banSound.pivotY = sound.height / 2;
			_banSound.x = sound.x;
			_banSound.y = btnY;
			_banSound.visible = false;
			
			bgm.addEventListener(TouchEvent.TOUCH, onEndedBgmButton);
			sound.addEventListener(TouchEvent.TOUCH, onEndedSoundButton);
			_banBgm.addEventListener(TouchEvent.TOUCH, onEndedBanBgm);
			_banSound.addEventListener(TouchEvent.TOUCH, onEndedBanSound);
			
			addChild(panel);
			addChild(title);
			addChild(bgm);
			addChild(sound);
			addChild(_banBgm);
			addChild(_banSound);
			
			_activeBgm = DataManager.settingData.bgm;
			_activeSound = DataManager.settingData.sound;
			
			if (!_activeBgm)
			{
				_banBgm.visible = true;
			}
			
			if (!_activeSound)
			{
				_banSound.visible = true;
				
			}
			
			super.initialize();
		}
		
		private function onEndedBgmButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				DataManager.settingData.bgm = false;
				SoundManager.isBgmActive = false;
				SoundManager.stopBgm();
				_banBgm.visible = true;
			}
		}
		
		private function onEndedSoundButton(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				DataManager.settingData.sound = false;
				SoundManager.isSoundEffectActive = false;
				SoundManager.stopSoundEffect();
				_banSound.visible = true;
			}
		}
		
		private function onEndedBanBgm(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				DataManager.settingData.bgm = true;
				SoundManager.isBgmActive = true;
				SoundManager.wakeBgm();
				_banBgm.visible = false;
			}
		}
		
		private function onEndedBanSound(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				DataManager.settingData.sound = false;
				SoundManager.isSoundEffectActive = true;
				_banSound.visible = false;
			}
		}
	}
}