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
	
	import user.LogInManager;
	
	[SWF(width="720", height="960", frameRate="60")]
	
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

		private function onExit(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, onDeactivate);
			
			PopupManager.dispose();
			SceneManager.dispose();
			DataManager.dispose();
			LogInManager.dispose();
			SoundManager.dispose();
			Resources.dispose();
			
			var notification:ScheduledNotificationExtension = new ScheduledNotificationExtension();
			notification.setNotification("Ding-dong!", "Hundred Blocks", "It's time to take a break!", 5/*temp*/);
		}
		
		private function onActivate(event:Event):void
		{
			SoundManager.wakeBgm();
		}
		
		private function onDeactivate(event:Event):void
		{
			SoundManager.stopAll();
			DataManager.export();
			LogInManager.export();
			
			var notification:ScheduledNotificationExtension = new ScheduledNotificationExtension();
			notification.setNotification("Ding-dong!", "Hundred Blocks", "It's time to take a break!", 5/*temp*/);
		}
	}
}