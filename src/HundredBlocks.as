package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gamedata.DataManager;
	
	import media.SoundManager;
	
	import resources.Resources;
	
	import scene.SceneManager;
	
	import starling.core.Starling;
	
	import ui.popup.PopupManager;
	
	[SWF(width="720", height="960", frameRate="60")]
	
	public class HundredBlocks extends Sprite
	{
		private var _starling:Starling;
		
		public function HundredBlocks()
		{
			super();
		
			_starling = new Starling(Main, stage);
			_starling.start();
			_starling.showStats = true; // debug
			
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
		}

		private function onExit(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
			
			PopupManager.dispose();
			SceneManager.dispose();
			DataManager.dispose();
			SoundManager.dispose();
			Resources.dispose();
		}
	}
}