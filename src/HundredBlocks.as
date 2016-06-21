package
{
	import com.bamkie.ScheduledNotificationExtension;
	
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gamedata.DataManager;
	
	import media.SoundManager;
	
	import resources.Resources;
	
	import scene.SceneManager;
	
	import starling.core.Starling;
	
	import ui.popup.PopupManager;
	
	import user.UserManager;
	
	[SWF(width="720", height="960", frameRate="60", backgroundColor="#000000")]
	
	public class HundredBlocks extends Sprite
	{
		private const DAY:int = 86400;
		
		private var _starling:Starling;
		
		public function HundredBlocks()
		{
			super();
			
			_starling = new Starling(Main, stage, Screen.mainScreen.bounds);
			_starling.start();
			_starling.showStats = true; // debug
			
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
		}

		/**
		 * 어플리케이션 종료 시 리소스를 해제하고 푸시 알림을 등록합니다.
		 * @param event Event.EXITING
		 * 
		 */
		private function onExit(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, onDeactivate);
			
			DataManager.instance.dispose();
			UserManager.instance.dispose();
			PopupManager.instance.dispose();
			SceneManager.dispose();
			SoundManager.dispose();
			Resources.instance.dispose();
			
			var notification:ScheduledNotificationExtension = new ScheduledNotificationExtension();
			notification.setNotification("Ding-dong!", "Hundred Blocks", "It's time to take a break!", 5/*DAY*/);
		}
		
		/**
		 * 어플리케이션이 활성화되면 호출되는 함수입니다. 1. BGM 재생
		 * @param event Event.ACTIVATE
		 * 
		 */
		private function onActivate(event:Event):void
		{
			SoundManager.wakeBgm();
		}
		
		/**
		 * 어플리케이션이 비활성화되면 호출되는 함수입니다. 1. 사운드 정지 2. 데이터 로컬에 작성 3. 푸시 알림 등록
		 * @param event Event.DEACTIVATE
		 * 
		 */
		private function onDeactivate(event:Event):void
		{
			SoundManager.stopAll();
			DataManager.instance.export();
			UserManager.instance.export();
			
			var notification:ScheduledNotificationExtension = new ScheduledNotificationExtension();
			notification.setNotification("Ding-dong!", "Hundred Blocks", "It's time to take a break!", 5/*DAY*/);
		}
	}
}